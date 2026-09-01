import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

// ============================================================
// BookAnAppointmentTwo - หน้าเลือกสถานการณ์
// ============================================================
class BookAnAppointmentTwo extends StatelessWidget {
  const BookAnAppointmentTwo({
    super.key,
    this.onBack,
    this.onSelectCase1,  // มีอาการแต่ไม่รู้สาเหตุ
    this.onSelectCase2,  // ทราบสาเหตุแล้ว
  });

  final VoidCallback? onBack;
  final VoidCallback? onSelectCase1;
  final VoidCallback? onSelectCase2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ---- AppBar ----
            SizedBox(
              height: context.rs(52),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: context.rs(4),
                    child: IconButton(
                      onPressed:
                          onBack ?? () => Navigator.maybePop(context),
                      icon: Icon(
                        Icons.chevron_left,
                        size: context.rs(28),
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  Text(
                    'เลือกสถานการณ์ของคุณ',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(15),
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),

            // ---- Content ----
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.rs(20),
                  vertical: context.rs(12),
                ),
                child: Column(
                  children: [
                    // ---- Card 1: มีอาการแต่ไม่รู้สาเหตุ (ม่วง) ----
                    _CaseCard(
                      badgeNumber: '1',
                      badgeColor: AppColors.purple,
                      cardBackground: const Color(0xFFF3F2FF),
                      title: 'มีอาการแต่\nไม่รู้ว่าเกิดจากอะไร',
                      titleColor: AppColors.purple,
                      subtitle: 'ฉันมีความกังวลปัญหาฟันแต่ไม่ทราบว่าต้องการ\nการรักษาใด',
                      bullets: const [
                        'ไม่ทราบสาเหตุที่แน่ชัดของอาการ',
                        'ต้องการวางแผนการรักษา\nโดยทันตแพทย์',
                        'ต้องการตรวจวินิจฉัยเพิ่มเติม',
                      ],
                      bulletColor: AppColors.purple,
                      buttonColor: AppColors.purple,
                      mascotWidget: _Case1Mascot(),
                      onTap: onSelectCase1,
                    ),

                    SizedBox(height: context.rs(16)),

                    // ---- Card 2: ทราบสาเหตุแล้ว (ส้ม) ----
                    _CaseCard(
                      badgeNumber: '2',
                      badgeColor: AppColors.orange,
                      cardBackground: const Color(0xFFFFF5EC),
                      title: 'ทราบสาเหตุ\nของปัญหาฟันแล้ว',
                      titleColor: AppColors.orange,
                      subtitle: 'ฉันเคยรับการตรวจหรือปรึกษามาแล้วและ\nต้องการนำผลมาดำเนินการต่อ',
                      bullets: const [
                        'มีผลตรวจ / X-ray จากที่อื่น',
                        'ต้องการให้ทันตแพทย์ประเมิน\nและวางแผนการรักษา',
                        'ต้องการความเห็นที่สอง',
                      ],
                      bulletColor: AppColors.orange,
                      buttonColor: AppColors.orange,
                      mascotWidget: _Case2Mascot(),
                      onTap: onSelectCase2,
                    ),

                    SizedBox(height: context.rs(24)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _CaseCard — card เลือกสถานการณ์
// ============================================================
class _CaseCard extends StatelessWidget {
  const _CaseCard({
    required this.badgeNumber,
    required this.badgeColor,
    required this.cardBackground,
    required this.title,
    required this.titleColor,
    required this.subtitle,
    required this.bullets,
    required this.bulletColor,
    required this.buttonColor,
    required this.mascotWidget,
    this.onTap,
  });

  final String badgeNumber;
  final Color badgeColor;
  final Color cardBackground;
  final String title;
  final Color titleColor;
  final String subtitle;
  final List<String> bullets;
  final Color bulletColor;
  final Color buttonColor;
  final Widget mascotWidget;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(context.rs(18)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Mascot มุมขวาบน
          Positioned(
            right: context.rs(0),
            top: context.rs(0),
            child: mascotWidget,
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(context.rs(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge "เคส N"
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.rs(12),
                    vertical: context.rs(4),
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(context.rs(20)),
                  ),
                  child: Text(
                    'เคส $badgeNumber',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(11),
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),

                SizedBox(height: context.rs(12)),

                // Title (ตัวหนาใหญ่)
                SizedBox(
                  width: context.rs(180),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(22),
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                      height: 1.25,
                    ),
                  ),
                ),

                SizedBox(height: context.rs(8)),

                // Subtitle
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(11),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGray,
                    height: 1.55,
                  ),
                ),

                SizedBox(height: context.rs(14)),

                // Bullets
                ...bullets.map(
                  (b) => Padding(
                    padding: EdgeInsets.only(bottom: context.rs(6)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: context.rs(15),
                          color: bulletColor,
                        ),
                        SizedBox(width: context.rs(6)),
                        Expanded(
                          child: Text(
                            b,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: context.rs(12),
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: context.rs(16)),

                // ปุ่ม "เลือกเคสนี้"
                SizedBox(
                  width: double.infinity,
                  height: context.rs(44),
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.rs(12)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'เลือกเคสนี้',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: context.rs(6)),
                        Icon(Icons.chevron_right, size: context.rs(18)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _Case1Mascot — ผู้หญิงมือจีบหน้า (card ม่วง)
// ============================================================
class _Case1Mascot extends StatelessWidget {
  const _Case1Mascot();

  @override
  Widget build(BuildContext context) {
    final double sz = context.rs(105);
    return SizedBox(
      width: sz,
      height: sz,
      child: CustomPaint(painter: _Case1Painter()),
    );
  }
}

class _Case1Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint fill = Paint()..style = PaintingStyle.fill;
    final double cx = size.width * 0.5;

    // Body (ม่วงอ่อน)
    fill.color = const Color(0xFFB0AEE0);
    final Path body = Path()
      ..moveTo(cx * 0.2, size.height)
      ..cubicTo(cx * 0.1, size.height * 0.65,
          cx * 0.3, size.height * 0.55, cx, size.height * 0.52)
      ..cubicTo(cx * 1.7, size.height * 0.55,
          cx * 1.9, size.height * 0.65, cx * 1.8, size.height)
      ..close();
    canvas.drawPath(body, fill);

    // Head (skin)
    fill.color = const Color(0xFFF5C6A0);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, size.height * 0.3),
        width: size.width * 0.44,
        height: size.height * 0.38,
      ),
      fill,
    );

    // Hair (น้ำตาลแดง)
    fill.color = const Color(0xFF8B4513);
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx, size.height * 0.27),
        width: size.width * 0.48,
        height: size.height * 0.3,
      ),
      3.14,
      3.14,
      true,
      fill,
    );
    // ผมยาวข้าง
    fill.color = const Color(0xFF8B4513);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx - size.width * 0.22, size.height * 0.35),
        width: size.width * 0.1,
        height: size.height * 0.2,
      ),
      fill,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx + size.width * 0.22, size.height * 0.35),
        width: size.width * 0.1,
        height: size.height * 0.2,
      ),
      fill,
    );

    // มือ/แขนข้างปาก (คิดหน้า)
    fill.color = const Color(0xFFF5C6A0);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx + size.width * 0.18, size.height * 0.55),
        width: size.width * 0.16,
        height: size.height * 0.12,
      ),
      fill,
    );
  }

  @override
  bool shouldRepaint(_Case1Painter old) => false;
}

// ============================================================
// _Case2Mascot — ผู้หญิงถือแฟ้ม (card ส้ม)
// ============================================================
class _Case2Mascot extends StatelessWidget {
  const _Case2Mascot();

  @override
  Widget build(BuildContext context) {
    final double sz = context.rs(105);
    return SizedBox(
      width: sz,
      height: sz,
      child: CustomPaint(painter: _Case2Painter()),
    );
  }
}

class _Case2Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint fill = Paint()..style = PaintingStyle.fill;
    final double cx = size.width * 0.5;

    // Body (ส้มอ่อน)
    fill.color = const Color(0xFFFFB870);
    final Path body = Path()
      ..moveTo(cx * 0.2, size.height)
      ..cubicTo(cx * 0.1, size.height * 0.65,
          cx * 0.3, size.height * 0.55, cx, size.height * 0.52)
      ..cubicTo(cx * 1.7, size.height * 0.55,
          cx * 1.9, size.height * 0.65, cx * 1.8, size.height)
      ..close();
    canvas.drawPath(body, fill);

    // Head (skin)
    fill.color = const Color(0xFFF5C6A0);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, size.height * 0.3),
        width: size.width * 0.44,
        height: size.height * 0.38,
      ),
      fill,
    );

    // Hair (ดำ)
    fill.color = const Color(0xFF2C2C2C);
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx, size.height * 0.26),
        width: size.width * 0.48,
        height: size.height * 0.3,
      ),
      3.14,
      3.14,
      true,
      fill,
    );

    // Folder/แฟ้ม (มุมขวาล่าง)
    fill.color = const Color(0xFFFF8D28);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx * 1.0, size.height * 0.56,
            size.width * 0.38, size.height * 0.28),
        Radius.circular(size.width * 0.04),
      ),
      fill,
    );
    // แถบบนแฟ้ม
    fill.color = const Color(0xFFFF6B00);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx * 1.0, size.height * 0.56,
            size.width * 0.2, size.height * 0.05),
        Radius.circular(size.width * 0.02),
      ),
      fill,
    );
    // เส้นในแฟ้ม
    fill.color = Colors.white.withValues(alpha: 0.7);
    for (int i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          cx * 1.06,
          size.height * (0.63 + i * 0.06),
          size.width * 0.26,
          size.height * 0.018,
        ),
        fill,
      );
    }
  }

  @override
  bool shouldRepaint(_Case2Painter old) => false;
}
