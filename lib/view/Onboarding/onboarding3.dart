// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../components/shared_widgets.dart';

// หน้า Onboarding3 : หน้าแนะนำแอปหน้าที่สาม (หน้าสุดท้าย)
// ใช้ layout ร่วม OnboardingPage ที่ responsive ทุกขนาดจอ (มือถือ - ไอแพด)
class Onboarding3 extends StatelessWidget {
  const Onboarding3({super.key, this.onSkip});

  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPage(
        imageAsset: 'assets/images/onboarding/onboarding3.png',
        titleTop: 'เช็คอินง่าย',
        titleBottom: 'ด้วย QR Code',
        body: 'เมื่อถึงวันนัด เพียงแสดง QR Code ประจำตัว '
            'จากแอปที่จุดประชาสัมพันธ์ เจ้าหน้าที่จะเช็คอิน'
            'ให้กันทีโดยไม่ต้องกรอกเอกสารซ้ำหรือรอเรียก'
            'ชื่อ ช่วยลดเวลารอคอยแลทำให้ทุกขั้นตอน'
            'ราบรื่นยิ่งขึ้น',
        onSkip: onSkip,
      ),
    );
  }
}
