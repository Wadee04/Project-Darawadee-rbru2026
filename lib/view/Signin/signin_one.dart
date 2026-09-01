import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';
import '../OTP/otp.dart';
import '../Signup/signup.dart';

// ============================================================
// SignInOne - หน้า Sign In
// ============================================================
class SignInOne extends StatefulWidget {
  const SignInOne({super.key, this.onBack, this.onSignIn, this.onRegister});

  final VoidCallback? onBack;
  final void Function(String email, String password)? onSignIn;
  final VoidCallback? onRegister;

  @override
  State<SignInOne> createState() => _SignInOneState();
}

class _SignInOneState extends State<SignInOne> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ---- AppBar ----
            const AppBarBack(title: ''),

            // ---- Scrollable content ----
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: context.rs(16)),

                    // Logo
                    _DentBookLogo(fontSize: context.rs(34)),

                    SizedBox(height: context.rs(24)),

                    // Welcome
                    Text(
                      'ยินดีต้อนรับ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: context.rs(4)),
                    Text(
                      'เข้าสู่ระบบเพื่อใช้งาน Dentbook',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(13),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textGray,
                        height: 1.4,
                      ),
                    ),

                    SizedBox(height: context.rs(24)),

                    // Email
                    _FieldLabel(label: 'อีเมล'),
                    SizedBox(height: context.rs(6)),
                    _InputField(
                      controller: _emailController,
                      hintText: 'กรอกอีเมล',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: context.rs(16)),

                    // Password
                    _FieldLabel(label: 'รหัสผ่าน'),
                    SizedBox(height: context.rs(6)),
                    _InputField(
                      controller: _passwordController,
                      hintText: 'กรอกรหัสผ่าน',
                      obscureText: _obscurePassword,
                      suffixIcon: GestureDetector(
                        onTap: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                        child: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: context.rs(20),
                          color: AppColors.textGray,
                        ),
                      ),
                    ),

                    SizedBox(height: context.rs(28)),

                    // Sign in button
                    SizedBox(
                      width: double.infinity,
                      height: context.rs(46),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OTPPage(
                                target: _emailController.text.trim(),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(context.rs(16)),
                          ),
                        ),
                        child: Text(
                          'เข้าสู่ระบบ',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(15),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: context.rs(20)),

                    // Or divider
                    _OrDivider(),

                    SizedBox(height: context.rs(16)),

                     // Social icons
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         _GoogleIcon(),
                         SizedBox(width: context.rs(30)),
                         _LineIcon(),
                       ],
                     ),

                    SizedBox(height: context.rs(36)),
                  ],
                ),
              ),
            ),

            // ---- Register link ----
            Padding(
              padding: EdgeInsets.only(bottom: context.rs(48)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ยังไม่มีบัญชี? ',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(12),
                      color: AppColors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignUp(),
                        ),
                      );
                    },
                    child: Text(
                      'ลงทะเบียน',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(12),
                        fontWeight: FontWeight.w600,
                        color: AppColors.purple,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.purple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Logo "DentBook" (ม่วง + ส้ม) บนพื้นขาว
// ============================================================
class _DentBookLogo extends StatelessWidget {
  const _DentBookLogo({required this.fontSize});
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              height: 1.0,
            ),
            children: const [
              TextSpan(
                text: 'Dent',
                style: TextStyle(color: AppColors.purple),
              ),
              TextSpan(
                text: 'Book',
                style: TextStyle(color: AppColors.orange),
              ),
            ],
          ),
        ),
        SizedBox(height: context.rs(6)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _divLine(context),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rs(8)),
              child: Text(
                'จองคิวง่ายๆ ดูแลฟัน',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: fontSize * 0.28,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.4,
                  color: AppColors.purple,
                ),
              ),
            ),
            _divLine(context),
          ],
        ),
      ],
    );
  }

  Widget _divLine(BuildContext context) => Container(
        width: context.rs(22),
        height: 1,
        color: AppColors.purple.withValues(alpha: 0.4),
      );
}

// ============================================================
// Field Label
// ============================================================
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: context.rs(13),
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
      ),
    );
  }
}

// ============================================================
// Input Field
// ============================================================
class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: context.rs(14),
        color: AppColors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: context.rs(13),
          color: AppColors.inputHint,
        ),
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: EdgeInsets.only(right: context.rs(16)),
                child: suffixIcon,
              )
            : null,
        suffixIconConstraints: const BoxConstraints(),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.rs(16),
          vertical: context.rs(18),
        ),
        filled: false,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.rs(16)),
          borderSide:
              const BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.rs(16)),
          borderSide:
              const BorderSide(color: AppColors.purple, width: 1.5),
        ),
      ),
    );
  }
}

// ============================================================
// "หรือ" Divider
// ============================================================
class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(height: 1, color: AppColors.inputBorder),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.rs(12)),
          child: Text(
            'หรือ',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(13),
              color: AppColors.black,
            ),
          ),
        ),
        Expanded(
          child: Container(height: 1, color: AppColors.inputBorder),
        ),
      ],
    );
  }
}

// ============================================================
// Google icon
// ============================================================
class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SvgPicture.asset(
          'assets/images/signin/google.svg',
          width: context.rs(24),
          height: context.rs(24),
          fit: BoxFit.contain,
        ),
      );
  }
}

// ============================================================
// LINE icon — วงกลมเขียว + "L"
// ============================================================
class _LineIcon extends StatelessWidget {
  const _LineIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SvgPicture.asset(
          'assets/images/signin/line.svg',
          width: context.rs(24),
          height: context.rs(24),
          fit: BoxFit.contain,
        ),
      );
  }
}
