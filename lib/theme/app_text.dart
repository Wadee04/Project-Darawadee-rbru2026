import 'package:flutter/material.dart';

import 'app_colors.dart';

/// รวมสไตล์ตัวอักษรที่ใช้บ่อย เพื่อให้ทุกหน้าใช้ฟอนต์และขนาดเหมือนกัน
///
/// ฟอนต์ทั้งหมดถูกฝังในแอป (assets/fonts) ไม่ต้องโหลดผ่านเน็ตตอนรัน
/// - Onboarding : Inter
/// - Intro      : Libertinus Math
class AppText {
  AppText._();

  static const String _inter = 'Inter';
  static const String _libertinus = 'LibertinusMath';

  // หัวข้อใหญ่ (ตัวหนา)
  static const TextStyle title = TextStyle(
    fontFamily: _inter,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
  );

  // เนื้อความทั่วไป
  static const TextStyle body = TextStyle(
    fontFamily: _inter,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.white,
  );

  // ข้อความปุ่ม "ข้าม"
  static const TextStyle skip = TextStyle(
    fontFamily: _inter,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  // ข้อความในหน้า Intro
  static const TextStyle intro = TextStyle(
    fontFamily: _libertinus,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  // ---- ฟอนต์ Prompt ----
  static const String _prompt = 'Prompt';

  // หัวข้อใหญ่ (Prompt)
  static const TextStyle promptTitle = TextStyle(
    fontFamily: _prompt,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  // หัวข้อรอง (Prompt)
  static const TextStyle promptHeading = TextStyle(
    fontFamily: _prompt,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.purpleDark,
    height: 1.4,
  );

  // เนื้อความรอง (Prompt)
  static const TextStyle promptBody = TextStyle(
    fontFamily: _prompt,
    fontSize: 13,
    color: AppColors.textOnPurple,
    height: 1.5,
  );

  // เนื้อความเล็ก (Prompt)
  static const TextStyle promptSmall = TextStyle(
    fontFamily: _prompt,
    fontSize: 12,
    color: AppColors.textGray,
    height: 1.5,
  );

  // ข้อความปุ่ม (Prompt)
  static const TextStyle promptButton = TextStyle(
    fontFamily: _prompt,
    fontSize: 16,
    color: AppColors.white,
  );

  // ข้อความปุ่มรอง (Prompt)
  static const TextStyle promptButtonSecondary = TextStyle(
    fontFamily: _prompt,
    fontSize: 16,
    color: AppColors.purpleDark,
  );
}
