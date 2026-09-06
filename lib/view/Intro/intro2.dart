// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../theme/responsive.dart';
import '../Onboarding/onboarding_screen.dart';

// หน้า Intro2 : หน้า Splash ที่แสดงโลโก้และชื่อแบรนด์ "Dentbook"
// แสดงประมาณ 1 วินาที แล้วเปลี่ยนไปหน้า Onboarding1 อัตโนมัติ
class Intro2 extends StatefulWidget {
  const Intro2({super.key});

  @override
  State<Intro2> createState() => _Intro2State();
}

class _Intro2State extends State<Intro2> {
  @override
  void initState() {
    super.initState();
    // รอ 1 วินาที แล้วเปลี่ยนไปหน้า Onboarding (แบบสไลด์ได้)
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        noAnimRoute(const OnboardingScreen()),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // โหลดรูป onboarding ล่วงหน้า (precache) ระหว่างที่ยังอยู่หน้า Intro
    // เพื่อให้พอสไลด์เข้าหน้า onboarding รูปขึ้นทันที ไม่ pop-in
    precacheImage(
      const AssetImage('assets/images/onboarding/onboarding1.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/images/onboarding/onboarding2.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/images/onboarding/onboarding3.png'),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ยืดเต็มจอ กันไม่ให้ Container หดตามความกว้างของลูก
        width: double.infinity,
        height: double.infinity,
        // พื้นหลังไล่สีเหมือนหน้า Intro1
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.cream, AppColors.mint],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ดันเนื้อหาให้อยู่กลางค่อนไปทางบน
              const Spacer(flex: 3),

              // โลโก้ (รูปฟัน + ประกาย)
              SvgPicture.asset(
                'assets/images/intro/intro2_logo.svg',
                width: context.rs(154),
                fit: BoxFit.contain,
              ),
              SizedBox(height: context.rs(12)),

              // ชื่อแบรนด์
              Text(
                'Dentbook',
                style: AppText.intro.copyWith(
                  fontSize: context.rs(24),
                  color: AppColors.brownGray,
                ),
              ),
              SizedBox(height: context.rs(10)),

              // เส้นคั่นสั้น ๆ ใต้ชื่อแบรนด์
              Container(
                width: context.rs(50),
                height: context.rs(2),
                color: AppColors.grayLine,
              ),
              SizedBox(height: context.rs(8)),

              // ข้อความ tagline
              Text(
                'YOUR SMILE, SIMPLIFIED',
                style: AppText.intro.copyWith(
                  fontSize: context.rs(15),
                  letterSpacing: 2,
                  color: AppColors.brownGray,
                ),
              ),

              const Spacer(flex: 4),

              // Loading indicator
              SizedBox(
                width: context.rs(24),
                height: context.rs(24),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.brownGray),
                ),
              ),
              SizedBox(height: context.rs(40)),
            ],
          ),
        ),
      ),
    );
  }
}
