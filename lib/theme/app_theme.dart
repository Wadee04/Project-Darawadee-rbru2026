import 'package:flutter/material.dart';

import 'app_colors.dart';

/// ธีมหลักของแอป (ตั้งค่าฟอนต์และสีพื้นฐาน)
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.white,
      // ใช้ฟอนต์ Libertinus Math (ฝังในแอป) เป็นฟอนต์หลักทั้งแอป
      fontFamily: 'LibertinusMath',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.purple,
      ),
    );
  }
}
