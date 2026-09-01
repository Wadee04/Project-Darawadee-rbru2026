import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

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
            // ---- Back button ----
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: context.rs(8),
                  top: context.rs(4),
                ),
                child: IconButton(
                  onPressed: widget.onBack ?? () => Navigator.maybePop(context),
                  icon: Icon(
                    Icons.chevron_left,
                    size: context.rs(28),
                    color: AppColors.black,
                  ),
                ),
              ),
            ),

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
                        fontSize: context.rs(18),
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
                      height: context.rs(50),
                      child: ElevatedButton(
                        onPressed: () => widget.onSignIn?.call(
                          _emailController.text.trim(),
                          _passwordController.text,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(context.rs(30)),
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

                    // Social buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialButton(
                          onTap: () {},
                          child: _GoogleIcon(size: context.rs(26)),
                        ),
                        SizedBox(width: context.rs(16)),
                        _SocialButton(
                          onTap: () {},
                          child: _LineIcon(size: context.rs(26)),
                        ),
                      ],
                    ),

                    SizedBox(height: context.rs(36)),
                  ],
                ),
              ),
            ),

            // ---- Register link ----
            Padding(
              padding: EdgeInsets.only(bottom: context.rs(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ยังไม่มีบัญชี? ',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(13),
                      color: AppColors.textGray,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onRegister,
                    child: Text(
                      'ลงทะเบียน',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(13),
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
                  color: AppColors.textGray,
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
        color: AppColors.textGray.withValues(alpha: 0.4),
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
          borderRadius: BorderRadius.circular(context.rs(12)),
          borderSide:
              const BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.rs(12)),
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
              color: AppColors.textGray,
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
// Social button wrapper (วงกลม outline)
// ============================================================
class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double sz = context.rs(52);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: sz,
        height: sz,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.inputBorder, width: 1.5),
          color: AppColors.white,
        ),
        child: Center(child: child),
      ),
    );
  }
}

// ============================================================
// Google "G" icon — วาดด้วย CustomPainter
// ============================================================
class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleIconPainter()),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double r = size.width / 2;
    final Offset c = Offset(r, r);
    final double sw = size.width * 0.18;
    final double arcR = r - sw / 2;
    final Rect rect = Rect.fromCircle(center: c, radius: arcR);

    Paint arcPaint(Color color) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.butt;

    // Red  (top-left to top-right)
    canvas.drawArc(rect, math.pi * 1.25, math.pi * 0.5, false,
        arcPaint(const Color(0xFFEA4335)));
    // Blue (top-right to bottom-right)
    canvas.drawArc(rect, math.pi * 1.75, math.pi * 0.5, false,
        arcPaint(const Color(0xFF4285F4)));
    // Yellow (bottom-right to bottom-left)
    canvas.drawArc(rect, math.pi * 0.25, math.pi * 0.5, false,
        arcPaint(const Color(0xFFFBBC05)));
    // Green (bottom-left to top-left)
    canvas.drawArc(rect, math.pi * 0.75, math.pi * 0.5, false,
        arcPaint(const Color(0xFF34A853)));

    // Horizontal bar (right arm of G)
    canvas.drawLine(
      Offset(c.dx, c.dy),
      Offset(c.dx + arcR, c.dy),
      Paint()
        ..color = const Color(0xFF4285F4)
        ..strokeWidth = sw
        ..strokeCap = StrokeCap.square,
    );
    // Cover upper half of bar to make G shape
    canvas.drawRect(
      Rect.fromLTWH(c.dx, c.dy - sw, arcR, sw),
      Paint()..color = AppColors.white,
    );
  }

  @override
  bool shouldRepaint(_GoogleIconPainter oldDelegate) => false;
}

// ============================================================
// LINE icon — วงกลมเขียว + "L"
// ============================================================
class _LineIcon extends StatelessWidget {
  const _LineIcon({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF06C755),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          'L',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: size * 0.55,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
    );
  }
}
