import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'view/Intro/intro1.dart';
import 'view/Signin/signin_one.dart';
import 'view/Signup/signup.dart';
import 'view/OTP/otp.dart';

void main() {
  runApp(const MyApp());
}

// คลาสหลักของแอป
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wadee',
      debugShowCheckedModeBanner: false, // ซ่อนป้าย debug มุมขวาบน
      theme: AppTheme.light,
      // เริ่มที่หน้า Intro1 เป็นหน้าแรก
      home: const Intro1(),
    );
  }
}
