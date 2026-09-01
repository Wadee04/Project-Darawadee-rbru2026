import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

// ============================================================
// PhoneNumberPage - หน้ากรอกเบอร์โทรศัพท์
// ============================================================
class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({
    super.key,
    this.onBack,
    this.onNext, // callback ส่งเบอร์โทรกลับ
  });

  final VoidCallback? onBack;
  final void Function(String phoneNumber)? onNext;

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final _phoneController = TextEditingController();

  bool get _canProceed => _phoneController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
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
            const AppBarBack(title: 'เบอร์โทรศัพท์'),

            // ---- Content ----
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: context.rs(20)),

                  // ---- Phone input ----
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onChanged: (_) => setState(() {}),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(14),
                      color: AppColors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: '091-2345678',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(14),
                        color: AppColors.inputHint,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(
                          left: context.rs(14),
                          right: context.rs(8),
                        ),
                        child: Icon(
                          Icons.phone_outlined,
                          size: context.rs(18),
                          color: AppColors.inputHint,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: context.rs(16),
                        vertical: context.rs(14),
                      ),
                      filled: false,
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(context.rs(30)),
                        borderSide: const BorderSide(
                          color: AppColors.inputBorder,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(context.rs(30)),
                        borderSide: const BorderSide(
                          color: AppColors.purple,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: context.rs(16)),

                  // ---- ปุ่มถัดไป ----
                  SizedBox(
                    height: context.rs(48),
                    child: ElevatedButton(
                      onPressed: _canProceed
                          ? () => widget.onNext
                              ?.call(_phoneController.text.trim())
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.registerButton,
                        disabledBackgroundColor: AppColors.registerButton,
                        foregroundColor: AppColors.black,
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
                        ),
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
