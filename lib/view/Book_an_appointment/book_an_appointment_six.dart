import 'package:flutter/material.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

// ============================================================
// BookAnAppointmentSix - หน้าตารางหมอ (ปฏิทินเลือกวันนัด)
// ============================================================

class BookAnAppointmentSix extends StatefulWidget {
  const BookAnAppointmentSix({super.key, this.onBack, this.onNext});

  final VoidCallback? onBack;
  final VoidCallback? onNext;

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
        child: Column(
          children: [
            // ---- AppBar ----
            AppBarBack(
              title: 'ตารางหมอ',
              onBack: widget.onBack,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: context.rs(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.rs(16)),

                    // ---- Doctor profile ----
                    _DoctorHeader(),

                    SizedBox(height: context.rs(20)),

                    Divider(color: AppColors.inputBorder, height: 1),

                    SizedBox(height: context.rs(20)),

                    // ---- Calendar ----
                    _buildCalendar(context),

                    SizedBox(height: context.rs(20)),

                    // ---- Legend ----
                    _buildLegend(context),

                    SizedBox(height: context.rs(16)),

                    // ---- Working hours card ----
                    _buildWorkingHoursCard(context),

                    SizedBox(height: context.rs(24)),
                  ],
                ),
              ),
            ),

            // ---- Bottom Button ----
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.rs(16),
                context.rs(8),
                context.rs(16),
                context.rs(24),
              ),
              child: PillButton(
                label: 'ถัดไป',
                variant: _selectedDay != null
                    ? PillButtonVariant.primary
                    : PillButtonVariant.secondary,
                onPressed: _selectedDay != null ? widget.onNext : null,
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
                    fontSize: context.rs(11),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGray,
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
      _LegendItem(color: Color(0xFF7ED8F6), label: 'วันที่หมอเข้า'),
      _LegendItem(color: AppColors.orange, label: 'คิวเต็ม'),
      _LegendItem(color: Color(0xFF7FD99A), label: 'เลือกวัน'),
      _LegendItem(color: Color(0xFFD0D0D0), label: 'วันหยุด'),
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
          width: context.rs(12),
          height: context.rs(12),
          decoration: BoxDecoration(
            color: item.color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: context.rs(6)),
        Text(
          item.label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(11),
            color: AppColors.textGray,
          ),
        ),
      ],
    );
  }

  // ---- Working hours card ----
  Widget _buildWorkingHoursCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rs(14)),
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                size: context.rs(16),
                color: AppColors.textGray,
              ),
              SizedBox(width: context.rs(6)),
              Text(
                'เวลาที่หมอเข้า',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(13),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: context.rs(6)),
          Text(
            '09:00 - 17:00',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(13),
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: context.rs(4)),
          Text(
            '*อาจมีการเปลี่ยนแปลง กรุณาตรวจสอบอีกครั้ง',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(11),
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Doctor header
// ============================================================
class _DoctorHeader extends StatelessWidget {
  const _DoctorHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar with glow
        SizedBox(
          width: context.rs(60),
          height: context.rs(60),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow
              Container(
                width: context.rs(60),
                height: context.rs(60),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFCDBFF6).withValues(alpha: 0.6),
                      const Color(0xFFCDBFF6).withValues(alpha: 0.2),
                      const Color(0xFFCDBFF6).withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),
              // Photo placeholder
              CircleAvatar(
                radius: context.rs(26),
                backgroundColor: const Color(0xFFD6E4F0),
                child: Icon(
                  Icons.person,
                  size: context.rs(30),
                  color: AppColors.purple.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: context.rs(12)),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ทพญ. อรุณี ป.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(14),
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: context.rs(3)),
            Text(
              'ทันตแพทย์ทั่วไป',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(12),
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
    if (isSelected) return const Color(0xFF7FD99A);
    if (isFull) return AppColors.orange;
    if (isAvailable) return const Color(0xFF7ED8F6);
    if (isHoliday) return const Color(0xFFD0D0D0);
    return Colors.transparent;
  }

  Color get _textColor {
    if (isSelected || isFull || isAvailable) return AppColors.white;
    if (isHoliday) return AppColors.textGray;
    return AppColors.black;
  }

  bool get _hasCircle =>
      isSelected || isFull || isAvailable || isHoliday;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: context.rs(32),
          height: context.rs(32),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hasCircle ? _bgColor : Colors.transparent,
          ),
          child: Center(
            child: Text(
              '$day',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(12),
                fontWeight:
                    _hasCircle ? FontWeight.w600 : FontWeight.w400,
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
  const _LegendItem({required this.color, required this.label});
  final Color color;
  final String label;
}
