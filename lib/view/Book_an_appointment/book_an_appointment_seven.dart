import 'package:flutter/material.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

// ============================================================
// BookAnAppointmentSeven - หน้าเลือกเวลาจองคิว
// ============================================================

class BookAnAppointmentSeven extends StatefulWidget {
  const BookAnAppointmentSeven({
    super.key,
    this.onBack,
    this.onConfirm,
    this.onChangeDate,
    this.doctorName = 'ทพญ. อรุณี ป.',
    this.doctorSpecialty = 'กันตแพทย์ทั่วไป',
    this.doctorImageAsset,
    this.selectedDate,
  });

  final VoidCallback? onBack;
  final void Function(String time)? onConfirm;
  final VoidCallback? onChangeDate;
  final String doctorName;
  final String doctorSpecialty;
  final String? doctorImageAsset;
  final DateTime? selectedDate;

  @override
  State<BookAnAppointmentSeven> createState() => _BookAnAppointmentSevenState();
}

class _BookAnAppointmentSevenState extends State<BookAnAppointmentSeven> {
  String? _selectedTime;

  static const List<String> _timeSlots = [
    '09:00',
    '10:00',
    '11:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
  ];

  // แปลงวันที่เป็น "พุธ 12 สิงหาคม 2569" (พุทธศักราช)
  String _formatDate(DateTime date) {
    const List<String> weekdays = [
      'จันทร์', 'อังคาร', 'พุธ', 'พฤหัส', 'ศุกร์', 'เสาร์', 'อาทิตย์',
    ];
    const List<String> months = [
      'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน',
      'พฤษภาคม', 'มิถุนายน', 'กรกฎาคม', 'สิงหาคม',
      'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม',
    ];
    final String weekday = weekdays[date.weekday - 1];
    final String month = months[date.month - 1];
    final int buddhistYear = date.year + 543;
    return '$weekday ${date.day} $month $buddhistYear';
  }

  @override
  Widget build(BuildContext context) {
    final DateTime displayDate = widget.selectedDate ?? DateTime(2026, 8, 12);
    final String formattedDate = _formatDate(displayDate);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- AppBar ----
            AppBarBack(
              title: 'เลือกเวลาจองคิว',
              onBack: widget.onBack,
            ),

            SizedBox(height: context.rs(16)),

            // ---- Doctor Profile ----
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rs(20)),
              child: _DoctorProfile(
                name: widget.doctorName,
                specialty: widget.doctorSpecialty,
                imageAsset: widget.doctorImageAsset,
              ),
            ),

            SizedBox(height: context.rs(20)),

            // ---- Divider ----
            Divider(
              height: 1,
              thickness: 1,
              color: AppColors.inputBorder,
            ),

            SizedBox(height: context.rs(16)),

            // ---- Date Row ----
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rs(20)),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: context.rs(18),
                    color: AppColors.black,
                  ),
                  SizedBox(width: context.rs(8)),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: widget.onChangeDate,
                    child: Text(
                      'เปลี่ยนวัน',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(13),
                        fontWeight: FontWeight.w500,
                        color: AppColors.purple,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.rs(20)),

            // ---- Time Section ----
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rs(20)),
              child: Text(
                'เลือกเวลาที่ต้องการ',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(13),
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),

            SizedBox(height: context.rs(12)),

            // ---- Time Slots Grid ----
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.rs(20)),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: context.rs(12),
                    crossAxisSpacing: context.rs(12),
                    childAspectRatio: 2.4,
                  ),
                  itemCount: _timeSlots.length,
                  itemBuilder: (context, i) {
                    final time = _timeSlots[i];
                    final isSelected = _selectedTime == time;
                    return _TimeSlotCard(
                      time: time,
                      isSelected: isSelected,
                      onTap: () => setState(() => _selectedTime = time),
                    );
                  },
                ),
              ),
            ),

            // ---- Bottom Buttons ----
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.rs(24),
                0,
                context.rs(24),
                context.rs(16),
              ),
              child: Column(
                children: [
                  // ปุ่มยืนยันการจอง
                  SizedBox(
                    width: double.infinity,
                    height: context.rs(44),
                    child: ElevatedButton(
                      onPressed: _selectedTime != null
                          ? () => widget.onConfirm?.call(_selectedTime!)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        disabledBackgroundColor: AppColors.registerButton,
                        foregroundColor: AppColors.white,
                        disabledForegroundColor: AppColors.textGray,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.rs(30)),
                        ),
                      ),
                      child: Text(
                        'ยืนยันการจอง',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: context.rs(8)),

                  // หมายเหตุ
                  Text(
                    '*กรุณามาถึงก่อนเวลานัด 15 นาที',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(11),
                      fontWeight: FontWeight.w400,
                      color: AppColors.textGray,
                    ),
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
// _DoctorProfile - โปรไฟล์หมอ (รูป + ชื่อ + ความเชี่ยวชาญ)
// ============================================================
class _DoctorProfile extends StatelessWidget {
  const _DoctorProfile({
    required this.name,
    required this.specialty,
    this.imageAsset,
  });

  final String name;
  final String specialty;
  final String? imageAsset;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ---- Avatar ----
        Container(
          width: context.rs(52),
          height: context.rs(52),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.homeBackground,
            border: Border.all(
              color: AppColors.inputBorder,
              width: 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: imageAsset != null
              ? Image.asset(
                  imageAsset!,
                  fit: BoxFit.cover,
                )
              : Icon(
                  Icons.person,
                  size: context.rs(30),
                  color: AppColors.textGray,
                ),
        ),

        SizedBox(width: context.rs(12)),

        // ---- Name & Specialty ----
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(14),
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: context.rs(2)),
            Text(
              specialty,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(12),
                fontWeight: FontWeight.w400,
                color: AppColors.textGray,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// _TimeSlotCard - card เลือกเวลา
// ============================================================
class _TimeSlotCard extends StatelessWidget {
  const _TimeSlotCard({
    required this.time,
    required this.isSelected,
    required this.onTap,
  });

  final String time;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.purple : AppColors.white,
          borderRadius: BorderRadius.circular(context.rs(12)),
          border: Border.all(
            color: isSelected ? AppColors.purple : AppColors.inputBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          time,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(14),
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}
