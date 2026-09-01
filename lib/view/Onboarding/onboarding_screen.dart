// ignore_for_file: file_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../components/shared_widgets.dart';
import 'onboarding1.dart';
import 'onboarding2.dart';
import 'onboarding3.dart';
import 'select_account_type.dart';

// ScrollBehavior ที่อนุญาตให้ "ลากด้วยเมาส์" ได้ด้วย (นอกเหนือจากนิ้วสัมผัส)
// จำเป็นตอนรันบนเว็บ/เดสก์ท็อป เพราะปกติ Flutter จะไม่ให้ลาก PageView ด้วยเมาส์
class _DragScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

// หน้าครอบ Onboarding ทั้งหมด
// ใช้ PageView ให้ผู้ใช้ปัด (สไลด์) ไปหน้าถัดไป/ย้อนกลับได้
// ลำดับ: Onboarding1 -> Onboarding2 -> Onboarding3 (และปัดกลับได้)
//
// จุดบอกหน้า (PageDots) ถูกย้ายมาไว้ที่นี่ที่เดียว โดยผูกกับ PageController
// จริง ๆ ทำให้ (1) อัปเดตตามหน้าที่ปัดเสมอ และ (2) แตะที่จุดเพื่อกระโดดไป
// หน้านั้นได้
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  static const int _pageCount = 4;
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    if (index >= _pageCount) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _goToSelectAccountType() {
    _pageController.animateToPage(
      3,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  bool _canDragBack() => _currentIndex < 3;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenHeight <= 700;
    final double dotsBottom = isSmallScreen ? 16 : 48;

    return Scaffold(
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: _DragScrollBehavior(),
            child: PageView(
              controller: _pageController,
              physics: _NoBackScrollPhysics(
                canDragBack: _canDragBack,
                parent: const BouncingScrollPhysics(),
              ),
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              children: [
                Onboarding1(onSkip: _goToSelectAccountType),
                Onboarding2(onSkip: _goToSelectAccountType),
                Onboarding3(onSkip: _goToSelectAccountType),
                const SelectAccountType(),
              ],
            ),
          ),

          if (_currentIndex < 3)
            Positioned(
              left: 0,
              right: 0,
              bottom: dotsBottom,
              child: SafeArea(
                top: false,
                child: PageDots(
                  count: 3,
                  activeIndex: _currentIndex,
                  onDotTap: _goToPage,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NoBackScrollPhysics extends ScrollPhysics {
  final bool Function() canDragBack;
  const _NoBackScrollPhysics({
    required this.canDragBack,
    super.parent,
  });

  @override
  _NoBackScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _NoBackScrollPhysics(
      canDragBack: canDragBack,
      parent: buildParent(ancestor),
    );
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    if (!canDragBack()) {
      return position.pixels >= position.maxScrollExtent;
    }
    return super.shouldAcceptUserOffset(position);
  }
}
