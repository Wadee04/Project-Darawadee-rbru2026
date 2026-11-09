import 'package:flutter/material.dart';

import '../../../services/admin/admin_booking_service.dart';
import '../../../services/admin/admin_models.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// QueueManagementPage — จัดการคิวและตารางคิว (ปฏิทิน + Supabase)
// ============================================================
class QueueManagementPage extends StatefulWidget {
  const QueueManagementPage({super.key, this.onBack});
  final VoidCallback? onBack;

  @override
  State<QueueManagementPage> createState() => _QueueManagementPageState();
}

enum _TopTab { overview, waiting, cancelled }

class _QueueManagementPageState extends State<QueueManagementPage> {
  bool _loading = true;
  List<AdminBooking> _all = [];

  _TopTab _tab = _TopTab.overview;
  late DateTime _visibleMonth; // เดือนที่แสดงในปฏิทิน
  late DateTime _selectedDay;  // วันที่เลือก

  static const _thMonths = [
    '', 'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
    'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'
  ];
  static const _thDays = ['อา.', 'จ.', 'อ.', 'พ.', 'พฤ.', 'ศ.', 'ส.'];
  static const _thWeekdayFull = [
    '', 'วันจันทร์', 'วันอังคาร', 'วันพุธ', 'วันพฤหัสบดี', 'วันศุกร์', 'วันเสาร์', 'วันอาทิตย์'
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
    _selectedDay = DateTime(now.year, now.month, now.day);
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final bookings = await AdminBookingService.instance.getAllBookings();
      if (mounted) setState(() { _all = bookings; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  // bookings ที่ตรงกับ tab ที่เลือก
  List<AdminBooking> get _tabFiltered {
    switch (_tab) {
      case _TopTab.waiting:
        return _all.where((b) => b.status == AdminQueueStatus.waiting).toList();
      case _TopTab.cancelled:
        return _all.where((b) => b.status == AdminQueueStatus.cancelled).toList();
      case _TopTab.overview:
        return _all;
    }
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // bookings ของวันที่เลือก (เรียงตามเวลา)
  List<AdminBooking> get _dayBookings {
    final list = _tabFiltered.where((b) => _sameDay(b.appointmentDate, _selectedDay)).toList();
    list.sort((a, b) => a.appointmentTime.compareTo(b.appointmentTime));
    return list;
  }

  // วันที่มีนัด (ใช้แสดงจุดใต้วันในปฏิทิน)
  Set<int> get _daysWithBookings {
    final days = <int>{};
    for (final b in _tabFiltered) {
      if (b.appointmentDate.year == _visibleMonth.year &&
          b.appointmentDate.month == _visibleMonth.month) {
        days.add(b.appointmentDate.day);
      }
    }
    return days;
  }

  void _prevMonth() => setState(() =>
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1));
  void _nextMonth() => setState(() =>
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ---- AppBar ----
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.rs(8),
                MediaQuery.of(context).size.height * 0.01,
                context.rs(20),
                context.rs(8),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: widget.onBack ?? () => Navigator.maybePop(context),
                      child: Padding(
                        padding: EdgeInsets.all(context.rs(8)),
                        child: Icon(Icons.chevron_left,
                            size: context.rs(28), color: AppColors.black),
                      ),
                    ),
                  ),
                  Text('จัดการคิวและตารางคิว',
                      style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(15),
                          fontWeight: FontWeight.w600, color: AppColors.black)),
                ],
              ),
            ),

            // ---- Top pill tabs ----
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rs(16)),
              child: Row(
                children: [
                  _PillTab(
                    label: 'ภาพรวม',
                    selected: _tab == _TopTab.overview,
                    onTap: () => setState(() => _tab = _TopTab.overview),
                  ),
                  SizedBox(width: context.rs(8)),
                  _PillTab(
                    label: 'คิวที่รอยืนยัน',
                    selected: _tab == _TopTab.waiting,
                    onTap: () => setState(() => _tab = _TopTab.waiting),
                  ),
                  SizedBox(width: context.rs(8)),
                  _PillTab(
                    label: 'ยกเลิก/เลื่อนนัด',
                    selected: _tab == _TopTab.cancelled,
                    onTap: () => setState(() => _tab = _TopTab.cancelled),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.rs(12)),

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(
                            context.rs(16), 0, context.rs(16), context.rs(24)),
                        children: [
                          // ---- Calendar ----
                          _buildMonthNav(context),
                          SizedBox(height: context.rs(8)),
                          _buildWeekdayHeader(context),
                          SizedBox(height: context.rs(4)),
                          _buildCalendarGrid(context),

                          SizedBox(height: context.rs(20)),

                          // ---- วันที่เลือก ----
                          Text(
                            '${_thWeekdayFull[_selectedDay.weekday]} ที่ ${_selectedDay.day} '
                            '${_thMonths[_selectedDay.month]} ${_selectedDay.year + 543}',
                            style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(13),
                                fontWeight: FontWeight.w600, color: AppColors.black),
                          ),
                          SizedBox(height: context.rs(12)),

                          // ---- รายการนัดของวันนั้น ----
                          if (_dayBookings.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: context.rs(30)),
                              child: Center(
                                child: Text('ไม่มีนัดหมายในวันนี้',
                                    style: TextStyle(fontFamily: 'Inter',
                                        fontSize: context.rs(13), color: AppColors.textGray)),
                              ),
                            )
                          else
                            ..._dayBookings.map((b) => _AppointmentRow(
                                  booking: b,
                                  onTap: () => _showActions(b),
                                )),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Month navigation ----
  Widget _buildMonthNav(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: _prevMonth,
          child: Icon(Icons.chevron_left, size: context.rs(24), color: AppColors.black),
        ),
        Text(
          '${_thMonths[_visibleMonth.month]} ${_visibleMonth.year + 543}',
          style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(15),
              fontWeight: FontWeight.w600, color: AppColors.black),
        ),
        GestureDetector(
          onTap: _nextMonth,
          child: Icon(Icons.chevron_right, size: context.rs(24), color: AppColors.black),
        ),
      ],
    );
  }

  // ---- Weekday header ----
  Widget _buildWeekdayHeader(BuildContext context) {
    return Row(
      children: _thDays
          .map((d) => Expanded(
                child: Center(
                  child: Text(d,
                      style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(11),
                          fontWeight: FontWeight.w500, color: AppColors.textGray)),
                ),
              ))
          .toList(),
    );
  }

  // ---- Calendar grid ----
  Widget _buildCalendarGrid(BuildContext context) {
    final firstDay = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final daysInMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
    // weekday: Mon=1..Sun=7 → column index (Sun first): Sun=0
    final leadingBlanks = firstDay.weekday % 7;
    final withBookings = _daysWithBookings;

    final cells = <Widget>[];
    for (int i = 0; i < leadingBlanks; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_visibleMonth.year, _visibleMonth.month, day);
      final isSelected = _sameDay(date, _selectedDay);
      final hasBooking = withBookings.contains(day);
      cells.add(_DayCell(
        day: day,
        selected: isSelected,
        hasBooking: hasBooking,
        onTap: () => setState(() => _selectedDay = date),
      ));
    }
    // เติมช่องท้ายให้ครบแถว
    while (cells.length % 7 != 0) {
      cells.add(const SizedBox.shrink());
    }

    final rows = <Widget>[];
    for (int i = 0; i < cells.length; i += 7) {
      rows.add(Row(
        children: cells
            .sublist(i, i + 7)
            .map((c) => Expanded(child: AspectRatio(aspectRatio: 1, child: c)))
            .toList(),
      ));
    }
    return Column(children: rows);
  }

  // ---- Action bottom sheet ----
  void _showActions(AdminBooking b) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.rs(16))),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
            context.rs(24), context.rs(16), context.rs(24), context.rs(28)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: context.rs(36), height: context.rs(4),
                margin: EdgeInsets.only(bottom: context.rs(16)),
                decoration: BoxDecoration(
                    color: AppColors.inputBorder,
                    borderRadius: BorderRadius.circular(99)),
              ),
            ),
            Text(b.patientName,
                style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(15),
                    fontWeight: FontWeight.w700, color: AppColors.black)),
            SizedBox(height: context.rs(2)),
            Text('${b.serviceName} • ${b.appointmentTime} น.',
                style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(12),
                    color: AppColors.textGray)),
            SizedBox(height: context.rs(16)),
            _SheetAction(
              label: 'ยืนยันคิว',
              color: AppColors.greendentbook,
              icon: Icons.check_circle_outline,
              onTap: () => _doAction(b, AdminBookingService.instance.callQueue(b.id)),
            ),
            _SheetAction(
              label: 'เสร็จสิ้นการรักษา',
              color: AppColors.purple,
              icon: Icons.task_alt,
              onTap: () => _doAction(b, AdminBookingService.instance.completeQueue(b.id)),
            ),
            _SheetAction(
              label: 'ยกเลิกนัด',
              color: AppColors.reddentbook,
              icon: Icons.cancel_outlined,
              onTap: () => _doAction(b, AdminBookingService.instance.cancelQueue(b.id)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _doAction(AdminBooking b, Future<bool> action) async {
    Navigator.pop(context);
    try {
      await action;
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
      }
    }
  }
}

// ============================================================
// _PillTab — แท็บทรงแคปซูลด้านบน
// ============================================================
class _PillTab extends StatelessWidget {
  const _PillTab({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: context.rs(14), vertical: context.rs(8)),
        decoration: BoxDecoration(
          color: selected ? AppColors.orange : AppColors.homeBackground,
          borderRadius: BorderRadius.circular(context.rs(20)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(11),
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppColors.white : AppColors.textGray,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _DayCell — ช่องวันในปฏิทิน
// ============================================================
class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.selected,
    required this.hasBooking,
    required this.onTap,
  });
  final int day;
  final bool selected;
  final bool hasBooking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: context.rs(30),
            height: context.rs(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? AppColors.inputBorder : Colors.transparent,
            ),
            alignment: Alignment.center,
            child: Text(
              '$day',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(13),
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: AppColors.black,
              ),
            ),
          ),
          SizedBox(height: context.rs(2)),
          Container(
            width: context.rs(5),
            height: context.rs(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: hasBooking ? AppColors.purple : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _AppointmentRow — แถวเวลา + ชื่อ + สถานะ
// ============================================================
class _AppointmentRow extends StatelessWidget {
  const _AppointmentRow({required this.booking, required this.onTap});
  final AdminBooking booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final badge = _badgeFor(booking.status);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.rs(10)),
        child: Row(
          children: [
            // เวลา
            SizedBox(
              width: context.rs(46),
              child: Text(
                booking.appointmentTime,
                style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(13),
                    fontWeight: FontWeight.w500, color: AppColors.textGray),
              ),
            ),
            SizedBox(width: context.rs(8)),
            // ชื่อ
            Expanded(
              child: Text(
                booking.patientName,
                style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(13),
                    fontWeight: FontWeight.w500, color: AppColors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // สถานะ
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: context.rs(12), vertical: context.rs(5)),
              decoration: BoxDecoration(
                color: badge.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(context.rs(20)),
              ),
              child: Text(
                badge.label,
                style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(11),
                    fontWeight: FontWeight.w500, color: badge.color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _Badge _badgeFor(AdminQueueStatus s) {
    switch (s) {
      case AdminQueueStatus.confirmed:
      case AdminQueueStatus.inProgress:
        return _Badge('ยืนยันแล้ว', AppColors.greendentbook);
      case AdminQueueStatus.completed:
        return _Badge('เสร็จแล้ว', AppColors.purple);
      case AdminQueueStatus.cancelled:
        return _Badge('ยกเลิก', AppColors.reddentbook);
      case AdminQueueStatus.waiting:
        return _Badge('รอยืนยัน', AppColors.orange);
    }
  }
}

class _Badge {
  const _Badge(this.label, this.color);
  final String label;
  final Color color;
}

// ============================================================
// _SheetAction — ปุ่มใน bottom sheet
// ============================================================
class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.rs(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.rs(12)),
        child: Row(
          children: [
            Icon(icon, size: context.rs(20), color: color),
            SizedBox(width: context.rs(12)),
            Text(label,
                style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(14),
                    fontWeight: FontWeight.w500, color: AppColors.black)),
          ],
        ),
      ),
    );
  }
}
