// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../components/shared_widgets.dart';

// หน้า Onboarding1 : หน้าแนะนำแอปหน้าแรก
// ใช้ layout ร่วม OnboardingPage ที่ responsive ทุกขนาดจอ (มือถือ - ไอแพด)
class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key, this.onSkip});

  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPage(
        imageAsset: 'assets/images/onboarding/onboarding1.png',
        titleTop: 'ยินดีต้อนรับสู่',
        titleBottom: 'คลินิกทันตกรรม',
        body: 'คลินิกทันตกรรมครบวงจร ดูแลตั้งแต่การตรวจสุขภาพฟันทั่วไป '
            'ขูดหินปูน อุดฟัน ไปจนถึงจัดฟันและฟอกสีฟันโดยทีมทันตแพทย์'
            'ผู้เชี่ยวชาญเฉพาะทางพร้อมเครื่องมือมาตรฐานสากล '
            'เพื่อให้คุณมั่นใจได้ทุกครั้งที่เข้ารับบริการ',
        onSkip: onSkip,
      ),
    );
  }
}
