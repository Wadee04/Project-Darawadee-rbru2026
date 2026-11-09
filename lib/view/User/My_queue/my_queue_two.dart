import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/shared_widgets.dart';
import '../../../services/service_locator.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';
import '../Book_an_appointment/book_an_appointment_one.dart';
import '../HomeScreen/home_page_one.dart';
import '../Profile/profile.dart';
import 'my_queue_one.dart';
import 'my_queue_two_detail.dart';

// ============================================================
// MyQueuePage - หน้า "คิวของฉัน" (รายการคิว + แท็บ + ตัวกรอง)
// ============================================================
enum _QueueTab { upcoming, past, cancelled }

class MyQueuePage extends StatefulWidget {
  const MyQueuePage({
    super.key,
    this.queues,
    this.currentNavIndex = 2,
    this.onNavTap,
    this.onPickDateRange,
    this.initialTab = 1,
  });

  /// รายการคิวทั้งหมดของผู้ใช้ (เรียงจากใหม่ → เก่า)
  /// ถ้าไม่ส่งมา หน้านี้จะโหลดข้อมูลจาก BookingService เอง
  final List<QueueItem>? queues;
  final int currentNavIndex;
  final void Function(int)? onNavTap;

  /// เรียกเมื่อกดปุ่ม "ช่วงเวลา" (ไว้ให้หน้าที่เรียกใช้กรองข้อมูลเอง)
  final VoidCallback? onPickDateRange;

  /// 0 = กำลังจะมาถึง, 1 = ที่ผ่านมา, 2 = ยกเลิก/ล้มเลิก
  final int initialTab;

  @override
  State<MyQueuePage> createState() => _MyQueuePageState();
}

class _MyQueuePageState extends State<MyQueuePage> {
  late _QueueTab _tab = _QueueTab.values[widget.initialTab.clamp(0, 2)];
  bool _newestFirst = true;
  bool _loading = true;
  List<QueueItem> _queues = [];

  @override
  void initState() {
    super.initState();
    final given = widget.queues;
    if (given != null) {
      _queues = given;
      _loading = false;
    } else {
      _loadQueues();
    }
  }

  Future<void> _loadQueues() async {
    try {
      final bookings = await ServiceLocator.booking.getMyBookings();
      if (!mounted) return;
      // เรียงจากวันที่ใหม่ → เก่า (ปุ่ม "ล่าสุดก่อน" เป็นค่าเริ่มต้น)
      final sorted = (bookings as List).cast<BookingModel>()
        ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
      if (!mounted) return;
      setState(() {
        _queues = queueItemsFromBookings(sorted);
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool _inTab(QueueStatus s) {
    switch (_tab) {
      case _QueueTab.upcoming:
        return s == QueueStatus.confirmed || s == QueueStatus.inProgress;
      case _QueueTab.past:
        return s == QueueStatus.completed;
      case _QueueTab.cancelled:
        return s == QueueStatus.cancelled;
    }
  }

  void _handleNav(int i) {
    if (i == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePageOne()),
        (route) => false,
      );
      return;
    }
    if (widget.onNavTap != null) {
      widget.onNavTap!.call(i);
      return;
    }
    if (i == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BookAnAppointmentOne()),
      );
    }
    if (i == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var items = _queues.where((q) => _inTab(q.status)).toList();
    if (!_newestFirst) items = items.reversed.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ---- Title ----
            Padding(
              padding:
                  EdgeInsets.only(top: context.rs(12), bottom: context.rs(16)),
              child: Text(
                'คิวของฉัน',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),

            // ---- Tabs ----
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rs(16)),
              child: Row(
                children: [
                  _TabChip(
                    flex: 6,
                    label: 'คิวที่กำลังจะมาถึง',
                    selected: _tab == _QueueTab.upcoming,
                    onTap: () => setState(() => _tab = _QueueTab.upcoming),
                  ),
                  SizedBox(width: context.rs(8)),
                  _TabChip(
                    flex: 5,
                    label: 'คิวที่ผ่านมา',
                    selected: _tab == _QueueTab.past,
                    onTap: () => setState(() => _tab = _QueueTab.past),
                  ),
                  SizedBox(width: context.rs(8)),
                  _TabChip(
                    flex: 5,
                    label: 'ยกเลิก/ล้มเลิก',
                    selected: _tab == _QueueTab.cancelled,
                    onTap: () => setState(() => _tab = _QueueTab.cancelled),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.rs(12)),

            // ---- Filters + รายการคิว ----
            FilterAndCardList(
              items: items,
              loading: _loading,
              newestFirst: _newestFirst,
              onPickDateRange: widget.onPickDateRange,
              onToggleSort: () =>
                  setState(() => _newestFirst = !_newestFirst),
              onCardTap: (item) => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MyQueueTwo(queue: item)),
              ),
              cardBuilder: (context, item, onTap) =>
                  QueueCard(queue: item, onTap: onTap),
            ),
          ],
        ),
      ),

      // ---- Bottom Nav ----
      bottomNavigationBar: SafeArea(
        top: false,
        child: AppBottomNav(
          currentIndex: widget.currentNavIndex,
          onTap: _handleNav,
        ),
      ),
    );
  }
}

// ============================================================
// _TabChip
// ============================================================
class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.flex = 1,
  });

  final int flex;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: context.rs(32),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.orange : Colors.white,
            borderRadius: BorderRadius.circular(context.rs(20)),
            border: Border.all(
              color: selected ? AppColors.orange : AppColors.black,
              width: 1,
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(11),
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// QueueCard - การ์ดคิวหนึ่งรายการ (ใช้แสดงในหน้าคิวของฉัน)
// ============================================================
class QueueCard extends StatelessWidget {
  const QueueCard({super.key, required this.queue, required this.onTap});

  final QueueItem queue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.rs(14)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(context.rs(16)),
          border: Border.all(color: AppColors.inputBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar (รูปฟัน)
            Container(
              margin: EdgeInsets.only(top: context.rs(4)),
              width: context.rs(64),
              height: context.rs(64),
              decoration: BoxDecoration(
                color: const Color(0xFFD6EBFA),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.registerButton, width: 1),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/my_queue/mascot-queue.png',
                width: context.rs(45.02),
                height: context.rs(31.02),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: context.rs(12)),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        queue.appointmentDateShort ?? queue.appointmentDate,
                        style: _small(context),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: context.rs(6)),
                        child: Container(
                          width: 1,
                          height: context.rs(10),
                          color: AppColors.inputBorder,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          queue.appointmentTime,
                          overflow: TextOverflow.ellipsis,
                          style: _small(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.rs(4)),
                  Text(
                    queue.serviceName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(14),
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: context.rs(2)),
                  Text(
                    queue.doctorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(12),
                      fontWeight: FontWeight.w500,
                      color: AppColors.purple,
                    ),
                  ),
                  SizedBox(height: context.rs(4)),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: context.rs(14), color: AppColors.textGray),
                      SizedBox(width: context.rs(2)),
                      Flexible(
                        child: Text(
                          queue.clinicName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(11),
                            fontWeight: FontWeight.w500,
                            color: AppColors.textGray,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: context.rs(8)),
            // ขยับป้ายสถานะลงมาให้อยู่ระหว่าง "ชื่อบริการ" กับ "ชื่อทันตแพทย์"
            Padding(
              padding: EdgeInsets.only(top: context.rs(29)),
              child: _StatusBadge(status: queue.status),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _small(BuildContext context) => TextStyle(
        fontFamily: 'Inter',
        fontSize: context.rs(10),
        color: AppColors.textGray,
      );
}

// ============================================================
// _StatusBadge - ป้ายสถานะคิว
// ============================================================
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final QueueStatus status;

  @override
  Widget build(BuildContext context) {
    final (String text, Color bg, Color fg) = switch (status) {
      QueueStatus.confirmed =>
        ('ยืนยันแล้ว', const Color(0xFFDCE8FF), const Color(0xFF2F5FC4)),
      QueueStatus.inProgress =>
        ('กำลังรับบริการ', const Color(0xFFEEEAFF), AppColors.purple),
      QueueStatus.completed =>
        ('เสร็จสิ้น', const Color(0xFFC8EFCF), const Color(0xFF2E7D32)),
      QueueStatus.cancelled =>
        ('ยกเลิก', const Color(0xFFFFD9D9), AppColors.reddentbook),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(15),
        vertical: context.rs(3),
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(context.rs(12)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: context.rs(12),
          fontWeight: FontWeight.w500,
          color: fg,
        ),
      ),
    );
  }
}

// ============================================================
// _AssetIcon - ไอคอน SVG พร้อม fallback เมื่อโหลด asset ไม่สำเร็จ
// ============================================================
class _AssetIcon extends StatelessWidget {
  const _AssetIcon({
    required this.asset,
    this.width = 16,
    this.height = 16,
  });

  /// path ของไฟล์ SVG เช่น 'assets/images/my_queue/arrow-up-down.svg'
  final String asset;

  /// ความกว้าง (จะถูก scale ตามขนาดหน้าจอผ่าน context.rs)
  final double width;

  /// ความสูง (จะถูก scale ตามขนาดหน้าจอผ่าน context.rs)
  final double height;

  @override
  Widget build(BuildContext context) {
    final double w = context.rs(width);
    final double h = context.rs(height);
    return SvgPicture.asset(
      asset,
      width: w,
      height: h,
      colorFilter:
          const ColorFilter.mode(AppColors.textGray, BlendMode.srcIn),
      placeholderBuilder: (context) => SizedBox(width: w, height: h),
      errorBuilder: (context, error, stackTrace) =>
          SizedBox(width: w, height: h),
    );
  }
}

// ============================================================
// _FilterBox - ปุ่มตัวกรอง (ช่วงเวลา / เรียงลำดับ)
// ============================================================
class _FilterBox extends StatelessWidget {
  const _FilterBox({
    required this.leading,
    required this.label,
    this.onTap,
  });

  /// ไอคอนด้านหน้า — ใช้ _AssetIcon (SVG) หรือ Icon (Material) ได้
  final Widget leading;

  /// ข้อความในกล่อง
  final String label;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(context.rs(8));
    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          width: context.rs(108),
          height: context.rs(26),
          padding: EdgeInsets.symmetric(horizontal: context.rs(10)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: radius,
            border: Border.all(color: AppColors.inputBorder, width: 1),
          ),
          child: Row(
            children: [
              IconTheme.merge(
                data: IconThemeData(
                  size: context.rs(16),
                  color: AppColors.textGray,
                ),
                child: leading,
              ),
              SizedBox(width: context.rs(6)),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(12),
                    color: AppColors.textGray,
                  ),
                ),
              ),
              IconTheme.merge(
                data: IconThemeData(
                  size: context.rs(18),
                  color: AppColors.textGray,
                ),
                child: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// FilterAndCardList — ส่วนตั้งแต่ filter (ช่วงเวลา / ล่าสุดก่อน)
// ลงมาถึงการ์ดข้อมูล วางใน Column ได้เลย (มี Expanded อยู่ข้างใน)
// ============================================================
class FilterAndCardList extends StatelessWidget {
  const FilterAndCardList({
    super.key,
    required this.items,
    this.loading = false,
    this.newestFirst = true,
    this.dateFilterLabel = 'ช่วงเวลา',
    this.sortFilterLabel,
    this.emptyMessage = 'ไม่มีรายการคิว',
    this.onPickDateRange,
    this.onToggleSort,
    this.onCardTap,
    required this.cardBuilder,
  });

  /// รายการคิวที่จะแสดง
  final List<QueueItem> items;

  /// กำลังโหลดข้อมูลอยู่หรือไม่
  final bool loading;

  /// เรียงลำดับ: true = ล่าสุดก่อน, false = เก่าสุดก่อน
  final bool newestFirst;

  /// ข้อความในช่องตัวกรองช่วงเวลา
  final String dateFilterLabel;

  /// ข้อความในช่องตัวกรองเรียงลำดับ (ถ้าไม่ส่งจะใช้ตาม newestFirst)
  final String? sortFilterLabel;

  /// ข้อความตอนไม่มีรายการ
  final String emptyMessage;

  final VoidCallback? onPickDateRange;
  final VoidCallback? onToggleSort;
  final void Function(QueueItem item)? onCardTap;

  /// วิธีสร้างการ์ดแต่ละรายการ (กำหนดจากหน้าที่เรียกใช้ เพื่อให้แต่ละหน้าเลือกการ์ดของตัวเองได้)
  final Widget Function(BuildContext context, QueueItem item, VoidCallback onTap)
      cardBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ---- Filters ----
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _FilterBox(
                leading: const _AssetIcon(
                  asset:
                      'assets/images/Book_an_appointment/make-an-appointment.svg',
                  width: 10,
                  height: 10,
                ),
                label: dateFilterLabel,
                onTap: onPickDateRange,
              ),
              _FilterBox(
                leading: const _AssetIcon(
                  asset: 'assets/images/my_queue/arrow-up-down.svg',
                  width: 10.43,
                  height: 6.52,
                ),
                label: sortFilterLabel ??
                    (newestFirst ? 'ล่าสุดก่อน' : 'เก่าสุดก่อน'),
                onTap: onToggleSort,
              ),
            ],
          ),
        ),

        SizedBox(height: context.rs(12)),

        // ---- รายการคิว ----
        Expanded(
          child: loading
              ? const SizedBox.shrink()
              : items.isEmpty
                  ? Center(
                      child: Text(
                        emptyMessage,
                        style: TextStyle(
                          fontFamily: 'Noto Sans Thai',
                          fontSize: context.rs(13),
                          color: AppColors.textGray,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        context.rs(24),
                        context.rs(4),
                        context.rs(24),
                        context.rs(16),
                      ),
                      itemCount: items.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(height: context.rs(12)),
                      itemBuilder: (_, i) {
                        void onTap() => onCardTap?.call(items[i]);
                        return cardBuilder(context, items[i], onTap);
                      },
                    ),
        ),
      ],
    );
  }
}
