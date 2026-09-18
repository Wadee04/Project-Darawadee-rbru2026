import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../components/shared_widgets.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';
import 'phone_number.dart';

// ============================================================
// EmailOtpPage - หน้ากรอก OTP 6 หลักที่ส่งไปทางอีเมล
// ============================================================
class EmailOtpPage extends StatefulWidget {
  const EmailOtpPage({
    super.key,
    required this.email,
    required this.fullName,
  });

  final String email;
  final String fullName;

  @override
  State<EmailOtpPage> createState() => _EmailOtpPageState();
}

class _EmailOtpPageState extends State<EmailOtpPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  bool _isResending = false;
  int _resendCooldown = 60;

  String get _otp =>
      _controllers.map((c) => c.text).join();

  bool get _isComplete => _otp.length == 6;

  @override
  void initState() {
    super.initState();
    // auth.signUp ส่ง OTP ยืนยันอีเมลให้แล้ว ไม่ต้องเรียก signInWithOtp ซ้ำ
    _startCountdown();
    _focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    for (final c in _controllers) { c.dispose(); }
    for (final f in _focusNodes) { f.dispose(); }
    super.dispose();
  }

  // ย้อนกลับ focus เมื่อกด backspace บนช่องว่าง
  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
  }

  Future<void> _verifyOtp() async {
    if (!_isComplete || _isLoading) return;
    setState(() => _isLoading = true);
    try {
      // verify OTP กับ Supabase (type: signup)
      final response = await supabase.auth.verifyOTP(
        email: widget.email,
        token: _otp,
        type: OtpType.signup,
      );

      final userId = response.user?.id;
      if (userId != null) {
        // บันทึกข้อมูลผู้ใช้ลง users table
        // (trigger handle_new_user สร้างให้อัตโนมัติแล้ว upsert เพื่ออัปเดต full_name)
        await supabase.from('users').upsert({
          'id': userId,
          'email': widget.email,
          'full_name': widget.fullName,
        });
      }

      if (!mounted) return;
      // ไปหน้าถัดไป (กรอกเบอร์โทร)
      Navigator.pushAndRemoveUntil(
        context,
        noAnimRoute(const PhoneNumberPage()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      String message = 'รหัส OTP ไม่ถูกต้อง กรุณาลองใหม่';
      if (e.toString().contains('expired')) {
        message = 'รหัส OTP หมดอายุแล้ว กรุณาขอรหัสใหม่';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      // clear ช่องทั้งหมด
      for (final c in _controllers) { c.clear(); }
      _focusNodes[0].requestFocus();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    if (_resendCooldown > 0 || _isResending) return;
    setState(() => _isResending = true);
    try {
      await supabase.auth.resend(
        type: OtpType.signup,
        email: widget.email,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ส่งรหัส OTP ใหม่แล้ว กรุณาตรวจสอบอีเมล')),
      );
      // countdown 60 วินาที
      setState(() => _resendCooldown = 60);
      _startCountdown();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถส่งรหัสใหม่ได้ กรุณารอสักครู่')),
      );
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (_resendCooldown > 0) {
        setState(() => _resendCooldown--);
        _startCountdown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBarBack(
                  title: 'ยืนยันอีเมล',
                  onBack: () => Navigator.pop(context),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: context.rs(40)),

                        // ไอคอนอีเมล
                        Container(
                          width: context.rs(72),
                          height: context.rs(72),
                          decoration: BoxDecoration(
                            color: AppColors.purple.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.mark_email_read_outlined,
                            size: context.rs(36),
                            color: AppColors.purple,
                          ),
                        ),

                        SizedBox(height: context.rs(20)),

                        Text(
                          'ตรวจสอบอีเมลของคุณ',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(18),
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),

                        SizedBox(height: context.rs(8)),

                        Text(
                          'เราได้ส่งรหัส 6 หลักไปที่',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(13),
                            color: AppColors.textGray,
                          ),
                        ),

                        SizedBox(height: context.rs(4)),

                        Text(
                          widget.email,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(13),
                            fontWeight: FontWeight.w600,
                            color: AppColors.purple,
                          ),
                        ),

                        SizedBox(height: context.rs(36)),

                        // ---- 6 ช่อง OTP ----
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (i) {
                            return SizedBox(
                              width: context.rs(44),
                              height: context.rs(52),
                              child: KeyboardListener(
                                focusNode: FocusNode(),
                                onKeyEvent: (e) => _onKeyEvent(i, e),
                                child: TextField(
                                  controller: _controllers[i],
                                  focusNode: _focusNodes[i],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: context.rs(20),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    contentPadding: EdgeInsets.zero,
                                    filled: true,
                                    fillColor: AppColors.purple
                                        .withValues(alpha: 0.05),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          context.rs(12)),
                                      borderSide: const BorderSide(
                                        color: AppColors.inputBorder,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          context.rs(12)),
                                      borderSide: const BorderSide(
                                        color: AppColors.purple,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    if (val.isNotEmpty && i < 5) {
                                      _focusNodes[i + 1].requestFocus();
                                    }
                                    setState(() {});
                                    // auto verify เมื่อกรอกครบ
                                    if (_isComplete) _verifyOtp();
                                  },
                                ),
                              ),
                            );
                          }),
                        ),

                        SizedBox(height: context.rs(36)),

                        // ปุ่มยืนยัน
                        SizedBox(
                          width: double.infinity,
                          height: context.rs(46),
                          child: ElevatedButton(
                            onPressed: _isComplete && !_isLoading
                                ? _verifyOtp
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.purple,
                              disabledBackgroundColor:
                                  AppColors.registerButton,
                              foregroundColor: AppColors.white,
                              disabledForegroundColor: AppColors.textGray,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(context.rs(16)),
                              ),
                            ),
                            child: Text(
                              'ยืนยัน',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: context.rs(15),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: context.rs(20)),

                        // ส่งรหัสใหม่
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ไม่ได้รับรหัส? ',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: context.rs(13),
                                color: AppColors.textGray,
                              ),
                            ),
                            GestureDetector(
                              onTap: _resendCooldown == 0 ? _resendOtp : null,
                              child: Text(
                                _resendCooldown > 0
                                    ? 'ส่งใหม่ใน ${_resendCooldown}s'
                                    : 'ส่งรหัสใหม่',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: context.rs(13),
                                  fontWeight: FontWeight.w600,
                                  color: _resendCooldown > 0
                                      ? AppColors.textGray
                                      : AppColors.purple,
                                  decoration: _resendCooldown == 0
                                      ? TextDecoration.underline
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // loading overlay
        if (_isLoading) const ToothLoadingOverlay(),
      ],
    );
  }
}
