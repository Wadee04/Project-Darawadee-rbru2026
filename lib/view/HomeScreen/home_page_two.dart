import 'package:flutter/material.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

// ============================================================
// HomePageTwo - หน้าหลัก (สถานะ: เลือกคลินิกแล้ว มีนัดหมาย)
// ============================================================

/// ข้อมูลแถวคิวแต่ละห้อง
class ClinicQueueItem {
  const ClinicQueueItem({
    required this.roomName,
    required this.doctorName,
    this.currentNumber,   // null = ว่าง
    this.isServing = false,
  });

  final String roomName;
  final String doctorName;
  final int? currentNumber;
  final bool isServing;
}

class HomePageTwo extends StatefulWidget {
  const HomePageTwo({
    super.key,
    this.userName = 'คุณดาราวดี อลัย',
    this.clinicName = 'Dentbook Clinic',
    this.appointmentService = 'ขูดหินปูน',
    this.appointmentNumber = '001',
    this.appointmentDoctor = 'ทพ.อรุณี ใจดี',
    this.appointmentTime = '10.00 น.',
    this.queueItems = const [
      ClinicQueueItem(
        roomName: 'ห้อง 1',
        doctorName: 'ทพญ. อรุณี',
        currentNumber: 14,
        isServing: true,
      ),
      ClinicQueueItem(
        roomName: 'ห้อง 2',
        doctorName: 'ทพ. ธนากร',
        currentNumber: 9,
        isServing: true,
      ),
      ClinicQueueItem(
        roomName: 'ห้อง 3',
        doctorName: 'ทพญ. พิมพ์พลอย',
        currentNumber: null,
        isServing: false,
      ),
    ],
    this.onNotification,
    this.onProfile,
    this.onSelectClinic,
    this.onBooking,
    this.onMyQueue,
  });

  final String userName;
  final String clinicName;
  final String appointmentService;
  final String appointmentNumber;
  final String appointmentDoctor;
  final String appointmentTime;
  final List<ClinicQueueItem> queueItems;
  final VoidCallback? onNotification;
  final VoidCallback? onProfile;
  final VoidCallback? onSelectClinic;
  final VoidCallback? onBooking;
  final VoidCallback? onMyQueue;

  @override
  State<HomePageTwo> createState() => _HomePageTwoState();
}

class _HomePageTwoState extends State<HomePageTwo> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarBack(title: 'หน้าหลัก'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: context.rs(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.rs(16)),

                    // ---- Header row ----
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'สวัสดีตอนนาย',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: context.rs(13),
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textGray,
                                ),
                              ),
                              SizedBox(height: context.rs(2)),
                              Text(
                                widget.userName,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: context.rs(17),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.purple,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            _IconBtn(
                              icon: Icons.notifications_none_outlined,
                              onTap: widget.onNotification,
                            ),
                            SizedBox(width: context.rs(4)),
                            _IconBtn(
                              icon: Icons.account_circle_outlined,
                              onTap: widget.onProfile,
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: context.rs(12)),

                    // ---- Location bar (คลินิกที่เลือกแล้ว) ----
                    GestureDetector(
                      onTap: widget.onSelectClinic,
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: context.rs(15),
                            color: AppColors.purple,
                          ),
                          SizedBox(width: context.rs(4)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'คลินิกปัจจุบัน',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: context.rs(11),
                                  color: AppColors.textGray,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.clinicName,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: context.rs(13),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  SizedBox(width: context.rs(2)),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: context.rs(16),
                                    color: AppColors.textGray,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: context.rs(16)),

                    // ---- Appointment card (มีนัด) ----
                    _ActiveAppointmentCard(
                      service: widget.appointmentService,
                      number: widget.appointmentNumber,
                      doctor: widget.appointmentDoctor,
                      time: widget.appointmentTime,
                    ),

                    SizedBox(height: context.rs(20)),

                    // ---- คิวคลินิกวันนี้ ----
                    Text(
                      'คิวคลินิกวันนี้',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(15),
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: context.rs(10)),
                    Column(
                      children: widget.queueItems
                          .map((item) => Padding(
                                padding: EdgeInsets.only(
                                    bottom: context.rs(8)),
                                child: _QueueRow(item: item),
                              ))
                          .toList(),
                    ),

                    SizedBox(height: context.rs(12)),

                    // ---- จองด่วน ----
                    Text(
                      'จองด่วน',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(15),
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: context.rs(10)),
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
// _IconBtn
// ============================================================
class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.rs(36),
        height: context.rs(36),
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: context.rs(20), color: AppColors.purple),
      ),
    );
  }
}

// ============================================================
// _ActiveAppointmentCard — card นัดหมายที่มีข้อมูล
// ============================================================
class _ActiveAppointmentCard extends StatelessWidget {
  const _ActiveAppointmentCard({
    required this.service,
    required this.number,
    required this.doctor,
    required this.time,
  });

  final String service;
  final String number;
  final String doctor;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(20),
        vertical: context.rs(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label บน
          Text(
            'บัตรนัดถัดไปของคุณ',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(11),
              fontWeight: FontWeight.w400,
              color: AppColors.white.withValues(alpha: 0.75),
            ),
          ),
          SizedBox(height: context.rs(8)),

          // บริการ + หมายเลข
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  service,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(20),
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                    height: 1.2,
                  ),
                ),
              ),
              // หมายเลข badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.rs(12),
                  vertical: context.rs(4),
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(context.rs(8)),
                ),
                child: Text(
                  number,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(20),
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: context.rs(8)),

          // แพทย์ + เวลา
          Text(
            '$doctor - $time',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(12),
              fontWeight: FontWeight.w400,
              color: AppColors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _QueueRow — แถวคิวแต่ละห้อง
// ============================================================
class _QueueRow extends StatelessWidget {
  const _QueueRow({required this.item});
  final ClinicQueueItem item;

  @override
  Widget build(BuildContext context) {
    final bool isServing =
        item.isServing && item.currentNumber != null;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(14),
        vertical: context.rs(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.rs(12)),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: Row(
        children: [
          // สถานะ dot
          Container(
            width: context.rs(8),
            height: context.rs(8),
            decoration: BoxDecoration(
              color: isServing
                  ? AppColors.orange
                  : AppColors.inputBorder,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: context.rs(8)),

          // ชื่อห้อง
          SizedBox(
            width: context.rs(56),
            child: Text(
              item.roomName,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(13),
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),

          // ชื่อแพทย์
          Expanded(
            child: Text(
              item.doctorName,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(12),
                color: AppColors.textGray,
              ),
            ),
          ),

          // สถานะ / หมายเลข
          if (isServing) ...[
            Text(
              'กำลังให้บริการ',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(11),
                color: AppColors.textGray,
              ),
            ),
            SizedBox(width: context.rs(6)),
            Text(
              item.currentNumber!.toString().padLeft(3, '0'),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(14),
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
          ] else ...[
            Text(
              'ว่าง',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(12),
                color: AppColors.textGray,
              ),
            ),
            SizedBox(width: context.rs(6)),
            Text(
              '-',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(14),
                fontWeight: FontWeight.w700,
                color: AppColors.textGray,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================
// _ServiceCard — card จองด่วน
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
