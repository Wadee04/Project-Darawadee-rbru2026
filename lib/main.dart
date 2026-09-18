import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'theme/app_theme.dart';
import 'view/Admin/ProfileAdmin/patient_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://djfwfpvdnebctiqmbxpr.supabase.co',
    publishableKey: 'sb_publishable_GLjtPKzwTBktnsYCpowzYg_-3JY3NFC',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wadee',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // เริ่มที่หน้า SelectAccountType เสมอ
      // AppRouter จะ navigate ไป Home ถ้า login อยู่แล้ว
      home: const SelectAccountType(),
    );
  }
}
