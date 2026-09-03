import 'package:flutter/material.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

// ============================================================
// GenderPage - หน้าเลือกเพศ
// ============================================================
enum Gender { male, female, other }

class GenderPage extends StatefulWidget {
  const GenderPage({
    super.key,
    this.onBack,
    this.onNext,
    this.onSkip,
  });

  final VoidCallback? onBack;
  final void Function(Gender gender)? onNext;
  final VoidCallback? onSkip;

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  Gender? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ---- AppBar ----
            const AppBarBack(title: ''),

            // ---- Content ----
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: context.rs(8)),

                    // ---- Mascot ----
                    SizedBox(
                      width: context.rs(160),
                      height: context.rs(160),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow circle
                          Container(
                            width: context.rs(160),
                            height: context.rs(160),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFFEACD85),
                                  const Color(0xFFEACD85).withValues(alpha: 0),
                                ],
                              ),
                            ),
                          ),
                          Image.asset(
                            'assets/images/signup/mascot3.png',
                            width: context.rs(94),
                            height: context.rs(94),
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: context.rs(16)),

                    // ---- Title ----
                    Text(
                      'คุณเป็นเพศอะไร?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(18),
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: context.rs(6)),
                    Text(
                      'เพื่อให้เราสามารถขอมวลประสบการณ์\nที่เหมาะสมสำหรับคุณ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(12),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textGray,
                        height: 1.6,
                      ),
                    ),

                    SizedBox(height: context.rs(28)),

                    // ---- Gender cards ----
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _GenderCard(
                          gender: Gender.male,
                          label: 'ชาย',
                          iconBg: const Color(0xFFD6EEF8),
                          iconColor: const Color(0xFF5B9EC9),
                          icon: Icons.person_outline,
                          isSelected: _selected == Gender.male,
                          onTap: () => setState(() => _selected = Gender.male),
                        ),
                        SizedBox(width: context.rs(12)),
                        _GenderCard(
                          gender: Gender.female,
                          label: 'หญิง',
                          iconBg: const Color(0xFFFCE4EF),
                          iconColor: const Color(0xFFD07097),
                          icon: Icons.person_outline,
                          isSelected: _selected == Gender.female,
                          onTap: () =>
                              setState(() => _selected = Gender.female),
                          isFemale: true,
                        ),
                        SizedBox(width: context.rs(12)),
                        _GenderCard(
                          gender: Gender.other,
                          label: 'อื่นๆ',
                          iconBg: AppColors.purpleLight,
                          iconColor: AppColors.purple,
                          icon: Icons.person_outline,
                          isSelected: _selected == Gender.other,
                          onTap: () =>
                              setState(() => _selected = Gender.other),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ---- Bottom buttons (fixed) ----
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.rs(24),
                0,
                context.rs(24),
                context.rs(24),
              ),
              child: Column(
                children: [
                  // ปุ่มถัดไป
                  SizedBox(
                    width: double.infinity,
                    height: context.rs(40),
                    child: ElevatedButton(
                      onPressed: _selected != null
                          ? () => widget.onNext?.call(_selected!)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        disabledBackgroundColor: AppColors.registerButton,
                        foregroundColor: AppColors.white,
                        disabledForegroundColor: AppColors.textGray,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.rs(30)),
                        ),
                      ),
                      child: Text(
                        'ถัดไป',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(15),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: context.rs(10)),

                  // ข้ามไปก่อน
                  GestureDetector(
                    onTap: widget.onSkip,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: context.rs(6)),
                      child: Text(
                        'ข้ามไปก่อน',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(13),
                          fontWeight: FontWeight.w500,
                          color: AppColors.textGray,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.textGray,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _GenderCard — card เลือกเพศ
// ============================================================
class _GenderCard extends StatelessWidget {
  const _GenderCard({
    required this.gender,
    required this.label,
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.isFemale = false,
  });

  final Gender gender;
  final String label;
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFemale;

  @override
  Widget build(BuildContext context) {
    final double cardWidth = context.rs(90);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: cardWidth,
        padding: EdgeInsets.symmetric(
          vertical: context.rs(14),
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(context.rs(14)),
          border: Border.all(
            color: isSelected ? AppColors.purple : AppColors.inputBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon circle
            Container(
              width: context.rs(52),
              height: context.rs(52),
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isFemale
                    ? _FemaleIcon(
                        size: context.rs(30),
                        color: iconColor,
                      )
                    : Icon(
                        icon,
                        size: context.rs(30),
                        color: iconColor,
                      ),
              ),
            ),

            SizedBox(height: context.rs(8)),

            // Label
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(13),
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.purple : AppColors.black,
              ),
            ),

            SizedBox(height: context.rs(8)),

            // Radio dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: context.rs(18),
              height: context.rs(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.purple
                      : AppColors.inputBorder,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: context.rs(9),
                        height: context.rs(9),
                        decoration: const BoxDecoration(
                          color: AppColors.purple,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _FemaleIcon — ไอคอนผู้หญิงที่วาดด้วย CustomPainter
// (ผมยาว ต่างจาก Icons.person ที่เป็นผู้ชาย)
// ============================================================
class _FemaleIcon extends StatelessWidget {
  const _FemaleIcon({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _FemalePainter(color: color)),
    );
  }
}

class _FemalePainter extends CustomPainter {
  const _FemalePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.09
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final double cx = size.width / 2;
    final double headR = size.width * 0.22;

    // Head
    canvas.drawCircle(Offset(cx, headR * 1.1), headR, paint);

    // Hair — arc บน
    final Path hairPath = Path()
      ..moveTo(cx - headR * 1.3, headR * 1.1)
      ..cubicTo(
        cx - headR * 1.6,
        -headR * 0.4,
        cx + headR * 1.6,
        -headR * 0.4,
        cx + headR * 1.3,
        headR * 1.1,
      );
    canvas.drawPath(hairPath, paint);

    // Body (shoulders arc)
    final double bodyTop = headR * 2.4;
    final Path bodyPath = Path()
      ..moveTo(cx - headR * 1.5, size.height)
      ..cubicTo(
        cx - headR * 1.5,
        bodyTop,
        cx - headR * 0.7,
        bodyTop,
        cx,
        bodyTop,
      )
      ..cubicTo(
        cx + headR * 0.7,
        bodyTop,
        cx + headR * 1.5,
        bodyTop,
        cx + headR * 1.5,
        size.height,
      );
    canvas.drawPath(bodyPath, paint);
  }

  @override
  bool shouldRepaint(_FemalePainter old) => old.color != color;
}
