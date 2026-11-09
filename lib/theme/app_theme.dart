import 'package:flutter/material.dart';

import 'app_colors.dart';

/// ไม่มี animation เวลาเปลี่ยนหน้า
class _NoTransitionBuilder extends PageTransitionsBuilder {
  const _NoTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => child;
}

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
      // ปิด animation เวลาเปลี่ยนหน้าทุก platform
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _NoTransitionBuilder(),
          TargetPlatform.iOS: _NoTransitionBuilder(),
          TargetPlatform.fuchsia: _NoTransitionBuilder(),
          TargetPlatform.linux: _NoTransitionBuilder(),
          TargetPlatform.macOS: _NoTransitionBuilder(),
          TargetPlatform.windows: _NoTransitionBuilder(),
        },
      ),
    );
  }
}
