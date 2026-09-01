import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/responsive.dart';
import '../Signin/signin_one.dart';
import '../Signup/signup.dart';

class GettingStartedUser extends StatelessWidget {
  final VoidCallback? onRegister;
  final VoidCallback? onSignIn;

  const GettingStartedUser({super.key, this.onRegister, this.onSignIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // Purple header
          Container(
            width: double.infinity,
            height: context.rs(264),
            padding: EdgeInsets.fromLTRB(
              context.rs(24),
              context.rs(110),
              context.rs(24),
              context.rs(31),
            ),
            decoration: BoxDecoration(
              color: AppColors.purple,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(context.rs(35)),
                bottomRight: Radius.circular(context.rs(35)),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'เริ่มต้นใช้งาน',
                  style: AppText.promptTitle.copyWith(
                    fontSize: context.rs(24),
                  ),
                ),
                SizedBox(height: context.rs(8)),
                Text(
                  'เข้าสู่ระบบหรือลงทะเบียนใหม่ เพื่อจองคิว\nติดตามนัดหมาย และรับ QR Code\nสำหรับเช็คอินหน้าคลินิก',
                  textAlign: TextAlign.center,
                  style: AppText.promptBody.copyWith(
                    fontSize: context.rs(16),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tooth mascot
                  Image.asset(
                    'assets/images/onboarding/toothmascot.png',
                    width: context.rs(223.36),
                    height: context.rs(174.28),
                  ),
                  SizedBox(height: context.rs(32)),

                  // Title
                  Text(
                    'จองคิวทันตกรรม\nง่ายกว่าที่เคย',
                    textAlign: TextAlign.center,
                    style: AppText.promptHeading.copyWith(
                      fontSize: context.rs(20),
                    ),
                  ),
                  SizedBox(height: context.rs(8)),

                  // Subtitle
                  Text(
                    'ค้นหาคลินิก เลือกวันที่และเวลาที่สะดวก\nแล้วจองคิวได้ใน ไม่กี่ขั้นตอน',
                    textAlign: TextAlign.center,
                    style: AppText.promptSmall.copyWith(
                      fontSize: context.rs(14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: context.rs(51)),
          // Buttons
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.rs(24),
              0,
              context.rs(24),
              context.rs(48),
            ),
            child: Column(
              children: [
                // ลงทะเบียน
                SizedBox(
                  width: double.infinity,
                  height: context.rs(49),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignUp(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(AppColors.purple),
                      surfaceTintColor: WidgetStateProperty.all(AppColors.purple),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.rs(30)),
                        ),
                      ),
                      elevation: WidgetStateProperty.all(0),
                    ),
                    child: Text(
                      'ลงทะเบียน',
                      style: AppText.promptButton.copyWith(
                        fontSize: context.rs(16),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.rs(26)),

                // เข้าสู่ระบบ
                SizedBox(
                  width: double.infinity,
                  height: context.rs(49),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInOne(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.rs(30)),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'เข้าสู่ระบบ',
                      style: AppText.promptButtonSecondary.copyWith(
                        fontSize: context.rs(16),
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}