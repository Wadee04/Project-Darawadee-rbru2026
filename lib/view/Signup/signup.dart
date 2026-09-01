import 'package:flutter/material.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

// ============================================================
// SignUp - หน้าลงทะเบียน
// ============================================================
class SignUp extends StatefulWidget {
  const SignUp({super.key, this.onBack, this.onSignUp, this.onSignIn});

  final VoidCallback? onBack;
  final void Function(String fullName, String email, String password)? onSignUp;
  final VoidCallback? onSignIn;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
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

                    // Title
                    Text(
                      'ลงทะเบียน',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(14),
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: context.rs(4)),
                    Text(
                      'ลงทะเบียนเพื่อใช้งาน Dentbook',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(13),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textGray,
                        height: 1.4,
                      ),
                    ),

                    SizedBox(height: context.rs(24)),

                    // ชื่อ - นามสกุล
                    _FieldLabel(label: 'ชื่อ - นามสกุล'),
                    SizedBox(height: context.rs(6)),
                    _InputField(
                      controller: _nameController,
                      hintText: 'กรอกชื่อ-นามสกุล',
                      keyboardType: TextInputType.name,
                    ),

                    SizedBox(height: context.rs(14)),

                    // อีเมล
                    _FieldLabel(label: 'อีเมล'),
                    SizedBox(height: context.rs(6)),
                    _InputField(
                      controller: _emailController,
                      hintText: 'กรอกอีเมล',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: context.rs(14)),

                    // ตั้งรหัสผ่าน
                    _FieldLabel(label: 'ตั้งรหัสผ่าน'),
                    SizedBox(height: context.rs(6)),
                    _InputField(
                      controller: _passwordController,
                      hintText: 'ตั้งรหัสผ่าน',
                      obscureText: _obscurePassword,
                      suffixIcon: _EyeToggle(
                        obscured: _obscurePassword,
                        onTap: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),

                    SizedBox(height: context.rs(14)),

                    // ยืนยันรหัสผ่าน
                    _FieldLabel(label: 'ยืนยันรหัสผ่าน'),
                    SizedBox(height: context.rs(6)),
                    _InputField(
                      controller: _confirmController,
                      hintText: 'ยืนยันรหัสผ่าน',
                      obscureText: _obscureConfirm,
                      suffixIcon: _EyeToggle(
                        obscured: _obscureConfirm,
                        onTap: () => setState(
                            () => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),

                    SizedBox(height: context.rs(25)),

                    // ปุ่มลงทะเบียน
                    SizedBox(
                      width: double.infinity,
                      height: context.rs(46),
                      child: ElevatedButton(
                        onPressed: () => widget.onSignUp?.call(
                          _nameController.text.trim(),
                          _emailController.text.trim(),
                          _passwordController.text,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.registerButton,
                          foregroundColor: AppColors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(context.rs(16)),
                          ),
                        ),
                        child: Text(
                          'ลงทะเบียน',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(16),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: context.rs(28)),
                  ],
                ),
              ),
            ),

            // ---- Sign in link ----
            Padding(
              padding: EdgeInsets.only(bottom: context.rs(48)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'มีบัญชีอยู่แล้ว? ',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(12),
                      color: AppColors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onSignIn,
                    child: Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(12),
                        fontWeight: FontWeight.w500,
                        color: AppColors.purple,
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
// Logo "DentBook" (ม่วง + ส้ม) พร้อม tagline
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
              padding: EdgeInsets.symmetric(horizontal: context.rs(6)),
              child: Text(
                'จองคิวง่าย ดูแลฟัน',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: fontSize * 0.29,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
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
        height: 0.5,
        color: AppColors.purple.withValues(alpha: 0.7),
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
          fontSize: context.rs(14),
          fontWeight: FontWeight.w400,
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
        fontSize: context.rs(13),
        color: AppColors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: context.rs(12),
          color: AppColors.inputHint,
        ),
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: EdgeInsets.only(right: context.rs(12)),
                child: suffixIcon,
              )
            : null,
        suffixIconConstraints: const BoxConstraints(),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.rs(16),
          vertical: context.rs(14),
        ),
        filled: false,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.rs(16)),
          borderSide:
              const BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.rs(16)),
          borderSide: const BorderSide(color: AppColors.purple, width: 1.5),
        ),
      ),
    );
  }
}

// ============================================================
// Eye toggle (show/hide password)
// ============================================================
class _EyeToggle extends StatelessWidget {
  const _EyeToggle({required this.obscured, required this.onTap});
  final bool obscured;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        size: context.rs(18),
        color: AppColors.textGray,
      ),
    );
  }
}
