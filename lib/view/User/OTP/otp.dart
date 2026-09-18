import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../components/shared_widgets.dart';
import '../../../supabase_client.dart' show supabase;
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';
import '../Signup/phone_number.dart';

// ============================================================
// OTPPage - หน้ากรอกรหัสยืนยันตัวตน
// ============================================================
class OTPPage extends StatefulWidget {
  const OTPPage({
    super.key,
    required this.target,
    required this.fullName,
    this.otpLength = 6,
    this.resendCooldown = 60,
    this.onBack,
  });

  final String target;
  final String fullName;
  final int otpLength;
  final int resendCooldown;
  final VoidCallback? onBack;

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  late final List<FocusNode> _keyListenerNodes;

  Timer? _timer;
  late int _secondsLeft;
  bool _isLoading = false;
  bool _isResending = false;
  String? _verifiedUserId;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.otpLength,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.otpLength, (_) => FocusNode());
    _keyListenerNodes = List.generate(widget.otpLength, (_) => FocusNode());
    _secondsLeft = widget.resendCooldown;
    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _focusNodes.isNotEmpty) {
        _focusNodes.first.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (final focusNode in _keyListenerNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // ---- Timer ----
  void _startTimer() {
    _timer?.cancel();
    if (_secondsLeft <= 0) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  // ---- OTP ----
  String get _otpValue =>
      _controllers.map((controller) => controller.text).join();
  bool get _isFilled => _otpValue.length == widget.otpLength;
  bool get _canVerify => (_isFilled || _verifiedUserId != null) && !_isLoading;

  void _onChanged(int index, String value) {
    if (value.length == 1 && index < widget.otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyOtp() async {
    if (!_canVerify) return;
    setState(() => _isLoading = true);

    try {
      var userId = _verifiedUserId;
      if (userId == null) {
        final response = await supabase.auth.verifyOTP(
          email: widget.target,
          token: _otpValue,
          type: OtpType.signup,
        );

        userId = response.user?.id;
        if (userId == null) {
          throw StateError('Signup OTP verification returned no user');
        }
        _verifiedUserId = userId;
      }

      await supabase.from('users').upsert({
        'id': userId,
        'email': widget.target,
        'full_name': widget.fullName,
      });

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        noAnimRoute(const PhoneNumberPage()),
        (route) => false,
      );
    } catch (error) {
      if (!mounted) return;

      if (_verifiedUserId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'ยืนยันอีเมลแล้ว แต่บันทึกข้อมูลผู้ใช้ไม่สำเร็จ กรุณากดถัดไปอีกครั้ง',
            ),
          ),
        );
      } else {
        final isExpired = error.toString().toLowerCase().contains('expired');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isExpired
                  ? 'รหัส OTP หมดอายุแล้ว กรุณาขอรหัสใหม่'
                  : 'รหัส OTP ไม่ถูกต้อง กรุณาลองใหม่',
            ),
          ),
        );
        for (final controller in _controllers) {
          controller.clear();
        }
        _focusNodes.first.requestFocus();
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleResend() async {
    if (_secondsLeft > 0 || _isResending || _verifiedUserId != null) return;
    setState(() => _isResending = true);

    try {
      await supabase.auth.resend(type: OtpType.signup, email: widget.target);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ส่งรหัส OTP ใหม่แล้ว กรุณาตรวจสอบอีเมล')),
      );
      setState(() => _secondsLeft = widget.resendCooldown);
      _startTimer();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถส่งรหัสใหม่ได้ กรุณารอสักครู่')),
      );
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
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
                // ---- AppBar ----
                AppBarBack(title: 'กรอกรหัสยืนยันตัวตน', onBack: widget.onBack),

                // ---- Content ----
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: context.rs(30)),

                        // Subtitle
                        Text(
                          'คุณจะได้รับรหัสยืนยันตัวตนผ่านทางอีเมล',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(14),
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: context.rs(2)),
                        Text(
                          widget.target,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(13),
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),

                        SizedBox(height: context.rs(30)),

                        // ---- OTP boxes ----
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(widget.otpLength, (index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index < widget.otpLength - 1
                                    ? context.rs(10)
                                    : 0,
                              ),
                              child: _OTPBox(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                keyListenerFocusNode: _keyListenerNodes[index],
                                onChanged: (value) => _onChanged(index, value),
                                onKeyEvent: (event) =>
                                    _onKeyEvent(index, event),
                              ),
                            );
                          }),
                        ),

                        SizedBox(height: context.rs(28)),

                        // ---- ปุ่มถัดไป ----
                        SizedBox(
                          width: double.infinity,
                          height: context.rs(40),
                          child: ElevatedButton(
                            onPressed: _canVerify ? _verifyOtp : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.purple,
                              disabledBackgroundColor: AppColors.registerButton,
                              foregroundColor: AppColors.white,
                              disabledForegroundColor: AppColors.textGray,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  context.rs(30),
                                ),
                              ),
                            ),
                            child: Text(
                              'ถัดไป',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: context.rs(15),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: context.rs(30)),

                        // ---- Resend timer ----
                        if (_secondsLeft > 0)
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: context.rs(12),
                                color: AppColors.textGray,
                              ),
                              children: [
                                const TextSpan(text: 'ขอรหัสใหม่ได้อีก '),
                                TextSpan(
                                  text: '$_secondsLeft',
                                  style: const TextStyle(
                                    color: AppColors.reddentbook,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const TextSpan(text: ' วินาที'),
                              ],
                            ),
                          )
                        else
                          GestureDetector(
                            onTap: _isResending || _verifiedUserId != null
                                ? null
                                : _handleResend,
                            child: Text(
                              _isResending
                                  ? 'กำลังส่งรหัสใหม่...'
                                  : 'รับรหัสผ่านใหม่อีกครั้ง',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: context.rs(12),
                                fontWeight: FontWeight.w600,
                                color: _isResending || _verifiedUserId != null
                                    ? AppColors.textGray
                                    : AppColors.purple,
                                decorationColor: AppColors.purple,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isLoading) const ToothLoadingOverlay(),
      ],
    );
  }
}

// ============================================================
// OTP box — กล่องรับตัวเลขแต่ละช่อง
// ============================================================
class _OTPBox extends StatelessWidget {
  const _OTPBox({
    required this.controller,
    required this.focusNode,
    required this.keyListenerFocusNode,
    required this.onChanged,
    required this.onKeyEvent,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode keyListenerFocusNode;
  final void Function(String) onChanged;
  final void Function(KeyEvent) onKeyEvent;

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: keyListenerFocusNode,
      onKeyEvent: onKeyEvent,
      child: SizedBox(
        width: context.rs(35),
        height: context.rs(40),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: onChanged,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(16),
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.rs(10)),
              borderSide: const BorderSide(
                color: AppColors.inputBorder,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.rs(10)),
              borderSide: const BorderSide(color: AppColors.orange, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}
