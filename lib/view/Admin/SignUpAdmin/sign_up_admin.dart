import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// SignUpAdminPage — หน้าลงทะเบียนแอดมิน
// ============================================================
class SignUpAdminPage extends StatefulWidget {
  const SignUpAdminPage({
    super.key,
    this.onBack,
    this.onNext,
  });

  final VoidCallback? onBack;
  final void Function({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  })? onNext;

  @override
  State<SignUpAdminPage> createState() => _SignUpAdminPageState();
}

class _SignUpAdminPageState extends State<SignUpAdminPage> {
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _showPassword = false;
  bool _showConfirm = false;

  bool get _canProceed =>
      _fullNameCtrl.text.trim().isNotEmpty &&
      _emailCtrl.text.trim().isNotEmpty &&
      _phoneCtrl.text.trim().isNotEmpty &&
      _passwordCtrl.text.isNotEmpty &&
      _confirmCtrl.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    for (final c in [
      _fullNameCtrl,
      _emailCtrl,
      _phoneCtrl,
      _passwordCtrl,
      _confirmCtrl,
    ]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (!_canProceed) return;

    if (_passwordCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'รหัสผ่านและยืนยันรหัสผ่านไม่ตรงกัน',
            style: TextStyle(fontFamily: 'Inter'),
          ),
          backgroundColor: AppColors.reddentbook,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    widget.onNext?.call(
      fullName: _fullNameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      password: _passwordCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFC5DEE8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- Back button ----
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: widget.onBack ?? () => Navigator.maybePop(context),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.rs(16),
                      MediaQuery.of(context).size.height * 0.01,
                      context.rs(16),
                      0,
                    ),
                    child: Icon(
                      Icons.chevron_left,
                      size: context.rs(28),
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),

              // ---- Body ----
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.rs(24),
                    context.rs(16),
                    context.rs(24),
                    context.rs(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---- Header ----
                      _AdminHeader(),

                      SizedBox(height: context.rs(24)),

                      // ---- ชื่อ - นามสกุล ----
                      _FieldLabel(label: 'ชื่อ - นามสกุล'),
                      SizedBox(height: context.rs(8)),
                      _InputField(
                        controller: _fullNameCtrl,
                        hintText: 'กรอกชื่อ - นามสกุล',
                        keyboardType: TextInputType.name,
                      ),

                      SizedBox(height: context.rs(14)),

                      // ---- อีเมล ----
                      _FieldLabel(label: 'อีเมล'),
                      SizedBox(height: context.rs(8)),
                      _InputField(
                        controller: _emailCtrl,
                        hintText: 'กรอกอีเมล',
                        keyboardType: TextInputType.emailAddress,
                      ),

                      SizedBox(height: context.rs(14)),

                      // ---- เบอร์โทรศัพท์ ----
                      _FieldLabel(label: 'เบอร์โทรศัพท์'),
                      SizedBox(height: context.rs(8)),
                      _InputField(
                        controller: _phoneCtrl,
                        hintText: 'กรอกเบอร์โทรศัพท์',
                        keyboardType: TextInputType.phone,
                      ),

                      SizedBox(height: context.rs(14)),

                      // ---- รหัสผ่าน ----
                      _FieldLabel(label: 'รหัสผ่าน'),
                      SizedBox(height: context.rs(8)),
                      _PasswordField(
                        controller: _passwordCtrl,
                        hintText: 'อย่างน้อย 8 ตัวอักษร',
                        obscure: !_showPassword,
                        onToggle: () =>
                            setState(() => _showPassword = !_showPassword),
                      ),

                      SizedBox(height: context.rs(14)),

                      // ---- ยืนยันรหัสผ่าน ----
                      _FieldLabel(label: 'ยืนยันรหัสผ่าน'),
                      SizedBox(height: context.rs(8)),
                      _PasswordField(
                        controller: _confirmCtrl,
                        hintText: 'ยืนยันรหัสผ่าน',
                        obscure: !_showConfirm,
                        onToggle: () =>
                            setState(() => _showConfirm = !_showConfirm),
                      ),

                      SizedBox(height: context.rs(28)),

                      // ---- ปุ่มถัดไป ----
                      SizedBox(
                        width: double.infinity,
                        height: context.rs(46),
                        child: ElevatedButton(
                          onPressed: _canProceed ? _handleNext : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.purple,
                            foregroundColor: AppColors.white,
                            disabledBackgroundColor: AppColors.registerButton,
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
                              fontSize: context.rs(14),
                              fontWeight: FontWeight.w600,
                            ),
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
    );
  }
}

// ============================================================
// _AdminHeader — icon shield + title + subtitle
// ============================================================
class _AdminHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---- icon shield ----
        Container(
          width: context.rs(48),
          height: context.rs(48),
          decoration: BoxDecoration(
            color: AppColors.purpleLight,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.shield_outlined,
            size: context.rs(26),
            color: AppColors.purple,
          ),
        ),

        SizedBox(width: context.rs(14)),

        // ---- text ----
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ลงทะเบียนแอดมิน',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(18),
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: context.rs(4)),
              Text(
                'สร้างบัญชีแอดมินสำหรับจัดการระบบคลินิก',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(12),
                  fontWeight: FontWeight.w400,
                  color: AppColors.textGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// _FieldLabel — label เหนือ input
// ============================================================
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: context.rs(13),
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),
    );
  }
}

// ============================================================
// _InputField — ช่องกรอกข้อความทั่วไป
// ============================================================
class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(14)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.rs(16)),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(13),
            color: AppColors.black,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(13),
              color: AppColors.inputHint,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: context.rs(14)),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _PasswordField — ช่องกรอกรหัสผ่านพร้อม eye toggle
// ============================================================
class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.hintText,
    required this.obscure,
    required this.onToggle,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(14)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.rs(16)),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: obscure,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(13),
                  color: AppColors.black,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(13),
                    color: AppColors.inputHint,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: context.rs(14)),
                ),
              ),
            ),
            GestureDetector(
              onTap: onToggle,
              child: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: context.rs(18),
                color: AppColors.inputHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
