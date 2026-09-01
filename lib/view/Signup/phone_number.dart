import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';
import 'birthday.dart';

class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll('-', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 3) buffer.write('-');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

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
            
            SizedBox(height: context.rs(30)),

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
                      _PhoneInputFormatter(),
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
                        fontWeight: FontWeight.w500,
                        color: AppColors.registerButton,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(
                          left: context.rs(14),
                          right: context.rs(8),
                        ),
                        child: SvgPicture.asset(
                            'assets/images/signup/phonelinear.svg',
                            width: context.rs(20),
                            height: context.rs(20),
                            colorFilter: ColorFilter.mode(
                              AppColors.textGray,
                              BlendMode.srcIn,
                            ),
                          ),
                      ),
                      prefixIconConstraints: const BoxConstraints(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: context.rs(16),
                        vertical: context.rs(18),
                      ),
                      filled: false,
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(context.rs(16)),
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

                  SizedBox(height: context.rs(30)),

                  // ---- ปุ่มถัดไป ----
                  SizedBox(
                    height: context.rs(40),
                    child: ElevatedButton(
                      onPressed: _canProceed
                          ? () {
                              widget.onNext
                                  ?.call(_phoneController.text.trim());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const BirthdayPage(),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canProceed
                            ? AppColors.purple
                            : AppColors.registerButton,
                        disabledBackgroundColor: AppColors.registerButton,
                        foregroundColor: _canProceed
                            ? AppColors.white
                            : AppColors.black,
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
                          color: _canProceed
                              ? AppColors.white
                              : AppColors.black,
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
