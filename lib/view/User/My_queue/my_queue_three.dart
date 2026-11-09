import 'package:flutter/material.dart';

import '../../../components/shared_widgets.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// MyQueueThree - คิวที่ยกเลิก/เลื่อนนัด (ออกแบบเหมือนตัวอย่าง)
// ============================================================
class MyQueueThree extends StatefulWidget {
  const MyQueueThree({super.key, this.onBack, this.items});

  final VoidCallback? onBack;
  final List<QueueItemCancel>? items;

  @override
  State<MyQueueThree> createState() => _MyQueueThreeState();
}

class _MyQueueThreeState extends State<MyQueueThree> {
  bool _newestFirst = true;
  String? _rangeLabel;

  List<QueueItemCancel> get _displayItems {
    final list = List<QueueItemCancel>.from(widget.items ?? _defaultItems);
    if (!_newestFirst) return list.reversed.toList();
    return list;
  }

  final List<QueueItemCancel> _defaultItems = [
    QueueItemCancel(
      date: '7 ส.ค. 2569',
      time: '10:30 น.',
      title: 'ลอกฟัน',
      doctor: 'ทพญ.อรุณี ปราณอัคนี',
      clinic: 'Dentbook clinic',
      status: QueueStatusCancel.reschedule,
    ),
    QueueItemCancel(
      date: '7 ธ.ค. 2569',
      time: '13:30 น.',
      title: 'ขูดหินปูน',
      doctor: 'ทพญ.อรุณี ปราณอัคนี',
      clinic: 'Dentbook clinic',
      status: QueueStatusCancel.cancel,
      appointmentAt: DateTime(2026, 12, 7, 13, 30),
      cancelledAt: DateTime(2026, 12, 4, 9, 0), // ล่วงหน้า > 48 ชม. → +200
    ),
    QueueItemCancel(
      date: '4 พ.ค. 2569',
      time: '09:30 น.',
      title: 'ตรวจสุขภาพช่องปาก',
      doctor: 'ทพญ.อรุณี ปราณอัคนี',
      clinic: 'Dentbook clinic',
      status: QueueStatusCancel.cancel,
      appointmentAt: DateTime(2026, 5, 4, 9, 30),
      cancelledAt: DateTime(2026, 5, 3, 20, 0), // < 24 ชม. → 0
    ),
    QueueItemCancel(
      date: '14 พ.ค. 2569',
      time: '14:30 น.',
      title: 'จัดฟัน(ปรับเครื่องมือ)',
      doctor: 'ทพญ.อรุณี ปราณอัคนี',
      clinic: 'Dentbook clinic',
      status: QueueStatusCancel.reschedule,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: context.rs(12),
                bottom: context.rs(16),
              ),
              child: Text(
                'คิวของฉัน',
                style: TextStyle(
                  fontFamily: 'Noto Sans Thai',
                  fontSize: context.rs(16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rs(16)),
              child: Row(
                children: [
                  _TabChip(
                    flex: 6,
                    label: 'คิวที่กำลังจะมาถึง',
                    selected: false,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: context.rs(8)),
                  _TabChip(
                    flex: 5,
                    label: 'คิวที่ผ่านมา',
                    selected: false,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: context.rs(8)),
                  _TabChip(
                    flex: 5,
                    label: 'ยกเลิก/เลื่อนนัด',
                    selected: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: context.rs(12)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rs(16)),
              child: Row(
                children: [
                  Expanded(
                    child: _FilterBox(
                      icon: Icons.calendar_today_outlined,
                      label: _rangeLabel ?? 'ช่วงเวลา',
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null && mounted) {
                          setState(() {
                            _rangeLabel =
                                '${picked.day}/${picked.month}/${picked.year + 543}';
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: context.rs(12)),
                  Expanded(
                    child: _FilterBox(
                      icon: Icons.swap_vert_rounded,
                      label: _newestFirst ? 'ล่าสุดก่อน' : 'เก่าก่อน',
                      onTap: () =>
                          setState(() => _newestFirst = !_newestFirst),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.rs(12)),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  context.rs(16),
                  context.rs(4),
                  context.rs(16),
                  context.rs(16),
                ),
                itemCount: _displayItems.length,
                separatorBuilder: (context, index) => SizedBox(height: context.rs(12)),
                itemBuilder: (_, i) => CancelQueueCard(item: _displayItems[i]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: AppBottomNav(
          currentIndex: 2,
          onTap: (i) {
            if (i != 2) {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}

enum QueueStatusCancel { reschedule, cancel }

/// ใครเป็นฝ่ายยกเลิก
enum CancelledBy { patient, clinic, noShow }

class QueueItemCancel {
  static const int deposit = 200;

  final String date;
  final String time;
  final String title;
  final String doctor;
  final String clinic;
  final QueueStatusCancel status;

  // ใช้คำนวณเงินคืน (เฉพาะสถานะยกเลิก)
  final DateTime? appointmentAt; // วันเวลานัด
  final DateTime? cancelledAt; // เวลาที่กดยกเลิก
  final CancelledBy cancelledBy;

  const QueueItemCancel({
    required this.date,
    required this.time,
    required this.title,
    required this.doctor,
    required this.clinic,
    required this.status,
    this.appointmentAt,
    this.cancelledAt,
    this.cancelledBy = CancelledBy.patient,
  });

  /// null = ไม่ต้องแสดง (สถานะเลื่อนนัด)
  int? get refundAmount {
    if (status != QueueStatusCancel.cancel) return null;

    switch (cancelledBy) {
      case CancelledBy.clinic:
        return deposit; // คลินิกยกเลิก คืนเต็ม
      case CancelledBy.noShow:
        return 0; // ไม่มาตามนัด
      case CancelledBy.patient:
        final appt = appointmentAt;
        final cancelled = cancelledAt;
        if (appt == null || cancelled == null) return 0;
        final minutes = appt.difference(cancelled).inMinutes;
        if (minutes >= 48 * 60) return deposit; // ≥ 48 ชม. คืน 100%
        if (minutes >= 24 * 60) return deposit ~/ 2; // 24-48 ชม. คืน 50%
        return 0; // < 24 ชม.
    }
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.flex = 1,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: context.rs(34),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.orange : AppColors.white,
            borderRadius: BorderRadius.circular(context.rs(20)),
            border: Border.all(
              color: selected ? AppColors.orange : AppColors.black,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Noto Sans Thai',
              fontSize: context.rs(11),
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.white : AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterBox extends StatelessWidget {
  const _FilterBox({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: context.rs(34),
        padding: EdgeInsets.symmetric(horizontal: context.rs(10)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.rs(8)),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          children: [
            Icon(icon, size: context.rs(16), color: AppColors.textGray),
            SizedBox(width: context.rs(6)),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Noto Sans Thai',
                  fontSize: context.rs(11),
                  color: AppColors.textGray,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: context.rs(18),
              color: AppColors.textGray,
            ),
          ],
        ),
      ),
    );
  }
}

class CancelQueueCard extends StatelessWidget {
  const CancelQueueCard({super.key, required this.item});

  final QueueItemCancel item;

  @override
  Widget build(BuildContext context) {
    final isCancel = item.status == QueueStatusCancel.cancel;
    final badgeBg = isCancel ? AppColors.cancelledBorder : AppColors.rescheduledBorder;
    final badgeText = isCancel ? AppColors.cancelledText : AppColors.purple;
    final badgeLabel = isCancel ? 'ยกเลิกนัด' : 'เลื่อนนัด';

    return Container(
      padding: EdgeInsets.fromLTRB(
        context.rs(14),
        context.rs(12),
        context.rs(14),
        context.rs(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.rs(16)),
        border: Border.all(color: const Color(0xFFE3E3E3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.date,
                      style: TextStyle(
                        fontFamily: 'Noto Sans Thai',
                        fontSize: context.rs(11),
                        color: AppColors.textGray,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: context.rs(11),
                      margin: EdgeInsets.symmetric(horizontal: context.rs(6)),
                      color: AppColors.inputBorder,
                    ),
                    Text(
                      item.time,
                      style: TextStyle(
                        fontFamily: 'Noto Sans Thai',
                        fontSize: context.rs(11),
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.rs(4)),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Noto Sans Thai',
                    fontSize: context.rs(14),
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: context.rs(4)),
                Text(
                  item.doctor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Noto Sans Thai',
                    fontSize: context.rs(12),
                    fontWeight: FontWeight.w500,
                    color: AppColors.purple,
                  ),
                ),
                SizedBox(height: context.rs(4)),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: context.rs(14),
                      color: AppColors.textGray,
                    ),
                    SizedBox(width: context.rs(3)),
                    Flexible(
                      child: Text(
                        item.clinic,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Noto Sans Thai',
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
          SizedBox(
            height: context.rs(68),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (item.refundAmount != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Text(
                      item.refundAmount! > 0 ? '+${item.refundAmount}' : '0',
                      style: TextStyle(
                        fontFamily: 'Noto Sans Thai',
                        fontSize: context.rs(10),
                        fontWeight: FontWeight.w700,
                        color: item.refundAmount! > 0
                            ? const Color(0xFF306E32)
                            : AppColors.red,
                      ),
                    ),
                  ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.rs(12),
                    vertical: context.rs(5),
                  ),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(context.rs(14)),
                  ),
                  child: Text(
                    badgeLabel,
                    style: TextStyle(
                      fontFamily: 'Noto Sans Thai',
                      fontSize: context.rs(12),
                      fontWeight: FontWeight.w500,
                      color: badgeText,
                    ),
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
