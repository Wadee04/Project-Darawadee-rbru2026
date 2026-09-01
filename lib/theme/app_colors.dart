import 'package:flutter/material.dart';

/// รวมสีที่ใช้ในแอปไว้ที่เดียว เพื่อให้แก้สีได้ง่ายและใช้ซ้ำได้ทุกหน้า
class AppColors {
  AppColors._();

  // ---- สีพื้นฐาน ----
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color black20 = Color(0x33000000); // #000000 at 20%

  // ---- สีหลัก ----
  static const Color purple = Color(0xFF4E4C85); // ม่วงหลัก
  static const Color purpleDark = Color(0xFF3D3B6E); // ม่วงเข้ม
  static const Color purpleLight = Color(0xFFD0CFF1); // ม่วงอ่อน
  static const Color orange = Color(0xFFFF8D28); // ส้มหลัก
  static const Color orangeLight = Color(0xFFFCD6B5); // ส้มอ่อน
  static const Color blue = Color(0xFFA7E7FF); // ฟ้า
  static const Color blueLight = Color(0xFFEAF0FB); // ฟ้าอ่อน
  static const Color reddentbook = Color(0xFFDD191D); // แดง


  // ---- หน้า Intro ----
  static const Color cream = Color(0xFFF8E9DB);
  static const Color mint = Color(0xFFCDE4E9);
  static const Color brownGray = Color(0xFF786D6D);
  static const Color grayLine = Color(0xFF9DB5BA);

  // ---- หน้า Onboarding ----
  static const Color lavender = Color(0xFFF8F3FF);

  // ---- หน้า Select Account Type ----
  static const Color textGray = Color(0xFF848484);
  static const Color userCardBg = Color(0x26A7E7FF);
  static const Color adminCardBg = Color(0x1AFFAD28);

  // ---- หน้า Getting Started ----
  static const Color textOnPurple = Color(0xCCFFFFFF);

  // ---- ปุ่ม ----
  static const Color buttonSecondary = Color(0xFFECEBF3);

  // ---- หน้า Sign In / Sign Up ----
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputHint = Color(0xFFBDBDBD);
  static const Color registerButton = Color(0xFFD9D9D9); // ปุ่มลงทะเบียน (เทา)

  // ---- หน้า Home ----
  static const Color homeBackground = Color(0xFFF5F4FA);
  static const Color cardAppointment1 = Color(0xFF4E4C85); // gradient start
  static const Color cardAppointment2 = Color(0xFF6B68C0); // gradient end
  static const Color navBarSelected = Color(0xFF4E4C85);
  static const Color navBarUnselected = Color(0xFFAAAAAA);
}
