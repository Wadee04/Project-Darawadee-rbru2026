// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../components/shared_widgets.dart';

// หน้า Onboarding2 : หน้าแนะนำแอปหน้าที่สอง
// ใช้ layout ร่วม OnboardingPage ที่ responsive ทุกขนาดจอ (มือถือ - ไอแพด)
class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key, this.onSkip});

  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPage(
        imageAsset: 'assets/images/onboarding/onboarding2.png',
        titleTop: 'จองคิว',
        titleBottom: 'ได้ทุกที่ทุกเวลา',
        body: 'ไม่ต้องโทรจองหรือเดินทางมาต่อคิวหน้าคลินิก'
            'อีกต่อไป เพียงเปิดแอปทันตกรรมก็จองคิวได้ตลอดเวลา เลือก'
            'วันและเวลาที่ต้องการ และเลือกทันตแพทย์หรือสาขาที่สะดวก'
            'สำหรับคุณ ระบบจะยืนยันนัดให้กับคุณให้ทันทีการจองไม่มีขั้น'
            'ตอน ใช้งานได้ทันที',
        onSkip: onSkip,
      ),
    );
  }
}
