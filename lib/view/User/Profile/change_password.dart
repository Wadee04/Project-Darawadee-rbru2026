import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../components/shared_widgets.dart';
import '../../../services/service_locator.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// ChangePasswordPage — หน้าเปลี่ยนรหัสผ่าน
// ============================================================
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({
    super.key,
    this.onBack,
    this.onNext,
  });

  final VoidCallback? onBack;
  final void Function({
    required String currentPassword,
    required String newPassword,
  })? onNext;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  bool get _canProceed =>
      _currentCtrl.text.isNotEmpty &&
      _newCtrl.text.isNotEmpty &&
      _confirmCtrl.text.isNotEmpty;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _currentCtrl.addListener(() => setState(() {}));
    _newCtrl.addListener(() => setState(() {}));
    _confirmCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _handleNext() async {
    if (!_canProceed) return;

    if (_newCtrl.text != _confirmCtrl.text) {
      _showErrorSnackbar('รหัสผ่านใหม่และยืนยันรหัสผ่านไม่ตรงกัน');
      return;
    }

    setState(() => _isSaving = true);
    try {
      await ServiceLocator.user.changePassword(
        currentPassword: _currentCtrl.text,
        newPassword: _newCtrl.text,
      );
      widget.onNext?.call(
        currentPassword: _currentCtrl.text,
        newPassword: _newCtrl.text,
      );
      if (mounted) Navigator.maybePop(context);
    } on AuthException catch (e) {
      if (mounted) _showErrorSnackbar(e.message);
    } catch (e) {
      if (mounted) _showErrorSnackbar('เกิดข้อผิดพลาด: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Inter'),
        ),
        backgroundColor: AppColors.reddentbook,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
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
              // ---- AppBar ----
              AppBarBack(
                title: 'เปลี่ยนรหัสผ่าน',
                onBack: widget.onBack,
              ),

              // ---- Body ----
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.rs(16),
                    context.rs(20),
                    context.rs(16),
                    context.rs(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---- รหัสผ่านปัจจุบัน ----
                      _FieldLabel(label: 'รหัสผ่านปัจจุบัน'),
                      SizedBox(height: context.rs(8)),
                      _PasswordField(
                        controller: _currentCtrl,
                        hintText: 'รหัสผ่านปัจจุบัน',
                        obscure: !_showCurrent,
                        showClearButton: _currentCtrl.text.isNotEmpty,
                        onToggleVisibility: () =>
                            setState(() => _showCurrent = !_showCurrent),
                        onClear: () {
                          _currentCtrl.clear();
                          setState(() {});
                        },
                      ),

                      SizedBox(height: context.rs(16)),

                      // ---- รหัสผ่านใหม่ ----
                      _FieldLabel(label: 'รหัสผ่านใหม่'),
                      SizedBox(height: context.rs(8)),
                      _PasswordField(
                        controller: _newCtrl,
                        hintText: 'รหัสผ่านใหม่',
                        obscure: !_showNew,
                        onToggleVisibility: () =>
                            setState(() => _showNew = !_showNew),
                      ),

                      SizedBox(height: context.rs(16)),

                      // ---- ยืนยันรหัสผ่าน ----
                      _FieldLabel(label: 'ยืนยันรหัสผ่าน'),
                      SizedBox(height: context.rs(8)),
                      _PasswordField(
                        controller: _confirmCtrl,
                        hintText: 'ยืนยันรหัสผ่าน',
                        obscure: !_showConfirm,
                        onToggleVisibility: () =>
                            setState(() => _showConfirm = !_showConfirm),
                      ),

                      SizedBox(height: context.rs(24)),

                      // ---- ปุ่มถัดไป ----
                      SizedBox(
                        width: double.infinity,
                        height: context.rs(46),
                        child: ElevatedButton(
                          onPressed: (_canProceed && !_isSaving) ? _handleNext : null,
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
// _FieldLabel — label เหนือช่อง input
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
// _PasswordField — ช่องกรอกรหัสผ่าน
// ============================================================
class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.hintText,
    required this.obscure,
    required this.onToggleVisibility,
    this.showClearButton = false,
    this.onClear,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final VoidCallback onToggleVisibility;
  final bool showClearButton;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(14)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.rs(14)),
        child: Row(
          children: [
            // ---- lock icon ----
            Icon(
              Icons.lock_outline,
              size: context.rs(18),
              color: AppColors.inputHint,
            ),
            SizedBox(width: context.rs(10)),
            // ---- text field ----
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
                  contentPadding: EdgeInsets.symmetric(
                    vertical: context.rs(14),
                  ),
                ),
              ),
            ),
            // ---- clear button (เฉพาะ current password เมื่อมีข้อความ) ----
            if (showClearButton && onClear != null)
              GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.cancel,
                  size: context.rs(18),
                  color: AppColors.inputHint,
                ),
              ),
            // ---- eye toggle ----
            GestureDetector(
              onTap: onToggleVisibility,
              child: Padding(
                padding: EdgeInsets.only(left: context.rs(8)),
                child: Icon(
                  obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: context.rs(18),
                  color: AppColors.inputHint,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
