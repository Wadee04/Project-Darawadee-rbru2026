import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

// ============================================================
// HomePage - หน้าหลัก(ไม่มีการนัดหมาย)
// ============================================================
class HomePageOne extends StatefulWidget {
  const HomePageOne({
    super.key,
    this.userName = 'คุณดาราวดี อาลัย',
    this.onNotification,
    this.onProfile,
    this.onSelectClinic,
    this.onBooking,
    this.onMyQueue,
  });

  final String userName;
  final VoidCallback? onNotification;
  final VoidCallback? onProfile;
  final VoidCallback? onSelectClinic;
  final VoidCallback? onBooking;
  final VoidCallback? onMyQueue;

  @override
  State<HomePageOne> createState() => _HomePageOneState();
}

class _HomePageOneState extends State<HomePageOne> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  context.rs(20),
                  MediaQuery.of(context).size.height * 0.05,
                  context.rs(20),
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---- Header row ----
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Greeting
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'สวัสดีตอนบ่าย',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: context.rs(14),
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textGray,
                                ),
                              ),
                              SizedBox(height: context.rs(2)),
                              Text(
                                widget.userName,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: context.rs(16),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.purple,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Icons
                        Row(
                          children: [
                            _IconBtn(
                              svgAsset: 'assets/images/homescreen/bell.svg',
                              onTap: widget.onNotification,
                              width: 15,
                              height: 17,
                            ),
                            SizedBox(width: context.rs(25)),
                            _IconBtn(
                              svgAsset: 'assets/images/homescreen/contact.svg',
                              onTap: widget.onProfile,
                              width: 20,
                              height: 18.16,
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: context.rs(12)),

                    // ---- Location bar ----
                    GestureDetector(
                      onTap: widget.onSelectClinic,
                      child: Container(
                      
                        padding: EdgeInsets.symmetric(
                          horizontal: context.rs(12),
                          vertical: context.rs(8),
                        ),
                         decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius:
                              BorderRadius.circular(context.rs(10)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: context.rs(16),
                              color: AppColors.purple,
                            ),
                            SizedBox(width: context.rs(6)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ยังไม่ได้เลือกคลินิก',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: context.rs(12),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  Text(
                                    'กรุณาเลือกคลินิก เพื่อเริ่มใช้งาน',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: context.rs(11),
                                      color: AppColors.textGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: context.rs(32),
                              height: context.rs(32),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.inputBorder,
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: context.rs(18),
                                color: AppColors.textGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: context.rs(16)),

                    // ---- Appointment card ----
                    _AppointmentCard(),

                    SizedBox(height: context.rs(20)),

                    // ---- บริการแนะนำ ----
                    Text(
                      'บริการแนะนำ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(15),
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: context.rs(12)),
                    Row(
                      children: [
                        Expanded(
                          child: _ServiceCard(
                            icon: Icons.health_and_safety_outlined,
                            label: 'ตรวจสุขภาพฟัน',
                            onTap: widget.onBooking,
                          ),
                        ),
                        SizedBox(width: context.rs(10)),
                        Expanded(
                          child: _ServiceCard(
                            icon: Icons.cleaning_services_outlined,
                            label: 'ขูดหินปูน',
                            onTap: widget.onBooking,
                          ),
                        ),
                        SizedBox(width: context.rs(10)),
                        Expanded(
                          child: _ServiceCard(
                            icon: Icons.build_outlined,
                            label: 'อุดฟัน',
                            onTap: widget.onBooking,
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
                setState(() => _navIndex = i);
                if (i == 1) widget.onBooking?.call();
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
// _IconBtn — ปุ่ม icon วงกลมใน header
// ============================================================
class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.svgAsset,
    this.onTap,
    this.width = 20,
    this.height = 20,
  });
  final String svgAsset;
  final VoidCallback? onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        svgAsset,
        width: context.rs(width),
        height: context.rs(height),
        colorFilter: const ColorFilter.mode(
          Color(0xB3000000),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

// ============================================================
// _AppointmentCard — card นัดหมาย (gradient ม่วง)
// ============================================================
class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(20),
        vertical: context.rs(28),
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.cardAppointment1,
            AppColors.cardAppointment2,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon ปฏิทิน
          Container(
            width: context.rs(48),
            height: context.rs(48),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              size: context.rs(24),
              color: AppColors.white,
            ),
          ),
          SizedBox(height: context.rs(12)),
          Text(
            'ยังไม่มีการนัดหมาย',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(15),
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: context.rs(4)),
          Text(
            'เมื่อคุณเลือกคลินิกแล้ว\nการนัดหมายของคุณจะแสดงที่นี่',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(12),
              fontWeight: FontWeight.w400,
              color: AppColors.white.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _ServiceCard — card บริการแนะนำ
// ============================================================
class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: context.rs(16),
          horizontal: context.rs(8),
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(context.rs(14)),
          border: Border.all(color: AppColors.inputBorder, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: context.rs(28), color: AppColors.purple),
            SizedBox(height: context.rs(8)),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(12),
                fontWeight: FontWeight.w500,
                color: AppColors.black,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _BottomNav — Bottom Navigation Bar
// ============================================================
class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final List<_NavItem> items = const [
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
                        : AppColors.navBarUnselected,
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
                          : AppColors.navBarUnselected,
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
