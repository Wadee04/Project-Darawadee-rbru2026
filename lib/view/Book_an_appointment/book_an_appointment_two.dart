import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';
import 'book_an_appointment_three.dart';
import 'book_an_appointment_four.dart';

// ============================================================
// BookAnAppointmentTwo - หน้าเลือกสถานการณ์
// ============================================================
class BookAnAppointmentTwo extends StatelessWidget {
  const BookAnAppointmentTwo({
    super.key,
    this.onBack,
    this.onSelectCase1, // มีอาการแต่ไม่รู้สาเหตุ
    this.onSelectCase2, // ทราบสาเหตุแล้ว
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
            AppBarBack(
              title: 'เลือกสถานการณ์ของคุณ',
              onBack: onBack,
            ),

            // ---- Content ----
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.rs(24),
                  vertical: context.rs(24),
                ),
                child: Column(
                  children: [
                    // ---- Card 1: มีอาการแต่ไม่รู้สาเหตุ (ม่วง) ----
                    _CaseCard(
                      badgeNumber: '1',
                      badgeColor: AppColors.purple,
                      cardBackground: AppColors.blue50,
                      title: 'มีอาการแต่\nไม่รู้ว่าเกิดจากอะไร',
                      titleColor: AppColors.purple,
                      subtitle:
                          'ฉันไม่ทราบว่าปัญหาฟันเกิดจากอะไร\nต้องการเข้ารับการรักษา',
                      bullets: const [
                        'ไม่ทราบสาเหตุแต่รู้อาการ',
                        'ต้องการวางแผนการรักษา\nโดยทันตแพทย์',
                        'ต้องการตรวจวินิจฉัยเพิ่มเติม',
                      ],
                      bulletColor: AppColors.purple,
                      buttonColor: AppColors.purple,
                      mascotAsset:
                          'assets/images/Book_an_appointment/tooth2.svg',
                      mascotWidth: 300,
                      mascotHeight: 300,
                      mascotVerticalCenter: true,
                      mascotOffsetX: -90,
                      mascotOffsetY: -10,
                      onTap: () {
                        if (onSelectCase1 != null) {
                          onSelectCase1!();
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BookAnAppointmentThree(),
                            ),
                          );
                        }
                      },
                    ),

                    SizedBox(height: context.rs(16)),

                    // ---- Card 2: ทราบสาเหตุแล้ว (ส้ม) ----
                    _CaseCard(
                      badgeNumber: '2',
                      badgeColor: AppColors.orange,
                      cardBackground: AppColors.orangebgbook,
                      borderColor: AppColors.orangestroke2,
                      title: 'ทราบสาเหตุ\nของปัญหาฟันแล้ว',
                      titleColor: AppColors.orange,
                      subtitle:
                          'ฉันเคยรับการตรวจหรือปรึกษาที่อื่นมาแล้ว\nต้องการนำผลตรวจมารักษาต่อที่นี่',
                      bullets: const [
                        'มีผลตรวจ / X-ray จากที่อื่น',
                        'ต้องการให้ทันตแพทย์ประเมิน\nและวางแผนการรักษา',
                        'ต้องการความเห็นที่สอง',
                      ],
                      bulletColor: AppColors.orange,
                      buttonColor: AppColors.orange,
                      mascotAsset:
                          'assets/images/Book_an_appointment/tooth5.svg',
                      mascotWidth: 300,
                      mascotHeight: 300,
                      mascotVerticalCenter: true,
                      mascotOffsetX: -86,
                      mascotOffsetY: 2,
                      onTap: () {
                        if (onSelectCase2 != null) {
                          onSelectCase2!();
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BookAnAppointmentFour(),
                            ),
                          );
                        }
                      },
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
    required this.mascotAsset,
    required this.mascotWidth,
    required this.mascotHeight,
    this.onTap,
    this.borderColor,
    this.mascotVerticalCenter = false,
    this.mascotOffsetX = -20,
    this.mascotOffsetY = -20,
  });

  final String badgeNumber;
  final Color badgeColor;
  final Color cardBackground;
  final Color? borderColor;
  final bool mascotVerticalCenter;
  final double mascotOffsetX;
  final double mascotOffsetY;
  final String title;
  final Color titleColor;
  final String subtitle;
  final List<String> bullets;
  final Color bulletColor;
  final Color buttonColor;
  final String mascotAsset;
  final double mascotWidth;
  final double mascotHeight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.rs(18)),
        border: Border.all(
          color: borderColor ?? AppColors.purple,
          width: 1.5,
        ),
        boxShadow: [
          // Shadow 1: X=3, Y=0, Blur=2, Spread=0
          BoxShadow(
            color: (borderColor ?? AppColors.purple).withOpacity(0.25),
            offset: const Offset(3, 0),
            blurRadius: 2,
            spreadRadius: 0,
          ),
          // Shadow 2: X=0, Y=4, Blur=2, Spread=0
          BoxShadow(
            color: (borderColor ?? AppColors.purple).withOpacity(0.25),
            offset: const Offset(0, 4),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.rs(18)),
        child: ColoredBox(
          color: cardBackground,
          child: Stack(
        children: [
          // ---- Mascot ----
          if (mascotVerticalCenter)
            Positioned(
              right: context.rs(mascotOffsetX),
              bottom: context.rs(mascotOffsetY),
              child: SvgPicture.asset(
                mascotAsset,
                width: context.rs(mascotWidth),
                height: context.rs(mascotHeight),
                fit: BoxFit.contain,
              ),
            )
          else
            Positioned(
              right: 0,
              top: 0,
              child: SvgPicture.asset(
                mascotAsset,
                width: context.rs(mascotWidth),
                height: context.rs(mascotHeight),
                fit: BoxFit.contain,
              ),
            ),

          // ---- Content ----
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
                    'เคสที่ $badgeNumber',
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

                SizedBox(height: context.rs(5)),

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

                SizedBox(height: context.rs(17)),

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
                              fontSize: context.rs(14),
                              fontWeight: FontWeight.w500,
                              color: AppColors.textGray,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: context.rs(16)),

                // ปุ่ม "เลือกเคสนี้"
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.rs(12)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x40000000), // #000000 opacity 25%
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: SizedBox(
                  width: double.infinity,
                  height: context.rs(44),
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: AppColors.white,
                      disabledBackgroundColor: buttonColor,
                      disabledForegroundColor: AppColors.white,
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
                ),
              ],
            ),
          ),
        ],
      ),
        ),
      ),
    );
  }
}
