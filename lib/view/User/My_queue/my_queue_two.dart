import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../components/shared_widgets.dart';
import '../../../services/service_locator.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';
import 'my_queue_one.dart';
import 'my_queue_three.dart';

// ============================================================
// MyQueueTwo - หน้ารายละเอียดคิว (Queue Detail)
// ============================================================
class MyQueueTwo extends StatefulWidget {
  const MyQueueTwo({
    super.key,
    required this.queue,
    this.onBack,
  });

  final QueueItem queue;
  final VoidCallback? onBack;

  @override
  State<MyQueueTwo> createState() => _MyQueueTwoState();
}

class _MyQueueTwoState extends State<MyQueueTwo> {
  bool _isCancelling = false;

  @override
  Widget build(BuildContext context) {
    final queue = widget.queue;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFC5DEE8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- AppBar ----
              AppBarBack(
                title: 'รายละเอียดคิว',
                onBack: onBack,
              ),

              // ---- Scrollable content ----
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.rs(16),
                    context.rs(16),
                    context.rs(16),
                    context.rs(24),
                  ),
                  child: Column(
                    children: [
                      // ---- Status Banner ----
                      _StatusBanner(status: queue.status),

                      SizedBox(height: context.rs(16)),

                      // ---- ข้อมูลการจอง ----
                      _DetailSection(
                        title: 'ข้อมูลการจอง',
                        children: [
                          _DetailRow(
                            icon: Icons.medical_services_outlined,
                            iconColor: AppColors.purple,
                            label: 'บริการ',
                            value: queue.serviceName,
                          ),
                          _divider(context),
                          _DetailRow(
                            svgAsset: 'assets/images/Book_an_appointment/healthicons_doctor-male.svg',
                            iconColor: AppColors.purple,
                            label: 'ทันตแพทย์',
                            value: queue.doctorName,
                          ),
                          _divider(context),
                          _DetailRow(
                            svgAsset: 'assets/images/Book_an_appointment/uim_calender.svg',
                            iconColor: AppColors.purple,
                            label: 'วันที่นัดหมาย',
                            value: queue.appointmentDate,
                          ),
                          _divider(context),
                          _DetailRow(
                            svgAsset: 'assets/images/Book_an_appointment/iconamoon_clock-fill.svg',
                            iconColor: AppColors.purple,
                            label: 'เวลานัดหมาย',
                            value: queue.appointmentTime,
                          ),
                          _divider(context),
                          _DetailRow(
                            icon: Icons.location_on_outlined,
                            iconColor: AppColors.purple,
                            label: 'คลินิก',
                            value: queue.clinicName,
                          ),
                        ],
                      ),

                      SizedBox(height: context.rs(12)),

                      // ---- หมายเลขการจอง ----
                      _BookingIdCard(bookingId: queue.bookingId),

                      SizedBox(height: context.rs(12)),

                      // ---- ข้อมูลทั่วไป ----
                      _DetailSection(
                        title: 'ข้อมูลทั่วไป',
                        children: [
                          _InfoItem(
                            icon: Icons.access_time_outlined,
                            iconColor: AppColors.orange,
                            text: 'กรุณามาถึงก่อนเวลานัด อย่างน้อย 15 นาที',
                          ),
                          _divider(context),
                          _InfoItem(
                            icon: Icons.cancel_outlined,
                            iconColor: AppColors.reddentbook,
                            text:
                                'หากยกเลิกภายใน 48 ชั่วโมงก่อนวันนัด จะถูกหักมัดจำ 30%\nหากยกเลิกหลังจากนั้น จะถูกหักมัดจำ 100%',
                          ),
                          _divider(context),
                          _InfoItem(
                            icon: Icons.info_outline,
                            iconColor: AppColors.purple,
                            text: 'กรุณาแจ้งโรคประจำตัวหรือยาที่รับประทานแก่ทันตแพทย์ก่อนรับบริการ',
                          ),
                        ],
                      ),

                      SizedBox(height: context.rs(12)),

                      // ---- ปุ่มยกเลิก ----
                      if (queue.status == QueueStatus.waitingPayment ||
                          queue.status == QueueStatus.confirmed ||
                          queue.status == QueueStatus.inProgress)
                        _CancelButton(
                          isCancelling: _isCancelling,
                          onCancel: () => _showCancelDialog(context),
                        ),
                    ],
                  ),
                ),
              ),

              // ---- Bottom button: ชำระมัดจำ (ถ้ารอชำระ) ----
              if (queue.status == QueueStatus.waitingPayment)
                _BottomPayBar(
                  amount: queue.depositAmount ?? 0,
                  onPay: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MyQueueThree(queue: queue),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: context.rs(2)),
        child: const Divider(
          color: AppColors.inputBorder,
          height: 1,
          thickness: 0.5,
        ),
      );

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('ยืนยันการยกเลิก',
            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700)),
        content: const Text(
            'คุณต้องการยกเลิกการนัดหมายนี้ใช่หรือไม่?\nการยกเลิกอาจมีผลต่อค่ามัดจำ',
            style: TextStyle(fontFamily: 'Inter')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ย้อนกลับ',
                style: TextStyle(fontFamily: 'Inter', color: AppColors.textGray)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // ปิด dialog
              setState(() => _isCancelling = true);
              try {
                await ServiceLocator.booking.cancelBooking(widget.queue.bookingId);
                if (!mounted) return;
                Navigator.pop(context); // กลับไปหน้า list
              } on AuthException catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.message)));
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
                }
              } finally {
                if (mounted) setState(() => _isCancelling = false);
              }
            },
            child: const Text('ยืนยันยกเลิก',
                style: TextStyle(fontFamily: 'Inter',
                    color: AppColors.reddentbook, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _StatusBanner — banner สถานะด้านบน
// ============================================================
class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.status});
  final QueueStatus status;

  @override
  Widget build(BuildContext context) {
    final Color bg = status.badgeColor;
    final String icon = _iconForStatus(status);
    final String title = _titleForStatus(status);
    final String subtitle = _subtitleForStatus(status);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: context.rs(20),
        horizontal: context.rs(16),
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Row(
        children: [
          // Icon circle
          Container(
            width: context.rs(48),
            height: context.rs(48),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                icon,
                style: TextStyle(fontSize: context.rs(22)),
              ),
            ),
          ),
          SizedBox(width: context.rs(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(15),
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  SizedBox(height: context.rs(3)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(12),
                      fontWeight: FontWeight.w400,
                      color: AppColors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _iconForStatus(QueueStatus s) {
    switch (s) {
      case QueueStatus.waitingPayment:
        return '💳';
      case QueueStatus.confirmed:
        return '✅';
      case QueueStatus.inProgress:
        return '🦷';
      case QueueStatus.completed:
        return '⭐';
      case QueueStatus.cancelled:
        return '❌';
    }
  }

  String _titleForStatus(QueueStatus s) {
    switch (s) {
      case QueueStatus.waitingPayment:
        return 'รอการชำระมัดจำ';
      case QueueStatus.confirmed:
        return 'ยืนยันการจองแล้ว';
      case QueueStatus.inProgress:
        return 'กำลังรับบริการ';
      case QueueStatus.completed:
        return 'เสร็จสิ้นการรักษา';
      case QueueStatus.cancelled:
        return 'การจองถูกยกเลิก';
    }
  }

  String _subtitleForStatus(QueueStatus s) {
    switch (s) {
      case QueueStatus.waitingPayment:
        return 'กรุณาชำระมัดจำเพื่อยืนยันการจอง';
      case QueueStatus.confirmed:
        return 'กรุณามาถึงก่อนเวลานัด 15 นาที';
      case QueueStatus.inProgress:
        return 'คุณกำลังอยู่ระหว่างการรับบริการ';
      case QueueStatus.completed:
        return 'ขอบคุณที่ใช้บริการ DentBook';
      case QueueStatus.cancelled:
        return '';
    }
  }
}

// ============================================================
// _DetailSection — กล่อง section พร้อม title
// ============================================================
class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.rs(16),
              context.rs(14),
              context.rs(16),
              context.rs(8),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(13),
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.rs(16),
              0,
              context.rs(16),
              context.rs(14),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _DetailRow — แถวข้อมูล (icon + label + value)
// ============================================================
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    this.icon,
    this.svgAsset,
    required this.iconColor,
    required this.label,
    required this.value,
  }) : assert(icon != null || svgAsset != null);

  final IconData? icon;
  final String? svgAsset;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.rs(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (svgAsset != null)
            SvgPicture.asset(
              svgAsset!,
              width: context.rs(18),
              height: context.rs(18),
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            )
          else
            Icon(icon, size: context.rs(18), color: iconColor),
          SizedBox(width: context.rs(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(11),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGray,
                  ),
                ),
                SizedBox(height: context.rs(2)),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(13),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _InfoItem — bullet item ใน section ข้อมูลทั่วไป
// ============================================================
class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  final IconData icon;
  final Color iconColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.rs(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: context.rs(15), color: iconColor),
          SizedBox(width: context.rs(10)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(12),
                fontWeight: FontWeight.w400,
                color: AppColors.black,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _BookingIdCard — กล่องหมายเลขการจอง
// ============================================================
class _BookingIdCard extends StatelessWidget {
  const _BookingIdCard({required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: context.rs(14),
        horizontal: context.rs(16),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEFF),
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'หมายเลขการจอง',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(11),
                  fontWeight: FontWeight.w400,
                  color: AppColors.textGray,
                ),
              ),
              SizedBox(width: context.rs(8)),
              SvgPicture.asset(
                'assets/images/Book_an_appointment/copy.svg',
                width: context.rs(10),
                height: context.rs(10),
                colorFilter: const ColorFilter.mode(
                  AppColors.purple,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          SizedBox(height: context.rs(6)),
          Text(
            bookingId,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(17),
              fontWeight: FontWeight.w700,
              color: AppColors.purple,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _CancelButton — ปุ่มยกเลิกการนัด
// ============================================================
class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.onCancel, this.isCancelling = false});
  final VoidCallback onCancel;
  final bool isCancelling;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: context.rs(42),
      child: OutlinedButton(
        onPressed: isCancelling ? null : onCancel,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.reddentbook, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.rs(30))),
        ),
        child: isCancelling
            ? const SizedBox(width: 18, height: 18,
                child: CircularProgressIndicator(strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.reddentbook)))
            : Text('ยกเลิกการนัดหมาย',
                style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(14),
                    fontWeight: FontWeight.w500, color: AppColors.reddentbook)),
      ),
    );
  }
}

// ============================================================
// _BottomPayBar — แถบด้านล่างสำหรับชำระมัดจำ
// ============================================================
class _BottomPayBar extends StatelessWidget {
  const _BottomPayBar({
    required this.amount,
    required this.onPay,
  });

  final int amount;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.fromLTRB(
        context.rs(24),
        context.rs(8),
        context.rs(24),
        context.rs(32),
      ),
      child: Row(
        children: [
          // ยอดมัดจำ
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ยอดมัดจำ',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(11),
                  color: AppColors.textGray,
                ),
              ),
              Text(
                '฿$amount',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(20),
                  fontWeight: FontWeight.w800,
                  color: AppColors.purple,
                ),
              ),
            ],
          ),
          SizedBox(width: context.rs(16)),
          // ปุ่มชำระ
          Expanded(
            child: SizedBox(
              height: context.rs(42),
              child: ElevatedButton(
                onPressed: onPay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.rs(30)),
                  ),
                ),
                child: Text(
                  'ชำระมัดจำเลย',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
