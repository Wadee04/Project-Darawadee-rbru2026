import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../components/shared_widgets.dart';
import '../../../services/service_locator.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// ChangeEmailPage — หน้าเปลี่ยนอีเมลที่ใช้เข้าสู่ระบบ
// ============================================================
class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({
    super.key,
    this.onBack,
    this.onNext,
  });

  final VoidCallback? onBack;
  final void Function(String newEmail)? onNext;

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final _newEmailCtrl = TextEditingController();
  final _confirmEmailCtrl = TextEditingController();

  bool get _canProceed =>
      _newEmailCtrl.text.trim().isNotEmpty &&
      _confirmEmailCtrl.text.trim().isNotEmpty;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _newEmailCtrl.addListener(() => setState(() {}));
    _confirmEmailCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _newEmailCtrl.dispose();
    _confirmEmailCtrl.dispose();
    super.dispose();
  }

  void _handleNext() async {
    if (!_canProceed) return;

    final newEmail = _newEmailCtrl.text.trim();
    final confirmEmail = _confirmEmailCtrl.text.trim();

    if (newEmail != confirmEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'อีเมลใหม่และยืนยันอีเมลไม่ตรงกัน',
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

    setState(() => _isSaving = true);
    try {
      await ServiceLocator.user.changeEmail(newEmail);
      widget.onNext?.call(newEmail);
      if (mounted) Navigator.maybePop(context);
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
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
                title: 'เปลี่ยนอีเมลที่ใช้เข้าสู่ระบบ',
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
                      // ---- อีเมลใหม่ ----
                      _FieldLabel(label: 'อีเมลใหม่'),
                      SizedBox(height: context.rs(8)),
                      _EmailField(
                        controller: _newEmailCtrl,
                        hintText: 'กรอกอีเมลใหม่',
                      ),

                      SizedBox(height: context.rs(16)),

                      // ---- ยืนยันอีเมลใหม่ ----
                      _FieldLabel(label: 'ยืนยันอีเมลใหม่'),
                      SizedBox(height: context.rs(8)),
                      _EmailField(
                        controller: _confirmEmailCtrl,
                        hintText: 'กรอกอีเมลใหม่อีกครั้ง',
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
// _EmailField — ช่องกรอกอีเมล
// ============================================================
class _EmailField extends StatelessWidget {
  const _EmailField({
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

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
                keyboardType: TextInputType.emailAddress,
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
          ],
        ),
      ),
    );
  }
}
