import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../components/shared_widgets.dart';
import '../../../router/app_router.dart';
import '../../../services/service_locator.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';
import '../Book_an_appointment/book_an_appointment_one.dart';
import '../Book_an_appointment/book_an_appointment_six.dart';
import 'my_queue_two.dart';
import 'my_queue_two_detail.dart';
import 'my_queue_three.dart';

// ============================================================
// MyQueueOne - หน้าคิวของฉัน
// ============================================================

/// สถานะของคิว
enum QueueStatus {
  confirmed, // ยืนยันแล้ว
  inProgress, // กำลังดำเนินการ
  completed, // เสร็จสิ้น
  cancelled, // ยกเลิกแล้ว
}

extension QueueStatusExt on QueueStatus {
  String get label {
    switch (this) {
      case QueueStatus.confirmed:
        return 'ยืนยันแล้ว';
      case QueueStatus.inProgress:
        return 'อยู่รอดยืน';
      case QueueStatus.completed:
        return '';
      case QueueStatus.cancelled:
        return 'ยกเลิกแล้ว';
    }
  }

  Color get badgeColor {
    switch (this) {
      case QueueStatus.confirmed:
        return const Color(0xFF306E32);
      case QueueStatus.inProgress:
        return AppColors.textGray;
      case QueueStatus.completed:
        return AppColors.textGray;
      case QueueStatus.cancelled:
        return AppColors.reddentbook;
    }
  }

  Color get badgeBgColor {
    switch (this) {
      case QueueStatus.confirmed:
        return AppColors.greendentbook.withValues(alpha: 0.30);
      case QueueStatus.inProgress:
        return const Color(0xFFD9D9D9);
      case QueueStatus.completed:
        return const Color(0xFFD9D9D9);
      case QueueStatus.cancelled:
        return const Color(0xFFFFD3D4);
    }
  }
}

/// ข้อมูลคิวหนึ่งรายการ
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
    this.doctorRole = 'ทันตแพทย์',
    this.serviceSubtitle,
    this.appointmentDateShort,
    this.appointmentDateTime,
  });

  final String bookingId;
  final String clinicName;
  final String serviceName;
  final String doctorName;
  final String appointmentDate;

  /// วันที่แบบสั้น เช่น "7 ส.ค. 2569" (ใช้ในการ์ดแบบย่อของแท็บ "คิวที่ผ่านมา")
  final String? appointmentDateShort;

  /// วันที่จริง (ใช้เรียงลำดับ)
  final DateTime? appointmentDateTime;
  final String appointmentTime;
  final QueueStatus status;
  final int? depositAmount;
  final String doctorRole;
  final String? serviceSubtitle;

  /// คัดลอกข้อมูล (ใช้ตอนเลื่อนนัด)
  QueueItem copyWith({
    String? clinicName,
    String? serviceName,
    String? doctorName,
    String? appointmentDate,
    String? appointmentDateShort,
    DateTime? appointmentDateTime,
    String? appointmentTime,
    QueueStatus? status,
    int? depositAmount,
    String? doctorRole,
    String? serviceSubtitle,
  }) {
    return QueueItem(
      bookingId: bookingId,
      clinicName: clinicName ?? this.clinicName,
      serviceName: serviceName ?? this.serviceName,
      doctorName: doctorName ?? this.doctorName,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentDateShort: appointmentDateShort ?? this.appointmentDateShort,
      appointmentDateTime: appointmentDateTime ?? this.appointmentDateTime,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      status: status ?? this.status,
      depositAmount: depositAmount ?? this.depositAmount,
      doctorRole: doctorRole ?? this.doctorRole,
      serviceSubtitle: serviceSubtitle ?? this.serviceSubtitle,
    );
  }
}

// ============================================================
// ฟังก์ชันช่วยแปลงข้อมูล booking จาก service → QueueItem (ใช้ร่วมกันทุกหน้าคิว)
// ============================================================

/// แปลงสถานะจาก BookingStatus เป็น QueueStatus
QueueStatus queueStatusFromBooking(BookingStatus status) {
  switch (status) {
    case BookingStatus.confirmed:
      return QueueStatus.confirmed;
    case BookingStatus.inProgress:
      return QueueStatus.inProgress;
    case BookingStatus.completed:
      return QueueStatus.completed;
    default:
      return QueueStatus.cancelled;
  }
}

/// จัดรูปแบบวันที่แบบไทย เช่น "วันอังคารที่ 5 สิงหาคม 2569"
String formatQueueDate(DateTime d) {
  const days = [
    '',
    'จันทร์',
    'อังคาร',
    'พุธ',
    'พฤหัสบดี',
    'ศุกร์',
    'เสาร์',
    'อาทิตย์',
  ];
  const months = [
    '',
    'มกราคม',
    'กุมภาพันธ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฎาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม',
  ];
  return 'วัน${days[d.weekday]}ที่ ${d.day} ${months[d.month]} ${d.year + 543}';
}

/// จัดรูปแบบวันที่แบบสั้น เช่น "7 ส.ค. 2569"
String formatQueueDateShort(DateTime d) {
  const shortMonths = [
    '',
    'ม.ค.',
    'ก.พ.',
    'มี.ค.',
    'เม.ย.',
    'พ.ค.',
    'มิ.ย.',
    'ก.ค.',
    'ส.ค.',
    'ก.ย.',
    'ต.ค.',
    'พ.ย.',
    'ธ.ค.',
  ];
  return '${d.day} ${shortMonths[d.month]} ${d.year + 543}';
}

/// แปลงรายการ booking ทั้งหมดของผู้ใช้เป็น QueueItem สำหรับแสดงผล
List<QueueItem> queueItemsFromBookings(List<BookingModel> bookings) {
  return bookings
      .map(
        (b) => QueueItem(
          bookingId: b.bookingCode,
          clinicName: b.clinicName,
          serviceName: b.serviceName,
          serviceSubtitle: b.serviceNameEn,
          doctorName: b.doctorName,
          appointmentDate: formatQueueDate(b.appointmentDate),
          appointmentDateShort: formatQueueDateShort(b.appointmentDate),
          appointmentDateTime: b.appointmentDate,
          appointmentTime: '${b.appointmentTime} น.',
          status: queueStatusFromBooking(b.status),
          depositAmount: b.depositAmount.toInt(),
        ),
      )
      .toList();
}

// ============================================================
// MyQueueOne Widget
// ============================================================
class MyQueueOne extends StatefulWidget {
  const MyQueueOne({super.key, this.onHome, this.onBooking, this.onProfile});

  final VoidCallback? onHome;
  final VoidCallback? onBooking;
  final VoidCallback? onProfile;

  @override
  State<MyQueueOne> createState() => _MyQueueOneState();
}

class _MyQueueOneState extends State<MyQueueOne>
    with SingleTickerProviderStateMixin {
  int _navIndex = 2;
  late TabController _tabController;
  int _selectedFilter = 0;
  List<QueueItem> _allQueues = [];
  bool _loading = true;

  // ---- ตัวกรองเพิ่มเติม ----
  bool _newestFirst = true;
  int? _rangeDays; // null = ทั้งหมด

  // ---- Filter labels ----
  static const List<String> _filters = [
    'คิวที่กำลังจะมาถึง',
    'คิวที่ผ่านมา',
    'ยกเลิก/เลื่อนนัด',                          
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChange);
    _loadQueues();
  }

  void _onTabChange() {
    if (mounted && _tabController.index != _selectedFilter) {
      setState(() => _selectedFilter = _tabController.index);
    }
  }

  Future<void> _loadQueues() async {
    try {
      final bookings = await ServiceLocator.booking.getMyBookings();
      if (!mounted) return;
      setState(() {
        _allQueues = queueItemsFromBookings(
          (bookings as List).cast<BookingModel>(),
        );
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// ข้อความในช่องตัวกรองช่วงเวลา
  String get _rangeLabel {
    switch (_rangeDays) {
      case 7:
        return '7 วันล่าสุด';
      case 30:
        return '30 วันล่าสุด';
      case 90:
        return '90 วันล่าสุด';
      default:
        return 'ช่วงเวลา';
    }
  }

  /// กรองตามช่วงเวลา + เรียงลำดับ (ล่าสุดก่อน / เก่าสุดก่อน)
  List<QueueItem> _applyFilter(List<QueueItem> list) {
    var result = list;
    final days = _rangeDays;
    if (days != null) {
      final now = DateTime.now();
      final cutoff = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: days - 1));
      result = result.where((q) {
        final d = q.appointmentDateTime;
        if (d == null) return true;
        return !d.isBefore(cutoff);
      }).toList();
    }
    final sorted = [...result];
    sorted.sort((a, b) {
      final da = a.appointmentDateTime;
      final db = b.appointmentDateTime;
      if (da == null || db == null) return 0;
      return _newestFirst ? db.compareTo(da) : da.compareTo(db);
    });
    return sorted;
  }

  /// เลือกช่วงเวลา (ทั้งหมด / 7 / 30 / 90 วันล่าสุด)
  Future<void> _pickDateRange() async {
    const options = <({String label, int? days})>[
      (label: 'ทั้งหมด', days: null),
      (label: '7 วันล่าสุด', days: 7),
      (label: '30 วันล่าสุด', days: 30),
      (label: '90 วันล่าสุด', days: 90),
    ];
    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.inputBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'ช่วงเวลา',
              style: TextStyle(
                fontFamily: 'Noto Sans Thai',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            for (final o in options)
              ListTile(
                title: Text(
                  o.label,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans Thai',
                    fontSize: 14,
                    color: AppColors.black,
                  ),
                ),
                trailing: _rangeDays == o.days
                    ? const Icon(Icons.check, color: AppColors.purple)
                    : null,
                onTap: () => Navigator.pop(ctx, o.days ?? -1),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (picked == null || !mounted) return;
    setState(() => _rangeDays = picked == -1 ? null : picked);
  }

  List<QueueItem> get _activeQueues => _allQueues
      .where(
        (q) =>
            q.status == QueueStatus.confirmed ||
            q.status == QueueStatus.inProgress,
      )
      .toList();

  List<QueueItem> get _completedQueues => _applyFilter(
        _allQueues.where((q) => q.status == QueueStatus.completed).toList(),
      );

  List<QueueItem> get _cancelledQueues =>
      _allQueues.where((q) => q.status == QueueStatus.cancelled).toList();

  @override
  void dispose() {
    _tabController.removeListener(_onTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _openDetail(QueueItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MyQueueTwo(queue: item)),
    );
  }

  /// เลื่อนนัด — ไปหน้าเลือกวัน (BookAnAppointmentSix) → เลือกเวลา
  /// (BookAnAppointmentSeven) แล้วกลับมาอัปเดตข้อมูลในการ์ดนี้
  Future<void> _reschedule(QueueItem item) async {
    final result = await Navigator.push<RescheduleResult>(
      context,
      MaterialPageRoute(
        builder: (_) => BookAnAppointmentSix(
          doctorName: item.doctorName,
          doctorSpecialty: item.doctorRole,
          isReschedule: true,
        ),
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _allQueues = _allQueues
          .map(
            (q) => q.bookingId == item.bookingId
                ? q.copyWith(
                    appointmentDate: formatQueueDate(result.date),
                    appointmentDateShort: formatQueueDateShort(result.date),
                    appointmentDateTime: result.date,
                    appointmentTime: '${result.time} น.',
                  )
                : q,
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ---- Header ----
            const _MyQueueHeader(),

            // ---- Filter Chips ----
            Container(
              color: AppColors.white,
              padding: EdgeInsets.fromLTRB(
                context.rs(24),
                context.rs(12),
                context.rs(24),
                context.rs(12),
              ),
              child: SizedBox(
                height: context.rs(32),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var i = 0; i < _filters.length; i++)
                        Padding(
                          padding: EdgeInsets.only(
                            right: i == _filters.length - 1 ? 0 : context.rs(8),
                          ),
                          child: _FilterChip(
                            label: _filters[i],
                            selected: _selectedFilter == i,
                            onTap: () {
                              setState(() => _selectedFilter = i);
                              _tabController.animateTo(i);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // ---- Tab content ----
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // คิวที่กำลังจะมาถึง
                  _QueueList(
                    loading: _loading,
                    items: _activeQueues,
                    emptyMessage: 'ยังไม่มีคิวที่กำลังจะมาถึง',
                    emptySubMessage: 'จองคิวกับคลินิกทันตกรรมได้เลย',
                    showBookButton: true,
                    onBookTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BookAnAppointmentOne(),
                        ),
                      );
                    },
                    onCardTap: _openDetail,
                    onReschedule: _reschedule,
                  ),
                  // เสร็จสิ้น (การ์ดแบบย่อ + ตัวกรองช่วงเวลา/เรียงลำดับ)
                  FilterAndCardList(
                    loading: _loading,
                    items: _completedQueues,
                    dateFilterLabel: _rangeLabel,
                    onPickDateRange: _pickDateRange,
                    onToggleSort: () =>
                        setState(() => _newestFirst = !_newestFirst),
                    onCardTap: _openDetail,
                    emptyMessage: 'ยังไม่มีคิวที่เสร็จสิ้น',
                    cardBuilder: (context, item, onTap) =>
                        QueueCard(queue: item, onTap: onTap),
                  ),
                  // ยกเลิก/ไม่มาตามนัด
                  FilterAndCardList(
                    loading: _loading,
                    items: _cancelledQueues,
                    dateFilterLabel: _rangeLabel ?? 'ช่วงเวลา',
                    onPickDateRange: _pickDateRange,
                    onToggleSort: () =>
                        setState(() => _newestFirst = !_newestFirst),
                    onCardTap: (item) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MyQueueTwo(queue: item)),
                    ),
                    emptyMessage: 'ยังไม่มีคิวที่ยกเลิก/เลื่อนนัด',
                    cardBuilder: (context, item, onTap) => CancelQueueCard(
                      item: QueueItemCancel(
                        date: item.appointmentDateShort ?? item.appointmentDate,
                        time: item.appointmentTime,
                        title: item.serviceName,
                        doctor: item.doctorName,
                        clinic: item.clinicName,
                        status: QueueStatusCancel.cancel,
                      ),
                    ),
                  ),                ],
              ),
            ),

            // ---- Bottom Navigation ----
            AppBottomNav(
              currentIndex: _navIndex,
              onTap: (i) {
                AppRouter.goBottomTab(
                  context,
                  i,
                  currentIndex: _navIndex,
                  onHome: widget.onHome,
                  onBooking: widget.onBooking,
                  onProfile: widget.onProfile,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MyQueueHeader extends StatelessWidget {
  const _MyQueueHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.fromLTRB(
        context.rs(24),
        MediaQuery.of(context).size.height * 0.01,
        context.rs(24),
        context.rs(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'คิวของฉัน',
            style: TextStyle(
              fontFamily: 'Noto Sans Thai',
              fontSize: context.rs(16),
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _FilterChip — chip เลือกหมวด
// ============================================================
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.rs(14),
          vertical: context.rs(6),
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.orange : Colors.white,
          border: selected
              ? null
              : Border.all(
                  color: Colors.black.withValues(alpha: 0.20),
                  width: 1,
                ),
          borderRadius: BorderRadius.circular(context.rs(20)),
        ),
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Noto Sans Thai',
              fontSize: context.rs(12),
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? AppColors.black : AppColors.textGray,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _QueueList — รายการคิว (หรือ empty state)
// ============================================================
class _QueueList extends StatelessWidget {
  const _QueueList({
    required this.items,
    required this.emptyMessage,
    required this.emptySubMessage,
    required this.showBookButton,
    required this.onCardTap,
    this.loading = false,
    this.onBookTap,
    this.onReschedule,
  });

  final List<QueueItem> items;
  final String emptyMessage;
  final String emptySubMessage;
  final bool showBookButton;
  final void Function(QueueItem) onCardTap;

  /// กำลังโหลดข้อมูลอยู่ (ยังไม่แสดง empty state)
  final bool loading;
  final VoidCallback? onBookTap;

  /// เรียกเมื่อกดปุ่ม "เลื่อนนัด" ในการ์ด
  final void Function(QueueItem item)? onReschedule;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox.shrink();
    }
    if (items.isEmpty) {
      return _EmptyQueueStateWidget(
        message: emptyMessage,
        subMessage: emptySubMessage,
        showBookButton: showBookButton,
        onBookTap: onBookTap,
      );
    }
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        context.rs(24),
        context.rs(4),
        context.rs(24),
        context.rs(16),
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        void onTap() => onCardTap(items[i]);
        return _QueueCard(
          item: items[i],
          onTap: onTap,
          onReschedule: onReschedule == null
              ? null
              : () => onReschedule!(items[i]),
        );
      },
    );
  }
}


// ============================================================
// _QrFullscreenDialog — แสดง QR ขนาดใหญ่กลางจอ (พื้นหลังเบลอ สีดำ 70%)
// ============================================================
class _QrFullscreenDialog extends StatelessWidget {
  const _QrFullscreenDialog({required this.data});

  final String data;

  /// ขนาด QR ขนาดใหญ่
  static const double qrSize = 300;

  /// ขนาดพื้นหลังสีขาวใต้ QR
  static const double whiteBoxSize = 328;
 
  static Future<void> show(BuildContext context, String data) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'QR Code',
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
      transitionBuilder: (_, animation, _, child) => child,
      pageBuilder: (_, _, _) => _QrFullscreenDialog(data: data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () => Navigator.of(context).maybePop(),
        child: Stack(
          children: [
            // ---- พื้นหลังเบลอ 10 + สีดำ 70% ----
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black.withValues(alpha: 0.60)),
              ),
            ),

            // ---- QR กลางจอ ----
            Center(
              child: Container(
                width: whiteBoxSize,
                height: whiteBoxSize,
                color: Colors.white,
                alignment: Alignment.center,
                child: QrImageView(
                  data: data,
                  version: QrVersions.auto,
                  size: qrSize,
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Colors.black,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // ---- ปุ่มปิด มุมบนขวา ----
            Positioned(
              top: 40,
              right: 24,
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  padding: EdgeInsets.all(context.rs(8)),
                  child: SvgPicture.asset(
                    'assets/images/Book_an_appointment/close.svg',
                    width: context.rs(11),
                    height: context.rs(11),
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
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
// _QueueCard — การ์ดคิวหนึ่งรายการ
// ============================================================
const Color _subText = Color(0xFF8A86A8);
const Color _grayText = Color(0xFF8C8C8C);

class _QueueCard extends StatelessWidget {
  const _QueueCard({
    required this.item,
    required this.onTap,
    this.onReschedule,
  });

  final QueueItem item;
  final VoidCallback onTap;

  /// เรียกเมื่อกดปุ่ม "เลื่อนนัด"
  final VoidCallback? onReschedule;

  Widget _icon(BuildContext context, String file, {Color? color}) =>
      SvgPicture.asset(
        'assets/images/Book_an_appointment/$file',
        width: context.rs(15),
        height: context.rs(15),
        colorFilter: ColorFilter.mode(
          color ?? AppColors.purple,
          BlendMode.srcIn,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: context.rs(12)),
        padding: EdgeInsets.all(context.rs(16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(context.rs(20)),
          border: Border.all(color: AppColors.purple, width: 1.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ===== Header: badge + queue code =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.rs(12),
                    vertical: context.rs(2),
                  ),
                  decoration: BoxDecoration(
                    color: item.status.badgeBgColor,
                    borderRadius: BorderRadius.circular(context.rs(20)),
                  ),
                  child: Text(
                    item.status.label,
                    style: TextStyle(
                      fontFamily: 'Noto Sans Thai',
                      color: item.status.badgeColor,
                      fontWeight: FontWeight.w500,
                      fontSize: context.rs(12),
                    ),
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'รหัสคิว  ',
                        style: TextStyle(
                          fontFamily: 'Noto Sans Thai',
                          fontSize: context.rs(12),
                          fontWeight: FontWeight.w400,
                          color: AppColors.purple,
                        ),
                      ),
                      TextSpan(
                        text: item.bookingId,
                        style: TextStyle(
                          fontFamily: 'Noto Sans Thai',
                          fontSize: context.rs(12),
                          fontWeight: FontWeight.w600,
                          color: AppColors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: context.rs(12)),

            // ===== Body: QR + details =====
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () =>
                        _QrFullscreenDialog.show(context, item.bookingId),
                    child: QrImageView(
                      data: item.bookingId,
                      version: QrVersions.auto,
                      size: context.rs(140),
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Colors.black,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: context.rs(16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoRow(
                        icon: _icon(context, 'make-an-appointment.svg'),
                        title: item.appointmentDate,
                        titleSize: context.rs(12),
                        bold: true,
                      ),
                      SizedBox(height: context.rs(10)),
                      _InfoRow(
                        icon: _icon(context, 'schedule.svg'),
                        title: item.appointmentTime,
                        titleSize: context.rs(12),
                        bold: true,
                      ),
                      SizedBox(height: context.rs(10)),
                      _InfoRow(
                        icon: _icon(context, 'doctor.svg'),
                        title: item.doctorName,
                        subtitle: item.doctorRole,
                        bold: true,
                      ),
                      SizedBox(height: context.rs(10)),
                      _InfoRow(
                        icon: _icon(context, 'toothten.svg'),
                        title: item.serviceName,
                        subtitle: '(Dental Check-up)',
                        bold: true,
                      ),
                      SizedBox(height: context.rs(10)),
                      _InfoRow(
                        icon: _icon(
                          context,
                          'heroicons_map-pin-16-solid.svg',
                          color: AppColors.purple,
                        ),
                        title: item.clinicName,
                        color: AppColors.purple,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: context.rs(20)),

            // ===== Buttons =====
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReschedule,
                    icon: _icon(context, 'make-an-appointment.svg'),
                    label: Text(
                      'เลื่อนนัด',
                      style: TextStyle(
                        fontSize: context.rs(14),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Noto Sans Thai',
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.purple,
                      side: const BorderSide(color: AppColors.purple),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: context.rs(12)),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onReschedule,
                    icon: SvgPicture.asset(
                      'assets/images/my_queue/akar-icons_edit.svg',
                      width: context.rs(15),
                      height: context.rs(15),
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: Text(
                      'ยกเลิกนัด',
                      style: TextStyle(
                        fontSize: context.rs(14),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Noto Sans Thai',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _InfoRow — แถวข้อมูล (ไอคอน + หัวข้อ + คำอธิบายรอง)
// ============================================================
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    this.titleSize,
    this.subtitle,
    this.bold = false,
    this.color = AppColors.purple,
  });

  final Widget icon;
  final String title;
  final double? titleSize;
  final String? subtitle;
  final bool bold;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        SizedBox(width: context.rs(6)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Noto Sans Thai',
                  fontSize: titleSize ?? context.rs(12),
                  height: 1.3,
                  color: color,
                  fontWeight: bold ? FontWeight.w500 : FontWeight.w500,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontFamily: 'Noto Sans Thai',
                    fontSize: context.rs(10),
                    height: 1.3,
                    fontWeight: FontWeight.w400,
                    color: _subText,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// _EmptyQueueStateWidget — แสดงเมื่อไม่มีคิว
// ============================================================
class _EmptyQueueStateWidget extends StatelessWidget {
  const _EmptyQueueStateWidget({
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
            // Icon วงกลม
            Container(
              width: context.rs(72),
              height: context.rs(72),
              decoration: const BoxDecoration(
                color: AppColors.purpleLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/homescreen/queue_of.svg',
                  width: context.rs(36),
                  height: context.rs(40),
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
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Noto Sans Thai',
                fontSize: context.rs(15),
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            if (subMessage.isNotEmpty) ...[
              SizedBox(height: context.rs(6)),
              Text(
                subMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Noto Sans Thai',
                  fontSize: context.rs(13),
                  fontWeight: FontWeight.w400,
                  color: AppColors.textGray,
                ),
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
                      fontFamily: 'Noto Sans Thai',
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
