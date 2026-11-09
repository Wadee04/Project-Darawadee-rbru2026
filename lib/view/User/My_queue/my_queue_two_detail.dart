import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../components/shared_widgets.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';
import 'my_queue_one.dart';

// ============================================================
// MyQueueTwo - หน้ารายละเอียดคิว (จากหน้าคิวของฉัน)
// Flow: MyQueueOne (รายการ) → MyQueueTwo (รายละเอียด) → MyQueueThree (ชำระมัดจำ)
// ============================================================
class MyQueueTwo extends StatelessWidget {
  const MyQueueTwo({super.key, required this.queue, this.onBack});

  final QueueItem queue;
  final VoidCallback? onBack;

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
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppBarBack(title: 'รายละเอียดคิว', onBack: onBack),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  context.rs(24),
                  context.rs(12),
                  context.rs(24),
                  context.rs(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ===== รายละเอียดคิว (กรอบเดียว) =====
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.rs(16),
                        vertical: context.rs(25),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(context.rs(20)),
                        border: Border.all(color: AppColors.purple, width: 1.2),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _StatusBadge(status: queue.status),
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
                                      text: queue.bookingId,
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
                          SizedBox(height: context.rs(30)),
                          QrImageView(
                            data: queue.bookingId,
                            version: QrVersions.auto,
                            size: context.rs(170),
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
                          SizedBox(height: context.rs(8)),
                          Text(
                            'สแกน QR เพื่อแสดงคิว',
                            style: TextStyle(
                              fontFamily: 'Noto Sans Thai',
                              fontSize: context.rs(11),
                              color: AppColors.textGray,
                            ),
                          ),
                          SizedBox(height: context.rs(30)),
                          _DetailRow(
                            icon: _icon(context, 'make-an-appointment.svg'),
                            title: queue.appointmentDate,
                          ),
                          SizedBox(height: context.rs(10)),
                          _DetailRow(
                            icon: _icon(context, 'schedule.svg'),
                            title: queue.appointmentTime,
                          ),
                          SizedBox(height: context.rs(10)),
                          _DetailRow(
                            icon: _icon(context, 'doctor.svg'),
                            title: queue.doctorName,
                            subtitle: queue.doctorRole,
                          ),
                          SizedBox(height: context.rs(10)),
                          _DetailRow(
                            icon: _icon(context, 'toothten.svg'),
                            title: queue.serviceName,
                            subtitle: queue.serviceSubtitle,
                          ),
                          SizedBox(height: context.rs(10)),
                          _DetailRow(
                            icon: _icon(
                              context,
                              'heroicons_map-pin-16-solid.svg',
                            ),
                            title: queue.clinicName,
                          ),
                        ],
                      ),
                    ),
                  ],
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
// _DetailRow - แถวข้อมูล (ไอคอน + หัวข้อ + คำอธิบายรอง)
// ============================================================
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.title,
    this.subtitle,
  });

  final Widget icon;
  final String title;
  final String? subtitle;

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
                  fontSize: context.rs(12),
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                  color: AppColors.purple,
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
                    color: AppColors.textGray,
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
        ('เสร็จสิ้น', const Color(0xFFBFEBC9), const Color(0xFF2E7D32)),
      QueueStatus.cancelled =>
        ('ยกเลิก', const Color(0xFFFFD9D9), AppColors.reddentbook),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(12),
        vertical: context.rs(5),
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(context.rs(20)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Noto Sans Thai',
          fontSize: context.rs(11),
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
