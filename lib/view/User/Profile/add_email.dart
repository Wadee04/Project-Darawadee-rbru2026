import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../components/shared_widgets.dart';
import '../../../services/service_locator.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// AddEmailPage — หน้าเพิ่มอีเมล
// ============================================================
class AddEmailPage extends StatefulWidget {
  const AddEmailPage({
    super.key,
    this.onBack,
    this.onNext,
  });

  final VoidCallback? onBack;
  final void Function(String email)? onNext;

  @override
  State<AddEmailPage> createState() => _AddEmailPageState();
}

class _AddEmailPageState extends State<AddEmailPage> {
  final TextEditingController _emailCtrl = TextEditingController();
  bool get _canProceed => _emailCtrl.text.trim().isNotEmpty;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _emailCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _handleNext() async {
    if (!_canProceed) return;
    final email = _emailCtrl.text.trim();
    setState(() => _isSaving = true);
    try {
      await ServiceLocator.user.changeEmail(email);
      widget.onNext?.call(email);
      if (mounted) Navigator.maybePop(context);
    } on AuthException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
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
                title: 'เพิ่มอีเมล',
                onBack: widget.onBack,
              ),

              // ---- Body ----
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.rs(16),
                    context.rs(24),
                    context.rs(16),
                    context.rs(32),
                  ),
                  child: Column(
                    children: [
                      // ---- ช่องกรอกอีเมล ----
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.homeBackground,
                          borderRadius:
                              BorderRadius.circular(context.rs(16)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.rs(16),
                            vertical: context.rs(4),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.mail_outline,
                                size: context.rs(18),
                                color: AppColors.inputHint,
                              ),
                              SizedBox(width: context.rs(10)),
                              Expanded(
                                child: TextField(
                                  controller: _emailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: context.rs(13),
                                    color: AppColors.black,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'อีเมล',
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
                      ),

                      SizedBox(height: context.rs(16)),

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
