// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import 'intro2.dart';

// หน้า Intro1 : หน้า Splash แรกของแอป
// แสดงพื้นหลังไล่สีเปล่า ๆ ประมาณ 1 วินาที แล้วเปลี่ยนไปหน้า Intro2 อัตโนมัติ
class Intro1 extends StatefulWidget {
  const Intro1({super.key});

  @override
  State<Intro1> createState() => _Intro1State();
}

class _Intro1State extends State<Intro1> {
  @override
  void initState() {
    super.initState();
    // ตั้งเวลา 1 วินาที แล้วค่อยเปลี่ยนหน้า
    Future.delayed(const Duration(seconds: 1), () {
      // เช็คก่อนว่าหน้านี้ยังอยู่บนจอไหม กันแอป error
      if (!mounted) return;
      // ใช้ pushReplacement เพื่อไม่ให้กดย้อนกลับมาหน้า Splash ได้
      Navigator.pushReplacement(
        context,
        noAnimRoute(const Intro2()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ยืดเต็มจอ
        width: double.infinity,
        height: double.infinity,
        // พื้นหลังไล่สีจากบน (ครีม) ลงล่าง (ฟ้าอมเขียว)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.cream, AppColors.mint],
          ),
        ),
      ),
    );
  }
}
