import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../theme/responsive.dart';

// ============================================================
// BrandLogo - โลโก้แบรนด์ "DentBook"
// ============================================================

class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.fontSize = 30,
    this.tagline = 'คลินิกทันตกรรม ดูแลฟัน',
  });

  final double fontSize;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    // ปรับขนาดตามหน้าจอ
    final double size = context.rs(fontSize);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: size,
              fontWeight: FontWeight.w800,
              height: 1.0,
            ),
            children: const [
              TextSpan(
                text: 'Dent',
                style: TextStyle(color: AppColors.white),
              ),
              TextSpan(
                text: 'Book',
                style: TextStyle(color: AppColors.orange),
              ),
            ],
          ),
        ),
        SizedBox(height: context.rs(8)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _line(context),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rs(8)),
              child: Text(
                tagline,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: size * 0.24,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                  color: AppColors.white.withValues(alpha: 0.85),
                ),
              ),
            ),
            _line(context),
          ],
        ),
      ],
    );
  }

  Widget _line(BuildContext context) {
    return Container(
      width: context.rs(22),
      height: 1,
      color: AppColors.white.withValues(alpha: 0.6),
    );
  }
}

// ============================================================
// OnboardingPage - เนื้อหาหน้า Onboarding แบบใช้ซ้ำได้
// ============================================================

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.imageAsset,
    required this.titleTop,
    required this.titleBottom,
    required this.body,
    this.onSkip,
  });

  final String imageAsset;
  final String titleTop;
  final String titleBottom;
  final String body;
  final VoidCallback? onSkip;

  static const double _tabletBreakpoint = 600;
  static const double _maxContentWidth = 480;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final bool isTablet = width >= _tabletBreakpoint;
        final double contentWidth = isTablet ? _maxContentWidth : width;
        final double imageWidth = (contentWidth * 0.85).clamp(0.0, 380.0);
        final double imageHeight = imageWidth * 261 / 349;
        // ขนาดฟอนต์อิงค่าดีไซน์ แล้วปรับสเกลตามหน้าจอ
        final double titleFontSize = context.rs(26);
        final double bodyFontSize = context.rs(16);

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.white, AppColors.purple],
              stops: [0.45, 0.45],
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(0, -0.27),
                child: Image.asset(
                  imageAsset,
                  width: imageWidth,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => SizedBox(
                    width: imageWidth,
                    height: imageHeight,
                  ),
                ),
              ),
              Positioned(
                top: height / 2 + imageHeight / 2,
                left: 0,
                right: 0,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titleTop,
                            style: AppText.title.copyWith(
                              fontSize: titleFontSize,
                              color: AppColors.lavender,
                            ),
                          ),
                          Text(
                            titleBottom,
                            style: AppText.title.copyWith(fontSize: titleFontSize),
                          ),
                          SizedBox(height: height * 0.022),
                          Text(
                            body,
                            style: AppText.body.copyWith(fontSize: bodyFontSize),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: onSkip,
                    child: Text(
                      'ข้าม',
                      style: AppText.skip.copyWith(fontSize: context.rs(14)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// PageDots - จุดบอกหน้า (page indicator)
// ============================================================

class PageDots extends StatelessWidget {
  const PageDots({
    super.key,
    this.count = 3,
    required this.activeIndex,
    this.onDotTap,
  });

  final int count;
  final int activeIndex;
  final ValueChanged<int>? onDotTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        final dot = _buildDot(context, isActive);
        return Padding(
          padding: EdgeInsets.only(right: index == count - 1 ? 0 : context.rs(6)),
          child: onDotTap == null
              ? dot
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onDotTap!(index),
                  child: dot,
                ),
        );
      }),
    );
  }

  Widget _buildDot(BuildContext context, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: isActive ? context.rs(15) : context.rs(4),
      height: context.rs(4),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.white
            : AppColors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

// ============================================================
// PillButton - ปุ่มทรงแคปซูล
// ============================================================

enum PillButtonVariant {
  primary,
  secondary,
}

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = PillButtonVariant.primary,
    this.height = 52,
    this.fontSize = 15,
  });

  final String label;
  final VoidCallback? onPressed;
  final PillButtonVariant variant;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final bool isPrimary = variant == PillButtonVariant.primary;
    final Color bg =
        isPrimary ? AppColors.purpleDark : AppColors.buttonSecondary;
    final Color fg =
        isPrimary ? AppColors.white : AppColors.purpleDark;

    // ปรับขนาดปุ่มตามหน้าจอ
    final double h = context.rs(height);

    return SizedBox(
      width: double.infinity,
      height: h,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(h / 2),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(fontSize),
                fontWeight: FontWeight.w500,
                color: fg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
