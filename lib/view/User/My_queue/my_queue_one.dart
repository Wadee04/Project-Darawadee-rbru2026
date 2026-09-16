import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/shared_widgets.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';
import '../HomeScreen/home_page_one.dart';
import '../Book_an_appointment/book_an_appointment_one.dart';
import 'my_queue_two.dart';

// ============================================================
// MyQueueOne - หน้าคิวของฉัน
// ============================================================

/// สถานะของคิว
enum QueueStatus {
  waitingPayment, // รอชำระมัดจำ
  confirmed, // ยืนยันแล้ว / รอเข้ารับบริการ
  inProgress, // กำลังดำเนินการ
  completed, // เสร็จสิ้น
  cancelled, // ยกเลิกแล้ว
}

extension QueueStatusExt on QueueStatus {
  String get label {
    switch (this) {
      case QueueStatus.waitingPayment:
        return 'รอชำระมัดจำ';
      case QueueStatus.confirmed:
        return 'ยืนยันแล้ว';
      case QueueStatus.inProgress:
        return 'กำลังดำเนินการ';
      case QueueStatus.completed:
        return 'เสร็จสิ้น';
      case QueueStatus.cancelled:
        return 'ยกเลิกแล้ว';
    }
  }

  Color get badgeColor {
    switch (this) {
      case QueueStatus.waitingPayment:
        return AppColors.orange;
      case QueueStatus.confirmed:
        return AppColors.greendentbook;
      case QueueStatus.inProgress:
        return AppColors.purple;
      case QueueStatus.completed:
        return AppColors.textGray;
      case QueueStatus.cancelled:
        return AppColors.reddentbook;
    }
  }
}

/// ข้อมูลคิวแต่ละรายการ
class QueueItem {
  const QueueItem({
    required this.bookingId,
    required this.clinicName,
    required this.serviceName,
    required this.doctorName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    this.depositAmount,
  });

  final String bookingId;
  final String clinicName;
  final String serviceName;
  final String doctorName;
  final String appointmentDate;
  final String appointmentTime;
  final QueueStatus status;
  final int? depositAmount;
}

// ============================================================
// MyQueueOne Widget
// ============================================================
class MyQueueOne extends StatefulWidget {
  const MyQueueOne({
    super.key,
    this.onHome,
    this.onBooking,
    this.onProfile,
  });

  final VoidCallback? onHome;
  final VoidCallback? onBooking;
  final VoidCallback? onProfile;

  @override
  State<MyQueueOne> createState() => _MyQueueOneState();
}

class _MyQueueOneState extends State<MyQueueOne>
    with SingleTickerProviderStateMixin {
  int _navIndex = 2; // คิวของฉัน active
  late TabController _tabController;

  // ข้อมูลตัวอย่าง
  static const List<QueueItem> _allQueues = [
    QueueItem(
      bookingId: 'SC680516-001',
      clinicName: 'DentBook Clinic สาขาจันทบุรี',
      serviceName: 'ตรวจสุขภาพฟัน + X-ray / อุดฟัน',
      doctorName: 'ทพญ. อรุณี ป.',
      appointmentDate: 'พุธ 12 สิงหาคม 2569',
      appointmentTime: '09:00 น.',
      status: QueueStatus.waitingPayment,
      depositAmount: 200,
    ),
    QueueItem(
      bookingId: 'SC680516-002',
      clinicName: 'DentBook Clinic สาขาจันทบุรี',
      serviceName: 'ขูดหินปูน',
      doctorName: 'ทพ. วิชัย ส.',
      appointmentDate: 'ศุกร์ 14 สิงหาคม 2569',
      appointmentTime: '13:00 น.',
      status: QueueStatus.confirmed,
    ),
    QueueItem(
      bookingId: 'SC680412-003',
      clinicName: 'DentBook Clinic สาขาจันทบุรี',
      serviceName: 'จัดฟัน',
      doctorName: 'ทพญ. อรุณี ป.',
      appointmentDate: 'จันทร์ 10 เมษายน 2568',
      appointmentTime: '10:00 น.',
      status: QueueStatus.completed,
    ),
    QueueItem(
      bookingId: 'SC680301-004',
      clinicName: 'DentBook Clinic สาขาจันทบุรี',
      serviceName: 'ถอนฟัน',
      doctorName: 'ทพ. วิชัย ส.',
      appointmentDate: 'อังคาร 1 มีนาคม 2568',
      appointmentTime: '14:00 น.',
      status: QueueStatus.cancelled,
    ),
  ];

  List<QueueItem> get _activeQueues => _allQueues
      .where((q) =>
          q.status == QueueStatus.waitingPayment ||
          q.status == QueueStatus.confirmed ||
          q.status == QueueStatus.inProgress)
      .toList();

  List<QueueItem> get _historyQueues => _allQueues
      .where((q) =>
          q.status == QueueStatus.completed ||
          q.status == QueueStatus.cancelled)
      .toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        child: Column(
          children: [
            // ---- Header ----
            _MyQueueHeader(),

            // ---- TabBar ----
            Container(
              color: AppColors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.purple,
                  unselectedLabelColor: AppColors.textGray,
                  indicatorColor: AppColors.purple,
                  indicatorWeight: 2.5,
                  labelStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(13),
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(13),
                    fontWeight: FontWeight.w400,
                  ),
                  tabs: const [
                    Tab(text: 'คิวที่รอดำเนินการ'),
                    Tab(text: 'ประวัติการจอง'),
                  ],
                ),
              ),
            ),

            // ---- Tab Content ----
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: คิวที่รอดำเนินการ
                  _QueueList(
                    items: _activeQueues,
                    emptyMessage: 'ยังไม่มีคิวที่รอดำเนินการ',
                    emptySubMessage: 'จองคิวเพื่อเริ่มใช้บริการ',
                    showBookButton: true,
                    onBookTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BookAnAppointmentOne(),
                        ),
                      );
                    },
                    onCardTap: (item) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MyQueueTwo(queue: item),
                        ),
                      );
                    },
                  ),
                  // Tab 2: ประวัติการจอง
                  _QueueList(
                    items: _historyQueues,
                    emptyMessage: 'ยังไม่มีประวัติการจอง',
                    emptySubMessage: '',
                    showBookButton: false,
                    onCardTap: (item) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MyQueueTwo(queue: item),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

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
                if (i == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BookAnAppointmentOne(),
                    ),
                  );
                }
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
// _MyQueueHeader — หัวหน้าพร้อมชื่อหน้า
// ============================================================
class _MyQueueHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.fromLTRB(
        context.rs(24),
        MediaQuery.of(context).size.height * 0.015,
        context.rs(24),
        context.rs(14),
      ),
      child: Row(
        children: [
          // Icon คิว
          Container(
            width: context.rs(36),
            height: context.rs(36),
            decoration: BoxDecoration(
              color: AppColors.homeBackground,
              borderRadius: BorderRadius.circular(context.rs(10)),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/homescreen/queue_of.svg',
                width: context.rs(20),
                height: context.rs(20),
                colorFilter: const ColorFilter.mode(
                  AppColors.purple,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(width: context.rs(10)),
          Text(
            'คิวของฉัน',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(17),
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _QueueList — รายการคิว (หรือแสดง empty state)
// ============================================================
class _QueueList extends StatelessWidget {
  const _QueueList({
    required this.items,
    required this.emptyMessage,
    required this.emptySubMessage,
    required this.showBookButton,
    required this.onCardTap,
    this.onBookTap,
  });

  final List<QueueItem> items;
  final String emptyMessage;
  final String emptySubMessage;
  final bool showBookButton;
  final void Function(QueueItem) onCardTap;
  final VoidCallback? onBookTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyQueueState(
        message: emptyMessage,
        subMessage: emptySubMessage,
        showBookButton: showBookButton,
        onBookTap: onBookTap,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        context.rs(16),
        context.rs(16),
        context.rs(16),
        context.rs(16),
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _QueueCard(
        item: items[i],
        onTap: () => onCardTap(items[i]),
      ),
    );
  }
}

// ============================================================
// _QueueCard — การ์ดแสดงรายการคิวแต่ละอัน
// ============================================================
class _QueueCard extends StatelessWidget {
  const _QueueCard({required this.item, required this.onTap});

  final QueueItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: context.rs(12)),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(context.rs(16)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x144E4C85),
              offset: Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Header strip (ชื่อคลินิก + badge สถานะ) ----
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.rs(16),
                vertical: context.rs(10),
              ),
              decoration: BoxDecoration(
                color: AppColors.homeBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.rs(16)),
                  topRight: Radius.circular(context.rs(16)),
                ),
              ),
              child: Row(
                children: [
                  // ไอคอนคลินิก
                  Container(
                    width: context.rs(28),
                    height: context.rs(28),
                    decoration: BoxDecoration(
                      color: AppColors.purpleLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.local_hospital_outlined,
                      size: context.rs(14),
                      color: AppColors.purple,
                    ),
                  ),
                  SizedBox(width: context.rs(8)),
                  Expanded(
                    child: Text(
                      item.clinicName,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(11),
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Badge สถานะ
                  _StatusBadge(status: item.status),
                ],
              ),
            ),

            // ---- Body: รายละเอียดการจอง ----
            Padding(
              padding: EdgeInsets.all(context.rs(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ชื่อบริการ
                  Text(
                    item.serviceName,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(14),
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),

                  SizedBox(height: context.rs(10)),

                  // แถวข้อมูล: หมอ, วันที่, เวลา
                  _CardDetailRow(
                    icon: Icons.person_outline,
                    text: item.doctorName,
                  ),
                  SizedBox(height: context.rs(6)),
                  _CardDetailRow(
                    svgAsset:
                        'assets/images/Book_an_appointment/uil_calender.svg',
                    text: item.appointmentDate,
                  ),
                  SizedBox(height: context.rs(6)),
                  _CardDetailRow(
                    svgAsset:
                        'assets/images/Book_an_appointment/iconamoon_clock-fill.svg',
                    text: item.appointmentTime,
                  ),

                  // ---- แถบรอชำระมัดจำ (ถ้ามี) ----
                  if (item.status == QueueStatus.waitingPayment &&
                      item.depositAmount != null) ...[
                    SizedBox(height: context.rs(12)),
                    _DepositWarningBar(amount: item.depositAmount!),
                  ],

                  SizedBox(height: context.rs(12)),

                  // ---- เลขที่การจอง + arrow ----
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'หมายเลขการจอง: ${item.bookingId}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(10),
                          color: AppColors.textGray,
                        ),
                      ),
                      Container(
                        width: context.rs(24),
                        height: context.rs(24),
                        decoration: BoxDecoration(
                          color: AppColors.homeBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          size: context.rs(16),
                          color: AppColors.purple,
                        ),
                      ),
                    ],
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
// _StatusBadge — badge แสดงสถานะ
// ============================================================
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final QueueStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(10),
        vertical: context.rs(4),
      ),
      decoration: BoxDecoration(
        color: status.badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(context.rs(20)),
        border: Border.all(
          color: status.badgeColor.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: context.rs(9),
          fontWeight: FontWeight.w600,
          color: status.badgeColor,
        ),
      ),
    );
  }
}

// ============================================================
// _CardDetailRow — แถวข้อมูลใน card (icon + text)
// ============================================================
class _CardDetailRow extends StatelessWidget {
  const _CardDetailRow({
    this.icon,
    this.svgAsset,
    required this.text,
  }) : assert(icon != null || svgAsset != null);

  final IconData? icon;
  final String? svgAsset;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (svgAsset != null)
          SvgPicture.asset(
            svgAsset!,
            width: context.rs(14),
            height: context.rs(14),
            colorFilter:
                ColorFilter.mode(AppColors.purple, BlendMode.srcIn),
          )
        else
          Icon(icon, size: context.rs(14), color: AppColors.purple),
        SizedBox(width: context.rs(8)),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(12),
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// _DepositWarningBar — แถบเตือนรอชำระมัดจำ
// ============================================================
class _DepositWarningBar extends StatelessWidget {
  const _DepositWarningBar({required this.amount});
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(12),
        vertical: context.rs(8),
      ),
      decoration: BoxDecoration(
        color: AppColors.orange.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(context.rs(10)),
        border: Border.all(
          color: AppColors.orange.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: context.rs(14),
            color: AppColors.orange,
          ),
          SizedBox(width: context.rs(8)),
          Expanded(
            child: Text(
              'กรุณาชำระมัดจำ ฿$amount เพื่อยืนยันการจอง',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(11),
                fontWeight: FontWeight.w500,
                color: AppColors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _EmptyQueueState — empty state เมื่อไม่มีคิว
// ============================================================
class _EmptyQueueState extends StatelessWidget {
  const _EmptyQueueState({
    required this.message,
    required this.subMessage,
    required this.showBookButton,
    this.onBookTap,
  });

  final String message;
  final String subMessage;
  final bool showBookButton;
  final VoidCallback? onBookTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.rs(40)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon ปฏิทินว่าง
            Container(
              width: context.rs(72),
              height: context.rs(72),
              decoration: BoxDecoration(
                color: AppColors.purpleLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/homescreen/queue_of.svg',
                  width: context.rs(36),
                  height: context.rs(36),
                  colorFilter: const ColorFilter.mode(
                    AppColors.purple,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),

            SizedBox(height: context.rs(16)),

            Text(
              message,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(15),
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),

            if (subMessage.isNotEmpty) ...[
              SizedBox(height: context.rs(6)),
              Text(
                subMessage,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(13),
                  fontWeight: FontWeight.w400,
                  color: AppColors.textGray,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            if (showBookButton) ...[
              SizedBox(height: context.rs(24)),
              SizedBox(
                width: context.rs(180),
                height: context.rs(42),
                child: ElevatedButton(
                  onPressed: onBookTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.rs(30)),
                    ),
                  ),
                  child: Text(
                    'จองคิวเลย',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(14),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
