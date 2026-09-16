import 'package:flutter/material.dart';

import '../../../components/shared_widgets.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';
import 'book_an_appointment_seven.dart';

// ============================================================
// BookAnAppointmentSix - หน้าตารางหมอ (ปฏิทินเลือกวันนัด)
// ============================================================

class BookAnAppointmentSix extends StatefulWidget {
  const BookAnAppointmentSix({
    super.key,
    this.onBack,
    this.onNext,
    this.doctorName = 'ทพญ. อรุณี ป.',
    this.doctorSpecialty = 'ทันตแพทย์ทั่วไป',
    this.doctorImageAsset,
  });

  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final String doctorName;
  final String doctorSpecialty;
  final String? doctorImageAsset;

  @override
  State<BookAnAppointmentSix> createState() => _BookAnAppointmentSixState();
}

class _BookAnAppointmentSixState extends State<BookAnAppointmentSix> {
  // เดือนที่แสดง
  DateTime _displayMonth = DateTime(2026, 8); // สิงหาคม 2569 (2026)
  int? _selectedDay;

  // วันที่มีคิว (วงสีฟ้า)
  static const Set<int> _availableDays = {
    3, 5, 10, 11, 12, 17, 18, 19, 24, 25, 26, 31,
  };

  // วันที่คิวเต็ม (วงสีส้ม)
  static const Set<int> _fullDays = {4};

  // วันหยุด (วงสีเทา)
  static const Set<int> _holidayDays = {1, 8, 15, 22, 29};

  static const List<String> _thaiWeekdays = [
    'อา.', 'จ.', 'อ.', 'พ.', 'พฤ.', 'ศ.', 'ส.',
  ];

  static const List<String> _thaiMonths = [
    'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน',
    'พฤษภาคม', 'มิถุนายน', 'กรกฎาคม', 'สิงหาคม',
    'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม',
  ];

  String get _monthLabel {
    final month = _thaiMonths[_displayMonth.month - 1];
    final year = _displayMonth.year + 543; // แปลง ค.ศ. → พ.ศ.
    return '$month $year';
  }

  int get _firstWeekday {
    // DateTime weekday: 1=จันทร์ … 7=อาทิตย์ → แปลงเป็น 0=อา. … 6=ส.
    final wd = DateTime(_displayMonth.year, _displayMonth.month, 1).weekday;
    return wd % 7; // จันทร์=1→1, อาทิตย์=7→0
  }

  int get _daysInMonth =>
      DateTime(_displayMonth.year, _displayMonth.month + 1, 0).day;

  void _prevMonth() {
    setState(() {
      _selectedDay = null;
      _displayMonth =
          DateTime(_displayMonth.year, _displayMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedDay = null;
      _displayMonth =
          DateTime(_displayMonth.year, _displayMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ---- AppBar ----
                AppBarBack(
                  title: 'ตารางหมอ',
                  onBack: widget.onBack,
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: context.rs(16)),

                        // ---- Doctor profile ----
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
                          child: _DoctorProfile(
                            name: widget.doctorName,
                            specialty: widget.doctorSpecialty,
                            imageAsset: widget.doctorImageAsset,
                          ),
                        ),

                        SizedBox(height: context.rs(10)),

                        Divider(color: AppColors.inputBorder, height: 0.5),

                        SizedBox(height: context.rs(10)),

                        // ---- Calendar ----
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
                          child: _buildCalendar(context),
                        ),

                        SizedBox(height: context.rs(15)),

                        Divider(color: AppColors.inputBorder, height: 0.5),

                        SizedBox(height: context.rs(15)),
                        // ---- Legend ----
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
                          child: _buildLegend(context),
                        ),

                        SizedBox(height: context.rs(20)),

                        // ---- Working hours card ----
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
                          child: _buildWorkingHoursCard(context),
                        ),

                        SizedBox(height: context.rs(24)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ---- ปุ่มถัดไป (ลอย) ----
            Positioned(
              left: context.rs(24),
              right: context.rs(24),
              bottom: context.rs(48),
              child: GestureDetector(
                onTap: _selectedDay != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookAnAppointmentSeven(
                              doctorName: widget.doctorName,
                              doctorSpecialty: widget.doctorSpecialty,
                              doctorImageAsset: widget.doctorImageAsset,
                            ),
                          ),
                        );
                      }
                    : null,
                child: Container(
                  height: context.rs(40),
                  decoration: BoxDecoration(
                    color: _selectedDay != null
                        ? AppColors.purple
                        : AppColors.black20ff,
                    borderRadius: BorderRadius.circular(context.rs(30)),
                  ),
                  child: Center(
                    child: Text(
                      'ถัดไป',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(14),
                        fontWeight: FontWeight.w400,
                        color: _selectedDay != null ? Colors.white : AppColors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Calendar widget ----
  Widget _buildCalendar(BuildContext context) {
    return Column(
      children: [
        // Month navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: _prevMonth,
              child: Padding(
                padding: EdgeInsets.all(context.rs(8)),
                child: Icon(
                  Icons.chevron_left,
                  size: context.rs(22),
                  color: AppColors.black,
                ),
              ),
            ),
            Text(
              _monthLabel,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(15),
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            GestureDetector(
              onTap: _nextMonth,
              child: Padding(
                padding: EdgeInsets.all(context.rs(8)),
                child: Icon(
                  Icons.chevron_right,
                  size: context.rs(22),
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: context.rs(8)),

        // Weekday headers
        Row(
          children: _thaiWeekdays.map((d) {
            return Expanded(
              child: Center(
                child: Text(
                  d,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(16),
                    fontWeight: FontWeight.w500,
                    color: AppColors.black.withValues(alpha: 0.30),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        SizedBox(height: context.rs(6)),

        // Day grid
        _buildDayGrid(context),
      ],
    );
  }

  Widget _buildDayGrid(BuildContext context) {
    final firstOffset = _firstWeekday; // 0=อา. … 6=ส.
    final total = firstOffset + _daysInMonth;
    final rows = (total / 7).ceil();

    return Column(
      children: List.generate(rows, (row) {
        return Row(
          children: List.generate(7, (col) {
            final index = row * 7 + col;
            final day = index - firstOffset + 1;

            if (day < 1 || day > _daysInMonth) {
              return const Expanded(child: SizedBox());
            }

            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: context.rs(3)),
                child: _DayCell(
                  day: day,
                  isAvailable: _availableDays.contains(day),
                  isFull: _fullDays.contains(day),
                  isHoliday: _holidayDays.contains(day),
                  isSelected: _selectedDay == day,
                  onTap: () {
                    // ไม่ให้เลือกวันหยุดหรือคิวเต็ม
                    if (!_holidayDays.contains(day) &&
                        !_fullDays.contains(day)) {
                      setState(() => _selectedDay = day);
                    }
                  },
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  // ---- Legend ----
  Widget _buildLegend(BuildContext context) {
    const items = [
      _LegendItem(color: Color(0xFFA6E7FF), label: 'วันที่หมอเข้า'),
      _LegendItem(color: AppColors.orange, label: 'คิวเต็ม'),
      _LegendItem(color: Color(0xFFC5E8B3), label: 'เลือกวัน'),
      _LegendItem(isBlackTen: true, label: 'วันหยุด'),
    ];

    return Wrap(
      spacing: context.rs(16),
      runSpacing: context.rs(8),
      children: items
          .map((item) => _buildLegendChip(context, item))
          .toList(),
    );
  }

  Widget _buildLegendChip(BuildContext context, _LegendItem item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: context.rs(15),
          height: context.rs(15),
          decoration: BoxDecoration(
            color: item.isBlackTen
                ? AppColors.black.withValues(alpha: 0.10)
                : item.color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: context.rs(6)),
        Text(
          item.label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(12),
            color: AppColors.black,
          ),
        ),
      ],
    );
  }

  // ---- Working hours ----
  Widget _buildWorkingHoursCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rs(12)),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.black.withValues(alpha: 0.10),
        ),
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.access_time_outlined,
            size: context.rs(18),
            color: AppColors.black50,
          ),
          SizedBox(width: context.rs(6)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'เวลาที่หมอเข้า',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(13),
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: context.rs(4)),
                Text(
                  '09:00 - 17:00',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(11),
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: context.rs(4)),
                Text(
                  '*อาจมีการเปลี่ยนแปลง กรุณาตรวจสอบอีกครั้ง',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(11),
                    color: AppColors.black.withValues(alpha: 0.60),
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
                fontSize: context.rs(13),
                color: AppColors.black.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// Day Cell
// ============================================================
class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isAvailable,
    required this.isFull,
    required this.isHoliday,
    required this.isSelected,
    required this.onTap,
  });

  final int day;
  final bool isAvailable;
  final bool isFull;
  final bool isHoliday;
  final bool isSelected;
  final VoidCallback onTap;

  Color get _bgColor {
    if (isSelected) return const Color(0xFFC5E8B3);
    if (isFull) return AppColors.orange;
    if (isAvailable) return const Color(0xFFA6E7FF);
    if (isHoliday) return AppColors.black.withValues(alpha: 0.10);
    return Colors.transparent;
  }

  Color get _textColor => AppColors.black;

  bool get _hasCircle =>
      isSelected || isFull || isAvailable || isHoliday;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: context.rs(25),
          height: context.rs(24),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hasCircle ? _bgColor : Colors.transparent,
          ),
          child: Center(
            child: Text(
              '$day',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(14),
                fontWeight: FontWeight.w500,
                color: _textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Legend item data
// ============================================================
class _LegendItem {
  const _LegendItem({this.color = Colors.transparent, required this.label, this.isBlackTen = false});
  final Color color;
  final String label;
  final bool isBlackTen;
}
