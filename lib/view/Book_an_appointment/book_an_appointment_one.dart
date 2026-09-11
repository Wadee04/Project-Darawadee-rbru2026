
import 'package:ant_icons_plus/ant_icons_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';
import '../HomeScreen/home_page_one.dart';
import 'book_an_appointment_two.dart';
import 'book_an_appointment_three.dart';
// ============================================================
// BookAnAppointment0 - หน้าเลือกประเภทการจองนัด
// ============================================================
class BookAnAppointmentOne extends StatefulWidget {
  const BookAnAppointmentOne({
    super.key,
    this.onSelectDescribe,   // เลือก "แจ้งรายละเอียด"
    this.onSelectConsult,    // เลือก "ปรึกษากับทันตแพทย์"
    this.onHome,
    this.onMyQueue,
    this.onProfile,
  });

  final VoidCallback? onSelectDescribe;
  final VoidCallback? onSelectConsult;
  final VoidCallback? onHome;
  final VoidCallback? onMyQueue;
  final VoidCallback? onProfile;

  @override
  State<BookAnAppointmentOne> createState() => _BookAnAppointmentOneState();
}

class _BookAnAppointmentOneState extends State<BookAnAppointmentOne> {
  int _navIndex = 1; // จองคิว active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ---- AppBar ----
            const AppBarBack(title: 'คุณต้องการบริการแบบไหน', showBack: false),

            // ---- Content ----
            Expanded(
              child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.rs(16)),

                    // ---- หัวข้อหลัก ----
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(20),
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        children: [
                          TextSpan(
                            text: 'เรา',
                            style: TextStyle(color: AppColors.black),
                          ),
                          TextSpan(
                            text: 'ใส่ใจ',
                            style: TextStyle(color: AppColors.orange),
                          ),
                          TextSpan(
                            text: 'ทุกปัญหาช่องปากของคุณ',
                            style: TextStyle(color: AppColors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.rs(6)),
                    Text(
                      'เลือกวิธีที่เหมาะสมกับคุณ เพื่อให้เรา\nดูแลคุณได้อย่างตรงจุด',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(14),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textGray,
                        height: 1.3,
                      ),
                    ),

                    SizedBox(height: context.rs(20)),

                    // ---- Card 1: แจ้งรายละเอียด (ม่วง) ----
                    _ServiceCard(
                      badge: 'แนะนำสำหรับผู้ที่ทราบปัญหา',
                      title: 'แจ้งรายละเอียด\nเพื่อเลือกบริการ',
                      description:
                          'บอกอาการหรือความต้องการของคุณ\nเพื่อให้เราแนะนำบริการที่เหมาะสม',
                      gradientColors: const [
                        AppColors.blue50,
                        AppColors.white,
                      ],
                      gradientBegin: Alignment.topCenter,
                      gradientEnd: Alignment.bottomCenter,
                      badgeColor: AppColors.purple,
                      accentColor: AppColors.purple,
                      borderColor: AppColors.purple,
                      features: const [
                        _Feature(svgAsset: 'assets/images/Book_an_appointment/tlktodentist.svg', label: 'พูดคุย\nกับทันตแพทย์'),
                        _Feature(svgAsset: 'assets/images/Book_an_appointment/recommend.svg', label: 'แนะนำบริการ\nที่เหมาะสม'),
                        _Feature(svgAsset: 'assets/images/Book_an_appointment/make-an-appointment.svg', label: 'นัดหมาย\nได้ทันที'),
                      ],
                      mascotWidget: Transform.translate(
                        offset: const Offset(0, -35),
                        child: SvgPicture.asset(
                          'assets/images/Book_an_appointment/tooth6.svg',
                          height: 110,
                          fit: BoxFit.contain,
                        ),
                      ),
                      mascotOnLeft: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookAnAppointmentTwo(
                              onBack: () => Navigator.pop(context),
                              onSelectCase1: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BookAnAppointmentThree(
                                      onBack: () => Navigator.pop(context),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: context.rs(16)),

                    // ---- Card 2: ปรึกษาทันตแพทย์ (ส้ม) ----
                    _ServiceCard(
                      badge: 'แนะนำสำหรับผู้ไม่แน่ใจ',
                      title: 'ปรึกษากับทันตแพทย์',
                      description:
                          'พูดคุยกับทันตแพทย์ของเราที่คลินิก\nเพื่อประเมินปัญหาและการวางแผน\nที่เหมาะสมกับคุณ',
                      gradientColors: const [
                        AppColors.orange,
                        AppColors.white,
                      ],
                      gradientBegin: Alignment.topCenter,
                      gradientEnd: Alignment.bottomCenter,
                      gradientOpacity: 0.20,
                      badgeColor: AppColors.orange,
                      accentColor: AppColors.orange,
                      borderColor: AppColors.orange,
                      features: const [
                        _Feature(svgAsset: 'assets/images/Book_an_appointment/tlktodentist.svg', label: 'พูดคุย\nกับทันตแพทย์'),
                        _Feature(svgAsset: 'assets/images/Book_an_appointment/recommend.svg', label: 'แนะนำบริการ\nที่เหมาะสม'),
                        _Feature(svgAsset: 'assets/images/Book_an_appointment/make-an-appointment.svg', label: 'นัดหมาย\nได้ทันที'),
                      ],
                      mascotWidget: Transform.translate(
                        offset: const Offset(0, -25),
                        child: SvgPicture.asset(
                          'assets/images/Book_an_appointment/tooth7.svg',
                          height: 130,
                          fit: BoxFit.contain,
                        ),
                      ),
                      mascotOnLeft: true,
                      onTap: widget.onSelectConsult,
                    ),

                    SizedBox(height: context.rs(16)),
                  ],
                ),
              ),
            ),

            // ---- Disclaimer ----
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rs(50)),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.rs(5),
                  vertical: context.rs(8),
                ),
                decoration: BoxDecoration(
                  color: AppColors.graysecurity,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      AntIcons.safetyOutlined,
                      size: context.rs(14),
                      color: AppColors.textGray,
                    ),
                    SizedBox(width: context.rs(4)),
                    Text(
                      'ข้อมูลของคุณจะถูกเก็บเป็นความลับและปลอดภัยเสมอ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(10),
                        color: AppColors.textGray,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: context.rs(13)),

            // ---- Bottom Navigation ----
            AppBottomNav(
              currentIndex: _navIndex,
              onTap: (i) {
                setState(() => _navIndex = i);
                if (i == 0) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePageOne()),
                    (route) => false,
                  );
                }
                if (i == 2) widget.onMyQueue?.call();
                if (i == 3) widget.onProfile?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _Feature data class
// ============================================================
class _Feature {
  const _Feature({this.icon, this.svgAsset, required this.label})
      : assert(icon != null || svgAsset != null,
            '_Feature ต้องมี icon หรือ svgAsset อย่างใดอย่างหนึ่ง');
  final IconData? icon;
  final String? svgAsset; // path ของ SVG asset เช่น 'assets/images/...'
  final String label;
}

// ============================================================
// _ServiceCard — card เลือกบริการ (gradient)
// ============================================================
class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.badge,
    required this.title,
    required this.description,
    required this.gradientColors,
    required this.badgeColor,
    required this.accentColor,
    required this.borderColor,
    required this.features,
    required this.mascotWidget,
    this.mascotOnLeft = false,
    this.gradientBegin = Alignment.centerLeft,
    this.gradientEnd = Alignment.centerRight,
    this.gradientOpacity = 1.0,
    this.onTap,
  });

  final String badge;
  final String title;
  final String description;
  final List<Color> gradientColors;
  final Color badgeColor;
  final Color accentColor;
  final Color borderColor;
  final List<_Feature> features;
  final Widget mascotWidget;
  final bool mascotOnLeft;
  final AlignmentGeometry gradientBegin;
  final AlignmentGeometry gradientEnd;
  final double gradientOpacity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(context.rs(16)),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.rs(16) - 1.5),
          child: Stack(
            children: [
              // ---- Gradient background layer (opacity controlled) ----
              Positioned.fill(
                child: Opacity(
                  opacity: gradientOpacity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: gradientBegin,
                        end: gradientEnd,
                      ),
                    ),
                  ),
                ),
              ),
              // ---- Content layer ----
              Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Top section: Mascot + Content side by side ----
            Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                // Mascot (ซ้ายหรือขวาตาม mascotOnLeft)
                Positioned(
                  left: mascotOnLeft ? context.rs(20) : null,
                  right: mascotOnLeft ? null : context.rs(20),
                  bottom: 0,
                  child: mascotWidget,
                ),

                // Content — เพิ่ม padding ด้านที่มี mascot เพื่อหลบ
                Padding(
                  padding: EdgeInsets.only(
                    top: context.rs(18),
                    bottom: context.rs(18),
                    left: mascotOnLeft ? context.rs(125) : context.rs(18),
                    right: mascotOnLeft ? context.rs(18) : context.rs(90),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.rs(18),
                          vertical: context.rs(9),
                        ),
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(context.rs(10)),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(10),
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),

                      SizedBox(height: context.rs(10)),

                      // Title + Arrow row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: context.rs(17),
                                fontWeight: FontWeight.w700,
                                color: accentColor,
                                height: 1.3,
                              ),
                            ),
                          ),
                          Container(
                            width: context.rs(28),
                            height: context.rs(28),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x40000000), // #000000 opacity 25%
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.chevron_right,
                              size: context.rs(18),
                              color: accentColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: context.rs(4)),

                      // Description
                      SizedBox(
                        width: context.rs(190),
                        child: Text(
                          description,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(11),
                            fontWeight: FontWeight.w400,
                            color: AppColors.textGray.withValues(alpha: 0.85),
                            height: 1.55,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ---- Bottom section: Feature icons row ----
            Padding(
              padding: EdgeInsets.only(
                top: context.rs(0),
                left: context.rs(18),
                right: context.rs(18),
                bottom: context.rs(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: () {
                  final List<Widget> items = [];
                  for (int i = 0; i < features.length; i++) {
                    final f = features[i];
                    items.add(Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (f.svgAsset != null)
                          SvgPicture.asset(
                            f.svgAsset!,
                            width: context.rs(14),
                            height: context.rs(14),
                            colorFilter: ColorFilter.mode(
                              accentColor,
                              BlendMode.srcIn,
                            ),
                          )
                        else
                          Icon(
                            f.icon,
                            size: context.rs(14),
                            color: accentColor,
                          ),
                        SizedBox(width: context.rs(9)),
                        Text(
                          f.label,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(10),
                            color: accentColor,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ));
                    // เส้นคั่นแบบ rounded ระหว่าง feature (ไม่ใส่หลังตัวสุดท้าย)
                    if (i < features.length - 1) {
                      items.add(Padding(
                        padding: EdgeInsets.symmetric(horizontal: context.rs(15)),
                        child: Container(
                          width: context.rs(1),
                          height: context.rs(16),
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(context.rs(99)),
                          ),
                        ),
                      ));
                    }
                  }
                  return items;
                }(),
              ),
            ),
          ],
        ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _NurseMascot — ตัวการ์ตูนนางพยาบาล (card ม่วง)
// ============================================================
class _NurseMascot extends StatelessWidget {
  const _NurseMascot();

  @override
  Widget build(BuildContext context) {
    final double sz = context.rs(110);
    return SizedBox(
      width: sz,
      height: sz,
      child: CustomPaint(painter: _NursePainter()),
    );
  }
}

class _NursePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width * 0.5;
    final Paint fill = Paint()..style = PaintingStyle.fill;

    // Body (ชุดพยาบาลขาว)
    fill.color = Colors.white.withValues(alpha: 0.9);
    final Path body = Path()
      ..moveTo(cx * 0.3, size.height)
      ..cubicTo(cx * 0.1, size.height * 0.65, cx * 0.3, size.height * 0.55, cx, size.height * 0.52)
      ..cubicTo(cx * 1.7, size.height * 0.55, cx * 1.9, size.height * 0.65, cx * 1.7, size.height)
      ..close();
    canvas.drawPath(body, fill);

    // Head
    fill.color = const Color(0xFFFFC8A0);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, size.height * 0.32),
        width: size.width * 0.42,
        height: size.height * 0.38,
      ),
      fill,
    );

    // Hat (หมวกพยาบาล)
    fill.color = Colors.white;
    final Path hat = Path()
      ..moveTo(cx - size.width * 0.22, size.height * 0.2)
      ..lineTo(cx + size.width * 0.22, size.height * 0.2)
      ..lineTo(cx + size.width * 0.18, size.height * 0.1)
      ..lineTo(cx - size.width * 0.18, size.height * 0.1)
      ..close();
    canvas.drawPath(hat, fill);

    // Cross บนหมวก
    fill.color = const Color(0xFFFF6B6B);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(cx, size.height * 0.15),
        width: size.width * 0.06,
        height: size.height * 0.09,
      ),
      fill,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(cx, size.height * 0.15),
        width: size.width * 0.12,
        height: size.height * 0.03,
      ),
      fill,
    );

    // Clipboard
    fill.color = const Color(0xFFEEEEFF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx * 1.1, size.height * 0.55, size.width * 0.32, size.height * 0.3),
        Radius.circular(size.width * 0.04),
      ),
      fill,
    );
    fill.color = Colors.white.withValues(alpha: 0.6);
    for (int i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          cx * 1.15,
          size.height * (0.6 + i * 0.07),
          size.width * 0.22,
          size.height * 0.02,
        ),
        fill,
      );
    }
  }

  @override
  bool shouldRepaint(_NursePainter old) => false;
}

// ============================================================
// _DoctorMascot — ตัวการ์ตูนหมอ (card ส้ม)
// ============================================================
class _DoctorMascot extends StatelessWidget {
  const _DoctorMascot();

  @override
  Widget build(BuildContext context) {
    final double sz = context.rs(110);
    return SizedBox(
      width: sz,
      height: sz,
      child: CustomPaint(painter: _DoctorPainter()),
    );
  }
}

class _DoctorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width * 0.5;
    final Paint fill = Paint()..style = PaintingStyle.fill;

    // Body (เสื้อกาวน์ขาว)
    fill.color = Colors.white.withValues(alpha: 0.9);
    final Path body = Path()
      ..moveTo(cx * 0.25, size.height)
      ..cubicTo(cx * 0.1, size.height * 0.65, cx * 0.3, size.height * 0.55, cx, size.height * 0.52)
      ..cubicTo(cx * 1.7, size.height * 0.55, cx * 1.9, size.height * 0.65, cx * 1.75, size.height)
      ..close();
    canvas.drawPath(body, fill);

    // Head
    fill.color = const Color(0xFFFFC8A0);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, size.height * 0.3),
        width: size.width * 0.42,
        height: size.height * 0.38,
      ),
      fill,
    );

    // Hair
    fill.color = const Color(0xFF5C3A1E);
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx, size.height * 0.25),
        width: size.width * 0.46,
        height: size.height * 0.28,
      ),
      3.14,
      3.14,
      true,
      fill,
    );

    // Stethoscope (หูฟัง)
    final Paint stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05
      ..strokeCap = StrokeCap.round;

    final Path stetho = Path()
      ..moveTo(cx * 0.7, size.height * 0.58)
      ..cubicTo(
        cx * 0.5, size.height * 0.72,
        cx * 0.5, size.height * 0.82,
        cx, size.height * 0.84,
      )
      ..cubicTo(
        cx * 1.5, size.height * 0.82,
        cx * 1.5, size.height * 0.72,
        cx * 1.3, size.height * 0.58,
      );
    canvas.drawPath(stetho, stroke);

    fill.color = Colors.white.withValues(alpha: 0.8);
    canvas.drawCircle(Offset(cx, size.height * 0.85), size.width * 0.06, fill);
  }

  @override
  bool shouldRepaint(_DoctorPainter old) => false;
}
