import 'package:flutter/material.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

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
  final int _navIndex = 1; // จองคิว active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        child: Column(
          children: [
            // ---- AppBar ----
            const AppBarBack(title: 'คุณต้องการบริการแบบไหน'),

            // ---- Content ----
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: context.rs(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.rs(16)),

                    // ---- หัวข้อหลัก ----
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(22),
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                        children: [
                          TextSpan(
                            text: 'เราใส่ใจ',
                            style: TextStyle(color: AppColors.purple),
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
                        fontSize: context.rs(12),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textGray,
                        height: 1.6,
                      ),
                    ),

                    SizedBox(height: context.rs(20)),

                    // ---- Card 1: แจ้งรายละเอียด (ม่วง) ----
                    _ServiceCard(
                      badge: 'แนะนำสำหรับผู้เริ่มต้นใช้งาน',
                      title: 'แจ้งรายละเอียด\nเพื่อเลือกบริการ',
                      description:
                          'บอกเราว่าคุณต้องการอะไร\nเพื่อให้เราจัดบริการที่เหมาะสม\nกับความต้องการของคุณ',
                      gradientColors: const [
                        Color(0xFF4E4C85),
                        Color(0xFF6B68C0),
                      ],
                      badgeColor: AppColors.purple,
                      features: const [
                        _Feature(icon: Icons.location_on_outlined, label: 'ทุกที่'),
                        _Feature(icon: Icons.access_time_outlined, label: 'ทุกเวลา'),
                        _Feature(icon: Icons.bolt_outlined, label: 'ประหยัดเวลา'),
                      ],
                      mascotWidget: _NurseMascot(),
                      onTap: widget.onSelectDescribe,
                    ),

                    SizedBox(height: context.rs(16)),

                    // ---- Card 2: ปรึกษาทันตแพทย์ (ส้ม) ----
                    _ServiceCard(
                      badge: 'แนะนำสำหรับผู้ไม่แน่ใจ',
                      title: 'ปรึกษากับทันตแพทย์',
                      description:
                          'พูดคุยกับทันตแพทย์ของเราโดยตรง\nเพื่อรับคำปรึกษาที่ถูกต้องที่สุด\nและตรงตามความต้องการของคุณ',
                      gradientColors: const [
                        Color(0xFFFF8D28),
                        Color(0xFFFFB347),
                      ],
                      badgeColor: AppColors.orange,
                      features: const [
                        _Feature(icon: Icons.chat_bubble_outline, label: 'ปรึกษาฟรี'),
                        _Feature(icon: Icons.verified_user_outlined, label: 'ทันตแพทย์\nที่แนะนำ'),
                        _Feature(icon: Icons.schedule_outlined, label: 'นัดหมาย\nได้เลย'),
                      ],
                      mascotWidget: _DoctorMascot(),
                      onTap: widget.onSelectConsult,
                    ),

                    SizedBox(height: context.rs(16)),

                    // ---- Disclaimer ----
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: context.rs(12),
                          color: AppColors.textGray,
                        ),
                        SizedBox(width: context.rs(4)),
                        Expanded(
                          child: Text(
                            'ข้อมูลของคุณจะถูกเก็บเป็นความลับและปลอดภัยเสมอ',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: context.rs(10),
                              color: AppColors.textGray,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: context.rs(24)),
                  ],
                ),
              ),
            ),

            // ---- Bottom Navigation ----
            _BottomNav(
              currentIndex: _navIndex,
              onTap: (i) {
                if (i == 0) widget.onHome?.call();
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
  const _Feature({required this.icon, required this.label});
  final IconData icon;
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
    required this.features,
    required this.mascotWidget,
    this.onTap,
  });

  final String badge;
  final String title;
  final String description;
  final List<Color> gradientColors;
  final Color badgeColor;
  final List<_Feature> features;
  final Widget mascotWidget;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(context.rs(18)),
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // Mascot (มุมขวา)
            Positioned(
              right: context.rs(-4),
              bottom: context.rs(32),
              child: mascotWidget,
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(context.rs(18)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.rs(10),
                      vertical: context.rs(4),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(context.rs(20)),
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
                            color: AppColors.white,
                            height: 1.3,
                          ),
                        ),
                      ),
                      Container(
                        width: context.rs(28),
                        height: context.rs(28),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          size: context.rs(18),
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: context.rs(8)),

                  // Description
                  SizedBox(
                    width: context.rs(190),
                    child: Text(
                      description,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(11),
                        fontWeight: FontWeight.w400,
                        color: AppColors.white.withValues(alpha: 0.85),
                        height: 1.55,
                      ),
                    ),
                  ),

                  SizedBox(height: context.rs(14)),

                  // Feature icons row
                  Row(
                    children: features.map((f) {
                      return Padding(
                        padding: EdgeInsets.only(right: context.rs(18)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              f.icon,
                              size: context.rs(14),
                              color: AppColors.white,
                            ),
                            SizedBox(width: context.rs(4)),
                            Text(
                              f.label,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: context.rs(10),
                                color: AppColors.white,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
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

// ============================================================
// _BottomNav
// ============================================================
class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    const List<_NavItem> items = [
      _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'หน้าหลัก'),
      _NavItem(icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month, label: 'จองคิว'),
      _NavItem(icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long, label: 'คิวของฉัน'),
      _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'โปรไฟล์'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: context.rs(8),
        bottom: context.rs(8),
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final bool active = i == currentIndex;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    active ? items[i].activeIcon : items[i].icon,
                    size: context.rs(22),
                    color: active
                        ? AppColors.navBarSelected
                        : AppColors.black50,
                  ),
                  SizedBox(height: context.rs(3)),
                  Text(
                    items[i].label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(10),
                      fontWeight:
                          active ? FontWeight.w600 : FontWeight.w400,
                      color: active
                          ? AppColors.navBarSelected
                          : AppColors.black50,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
