import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';
import '../HomeScreen/home_page_one.dart';

// ============================================================
// OTPPage - หน้ากรอกรหัสยืนยันตัวตน
// ============================================================
class OTPPage extends StatefulWidget {
  const OTPPage({
    super.key,
    required this.target,     // อีเมลที่ส่ง OTP ไป
    this.otpLength = 6,
    this.resendCooldown = 60,
    this.onBack,
    this.onNext,              // callback เมื่อกด "ถัดไป" ส่ง OTP string กลับ
    this.onResend,            // callback เมื่อกด "ขอรหัสใหม่"
  });

  final String target;
  final int otpLength;
  final int resendCooldown;
  final VoidCallback? onBack;
  final void Function(String otp)? onNext;
  final VoidCallback? onResend;

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  late final List<FocusNode> _keyListenerNodes;

  Timer? _timer;
  late int _secondsLeft;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(widget.otpLength, (_) => FocusNode());
    _keyListenerNodes =
        List.generate(widget.otpLength, (_) => FocusNode());
    _secondsLeft = widget.resendCooldown;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    for (final f in _keyListenerNodes) {
      f.dispose();
    }
    super.dispose();
  }

  // ---- Timer ----
  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = widget.resendCooldown);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  // ---- OTP ----
  String get _otpValue => _controllers.map((c) => c.text).join();
  bool get _isFilled => _otpValue.length == widget.otpLength;

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

  void _handleResend() {
    if (_secondsLeft > 0) return;
    widget.onResend?.call();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- AppBar ----
            const AppBarBack(title: 'กรอกรหัสยืนยันตัวตน'),

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
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: '6614631011@rbru.ac.th ',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(13),
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                        children: [
                          TextSpan(
                            text: widget.target,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: context.rs(13),
                              fontWeight: FontWeight.w400,
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                     ),
 
                    SizedBox(height: context.rs(30)),

                    // ---- OTP boxes ----
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(widget.otpLength, (i) {
                        return Padding(
                          padding: EdgeInsets.only(
                            right: i < widget.otpLength - 1
                                ? context.rs(10)
                                : 0,
                          ),
                          child: _OTPBox(
                            controller: _controllers[i],
                            focusNode: _focusNodes[i],
                            keyListenerFocusNode: _keyListenerNodes[i],
                            onChanged: (v) => _onChanged(i, v),
                            onKeyEvent: (e) => _onKeyEvent(i, e),
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
                        onPressed: _isFilled
                            ? () {
                                widget.onNext?.call(_otpValue);
                                Navigator.pushReplacement(
                                  context,
                                  noAnimRoute(const HomePageOne()),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFilled
                              ? AppColors.purple
                              : AppColors.registerButton,
                          disabledBackgroundColor: AppColors.registerButton,
                          foregroundColor: _isFilled
                              ? AppColors.white
                              : AppColors.textGray,
                          disabledForegroundColor: AppColors.textGray,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(context.rs(30)),
                          ),
                        ),
                        child: Text(
                          'ถัดไป',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(15),
                            fontWeight: FontWeight.w500,
                            color: _isFilled ? AppColors.white : AppColors.black,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: context.rs(30)),

                    // ---- Resend timer ----
                    _secondsLeft > 0
                        ? RichText(
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
                        : GestureDetector(
                            onTap: _handleResend,
                            child: Text(
                              'รับรหัสผ่านใหม่อีกครั้ง',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: context.rs(12),
                                fontWeight: FontWeight.w600,
                                color: AppColors.purple,
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
              borderSide: const BorderSide(
                color: AppColors.orange,
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
