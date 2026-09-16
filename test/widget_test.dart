import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wadee/main.dart';
import 'package:wadee/view/Onboarding/Onboarding1.dart';

void main() {
  // ทดสอบว่าแอปเปิดขึ้นมาที่หน้า Intro1 (หน้า Splash) ได้ปกติ
  testWidgets('เปิดแอปแล้วเริ่มที่หน้า Splash', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // หน้าแรกเป็น Scaffold ว่าง ๆ (พื้นหลังไล่สี) ต้องแสดงได้โดยไม่ error
    expect(find.byType(MaterialApp), findsOneWidget);

    // รอให้ timer (1 วินาที) ของ Intro1 และ Intro2 ทำงานจนครบ
    // เพื่อไม่ให้เหลือ timer ค้างตอนจบ test
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
  });

  // ทดสอบว่าหน้า Onboarding1 แสดงข้อความและปุ่มตามดีไซน์
  testWidgets('หน้า Onboarding1 แสดงข้อความครบ', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Onboarding1()));

    expect(find.text('ยินดีต้อนรับสู่'), findsOneWidget);
    expect(find.text('คลินิกทันตกรรม'), findsOneWidget);
    expect(find.text('ข้าม'), findsOneWidget);
  });
}
