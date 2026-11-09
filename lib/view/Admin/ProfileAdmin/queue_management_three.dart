import 'package:flutter/material.dart';

import '../../../services/admin/admin_booking_service.dart';
import '../../../services/admin/admin_models.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

/// หน้า “ยกเลิก/เลื่อนนัด” ตามดีไซน์ที่แนบ
///
/// แสดงคิวที่รอยืนยันและยืนยันแล้ว จัดกลุ่มตามวันนัด และบันทึกการยกเลิกหรือ
/// เลื่อนวัน/เวลาไปยัง Supabase จริงผ่าน [AdminBookingService]
class QueueManagementThree extends StatefulWidget {
  const QueueManagementThree({
    super.key,
    this.onBack,
    this.onOverview,
    this.onWaiting,
  });

  final VoidCallback? onBack;
  final VoidCallback? onOverview;
  final VoidCallback? onWaiting;

  @override
  State<QueueManagementThree> createState() => _QueueManagementThreeState();
}

class _QueueManagementThreeState extends State<QueueManagementThree> {
  bool _loading = true;
  String? _busyBookingId;
  List<AdminBooking> _bookings = const [];

  static const List<String> _months = [
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

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    if (mounted) setState(() => _loading = true);
    try {
      final bookings = await AdminBookingService.instance.getAllBookings();
      bookings.sort((a, b) {
        final dateResult = a.appointmentDate.compareTo(b.appointmentDate);
        if (dateResult != 0) return dateResult;
        return a.appointmentTime.compareTo(b.appointmentTime);
      });

      if (!mounted) return;
      setState(() {
        _bookings = bookings
            .where((booking) =>
                booking.status == AdminQueueStatus.waiting ||
                booking.status == AdminQueueStatus.confirmed)
            .toList();
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('โหลดข้อมูลคิวไม่สำเร็จ: $error')),
      );
    }
  }

  Map<DateTime, List<AdminBooking>> get _groupedBookings {
    final grouped = <DateTime, List<AdminBooking>>{};
    for (final booking in _bookings) {
      final date = DateTime(
        booking.appointmentDate.year,
        booking.appointmentDate.month,
        booking.appointmentDate.day,
      );
      grouped.putIfAbsent(date, () => <AdminBooking>[]).add(booking);
    }
    return grouped;
  }

  String _formatDate(DateTime date) =>
      '${date.day} ${_months[date.month]} ${date.year + 543}';

  Future<void> _cancelBooking(AdminBooking booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'ยืนยันการยกเลิกนัด',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
        ),
        content: Text(
          'ต้องการยกเลิกนัดของ ${booking.patientName} ใช่หรือไม่?',
          style: const TextStyle(fontFamily: 'Inter'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('ย้อนกลับ'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'ยกเลิกนัด',
              style: TextStyle(color: AppColors.reddentbook),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    await _performAction(
      booking,
      () => AdminBookingService.instance.cancelQueue(booking.id),
      successMessage: 'ยกเลิกนัดเรียบร้อยแล้ว',
    );
  }

  Future<void> _rescheduleBooking(AdminBooking booking) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: booking.appointmentDate.isBefore(DateTime.now())
          ? DateTime.now()
          : booking.appointmentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      locale: const Locale('th', 'TH'),
    );
    if (selectedDate == null || !mounted) return;

    final currentTimeParts = booking.appointmentTime.split(':');
    final initialHour = int.tryParse(currentTimeParts.first) ?? 9;
    final initialMinute = currentTimeParts.length > 1
        ? int.tryParse(currentTimeParts[1].substring(0, 2)) ?? 0
        : 0;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
      helpText: 'เลือกเวลานัดใหม่',
    );
    if (selectedTime == null || !mounted) return;

    final time =
        '${selectedTime.hour.toString().padLeft(2, '0')}:'
        '${selectedTime.minute.toString().padLeft(2, '0')}:00';

    await _performAction(
      booking,
      () => AdminBookingService.instance.rescheduleBooking(
        bookingId: booking.id,
        appointmentDate: selectedDate,
        appointmentTime: time,
      ),
      successMessage: 'เลื่อนนัดเรียบร้อยแล้ว',
    );
  }

  Future<void> _performAction(
    AdminBooking booking,
    Future<bool> Function() action, {
    required String successMessage,
  }) async {
    setState(() => _busyBookingId = booking.id);
    try {
      await action();
      await _loadBookings();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ดำเนินการไม่สำเร็จ: $error')),
      );
    } finally {
      if (mounted) setState(() => _busyBookingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedBookings;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _Header(onBack: widget.onBack),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rs(20)),
              child: Row(
                children: [
                  Expanded(
                    child: _TopTab(
                      label: 'ภาพรวม',
                      onTap: widget.onOverview,
                    ),
                  ),
                  SizedBox(width: context.rs(8)),
                  Expanded(
                    child: _TopTab(
                      label: 'คิวที่รอยืนยัน',
                      onTap: widget.onWaiting,
                    ),
                  ),
                  SizedBox(width: context.rs(8)),
                  const Expanded(
                    child: _TopTab(
                      label: 'ยกเลิก/เลื่อนนัด',
                      selected: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.rs(14)),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _loadBookings,
                      child: grouped.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(height: context.rs(180)),
                                Center(
                                  child: Text(
                                    'ไม่มีนัดหมายที่ยกเลิกหรือเลื่อนได้',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: context.rs(13),
                                      color: AppColors.textGray,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.fromLTRB(
                                context.rs(20),
                                0,
                                context.rs(20),
                                context.rs(28),
                              ),
                              itemCount: grouped.length,
                              itemBuilder: (context, index) {
                                final entry = grouped.entries.elementAt(index);
                                return _DateSection(
                                  dateLabel: _formatDate(entry.key),
                                  bookings: entry.value,
                                  busyBookingId: _busyBookingId,
                                  onCancel: _cancelBooking,
                                  onReschedule: _rescheduleBooking,
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({this.onBack});
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.rs(8),
        context.rs(6),
        context.rs(8),
        context.rs(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBack ?? () => Navigator.maybePop(context),
              icon: Icon(
                Icons.chevron_left,
                size: context.rs(28),
                color: AppColors.black,
              ),
            ),
          ),
          Text(
            'จัดการคิวและตารางคิว',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(15),
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopTab extends StatelessWidget {
  const _TopTab({
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: context.rs(34),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.orange : AppColors.white,
          borderRadius: BorderRadius.circular(context.rs(18)),
          border: selected
              ? null
              : Border.all(color: AppColors.inputBorder, width: 1),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(10),
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}

class _DateSection extends StatelessWidget {
  const _DateSection({
    required this.dateLabel,
    required this.bookings,
    required this.busyBookingId,
    required this.onCancel,
    required this.onReschedule,
  });

  final String dateLabel;
  final List<AdminBooking> bookings;
  final String? busyBookingId;
  final ValueChanged<AdminBooking> onCancel;
  final ValueChanged<AdminBooking> onReschedule;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.rs(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateLabel,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(13),
              fontWeight: FontWeight.w500,
              color: AppColors.textGray,
            ),
          ),
          SizedBox(height: context.rs(8)),
          ...bookings.map(
            (booking) => Padding(
              padding: EdgeInsets.only(bottom: context.rs(10)),
              child: _ActionQueueCard(
                booking: booking,
                loading: busyBookingId == booking.id,
                onCancel: () => onCancel(booking),
                onReschedule: () => onReschedule(booking),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionQueueCard extends StatelessWidget {
  const _ActionQueueCard({
    required this.booking,
    required this.loading,
    required this.onCancel,
    required this.onReschedule,
  });

  final AdminBooking booking;
  final bool loading;
  final VoidCallback onCancel;
  final VoidCallback onReschedule;

  bool get _isConfirmed => booking.status == AdminQueueStatus.confirmed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rs(14)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.rs(15)),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  booking.patientName,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(14),
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ),
              SizedBox(width: context.rs(8)),
              _StatusBadge(confirmed: _isConfirmed),
            ],
          ),
          SizedBox(height: context.rs(4)),
          Text(
            '${booking.appointmentTime} • ${booking.doctorName.isEmpty ? "ไม่ระบุทันตแพทย์" : booking.doctorName} • ${booking.serviceName}',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(12),
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: context.rs(14)),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: context.rs(40),
                  child: ElevatedButton.icon(
                    onPressed: loading ? null : onCancel,
                    icon: loading
                        ? SizedBox(
                            width: context.rs(16),
                            height: context.rs(16),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.white,
                              ),
                            ),
                          )
                        : Icon(Icons.event_busy_outlined, size: context.rs(18)),
                    label: Text(
                      loading ? '' : 'ยกเลิกนัด',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(12),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFE51C2A),
                      foregroundColor: AppColors.white,
                      disabledBackgroundColor:
                          const Color(0xFFE51C2A).withValues(alpha: 0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.rs(8)),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: context.rs(18)),
              Expanded(
                child: SizedBox(
                  height: context.rs(40),
                  child: OutlinedButton.icon(
                    onPressed: loading ? null : onReschedule,
                    icon: Icon(
                      Icons.event_repeat_outlined,
                      size: context.rs(18),
                      color: AppColors.black,
                    ),
                    label: Text(
                      'เลื่อนนัด',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(12),
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.black,
                      side: const BorderSide(color: AppColors.inputBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.rs(8)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.confirmed});
  final bool confirmed;

  @override
  Widget build(BuildContext context) {
    final color = confirmed ? const Color(0xFF62B986) : AppColors.orange;
    final background = confirmed
        ? const Color(0xFFD4F0DC)
        : const Color(0xFFFFDCC7);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(13),
        vertical: context.rs(5),
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(context.rs(18)),
      ),
      child: Text(
        confirmed ? 'ยืนยันแล้ว' : 'รอยืนยัน',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: context.rs(10),
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
