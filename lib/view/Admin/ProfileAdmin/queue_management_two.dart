import 'package:flutter/material.dart';

import '../../../services/admin/admin_booking_service.dart';
import '../../../services/admin/admin_models.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

/// หน้าแสดงคิวที่รอการยืนยันของคลินิก
///
/// โหลดข้อมูลจริงจาก Supabase ผ่าน [AdminBookingService] และจัดกลุ่มตามวันนัด
/// ปุ่มยืนยันเปลี่ยนสถานะเป็น confirmed ส่วนปุ่มปฏิเสธเปลี่ยนเป็น cancelled
class QueueManagementTwo extends StatefulWidget {
  const QueueManagementTwo({
    super.key,
    this.onBack,
    this.onOverview,
    this.onCancelled,
  });

  final VoidCallback? onBack;
  final VoidCallback? onOverview;
  final VoidCallback? onCancelled;

  @override
  State<QueueManagementTwo> createState() => _QueueManagementTwoState();
}

class _QueueManagementTwoState extends State<QueueManagementTwo> {
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
        // หน้านี้แสดงทั้งคิวที่รอยืนยันและคิวที่เพิ่งยืนยันแล้วตามดีไซน์
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

  Future<void> _confirm(AdminBooking booking) async {
    await _performAction(
      booking,
      () => AdminBookingService.instance.updateBookingStatus(
        booking.id,
        AdminQueueStatus.confirmed,
      ),
      successMessage: 'ยืนยันคิวเรียบร้อยแล้ว',
    );
  }

  Future<void> _reject(AdminBooking booking) async {
    final shouldReject = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'ยืนยันการปฏิเสธคิว',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
        ),
        content: Text(
          'ต้องการปฏิเสธคิวของ ${booking.patientName} ใช่หรือไม่?',
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
              'ปฏิเสธ',
              style: TextStyle(color: AppColors.reddentbook),
            ),
          ),
        ],
      ),
    );

    if (shouldReject != true || !mounted) return;
    await _performAction(
      booking,
      () => AdminBookingService.instance.cancelQueue(booking.id),
      successMessage: 'ปฏิเสธคิวเรียบร้อยแล้ว',
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

  String _formatDate(DateTime date) =>
      '${date.day} ${_months[date.month]} ${date.year + 543}';

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
                  const Expanded(
                    child: _TopTab(
                      label: 'คิวที่รอยืนยัน',
                      selected: true,
                    ),
                  ),
                  SizedBox(width: context.rs(8)),
                  Expanded(
                    child: _TopTab(
                      label: 'ยกเลิก/เลื่อนนัด',
                      onTap: widget.onCancelled,
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
                                    'ไม่มีคิวที่รอยืนยัน',
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
                                  onConfirm: _confirm,
                                  onReject: _reject,
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
    required this.onConfirm,
    required this.onReject,
  });

  final String dateLabel;
  final List<AdminBooking> bookings;
  final String? busyBookingId;
  final ValueChanged<AdminBooking> onConfirm;
  final ValueChanged<AdminBooking> onReject;

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
              child: _PendingQueueCard(
                booking: booking,
                loading: busyBookingId == booking.id,
                onConfirm: () => onConfirm(booking),
                onReject: () => onReject(booking),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingQueueCard extends StatelessWidget {
  const _PendingQueueCard({
    required this.booking,
    required this.loading,
    required this.onConfirm,
    required this.onReject,
  });

  final AdminBooking booking;
  final bool loading;
  final VoidCallback onConfirm;
  final VoidCallback onReject;

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
          if (!_isConfirmed) ...[
            SizedBox(height: context.rs(14)),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: context.rs(40),
                    child: ElevatedButton.icon(
                      onPressed: loading ? null : onConfirm,
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
                          : Icon(Icons.check, size: context.rs(20)),
                      label: Text(
                        loading ? '' : 'ยืนยัน',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(13),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFF2FC95A),
                        foregroundColor: AppColors.white,
                        disabledBackgroundColor:
                            const Color(0xFF2FC95A).withValues(alpha: 0.6),
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
                    child: OutlinedButton(
                      onPressed: loading ? null : onReject,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.black,
                        side: const BorderSide(color: AppColors.inputBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.rs(8)),
                        ),
                      ),
                      child: Text(
                        'ปฏิเสธ',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(13),
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
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
