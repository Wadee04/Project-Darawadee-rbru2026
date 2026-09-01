import 'package:flutter/material.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

// ============================================================
// BirthdayPage - หน้าเลือกวันเกิด
// ============================================================
class BirthdayPage extends StatefulWidget {
  const BirthdayPage({
    super.key,
    this.onBack,
    this.onNext,
    this.onSkip,
  });

  final VoidCallback? onBack;
  final void Function(DateTime date)? onNext;
  final VoidCallback? onSkip;

  @override
  State<BirthdayPage> createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage> {
  // Default วันที่ 4 พฤษภาคม 2547 (ตาม design)
  int _selectedDay = 4;
  int _selectedMonth = 5; // 1–12
  int _selectedYear = 2547; // พ.ศ.

  late final FixedExtentScrollController _dayCtrl;
  late final FixedExtentScrollController _monthCtrl;
  late final FixedExtentScrollController _yearCtrl;

  static const List<String> _thaiMonths = [
    'มกราคม', 'กุมภาพันธ์', 'มีนาคม',
    'เมษายน', 'พฤษภาคม', 'มิถุนายน',
    'กรกฎาคม', 'สิงหาคม', 'กันยายน',
    'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม',
  ];

  // ปี พ.ศ. ให้เลือก 2480–ปีปัจจุบัน+543
  late final List<int> _years;

  @override
  void initState() {
    super.initState();
    final int currentYearBE =
        DateTime.now().year + 543;
    _years = List.generate(
      currentYearBE - 2480 + 1,
      (i) => 2480 + i,
    );

    _dayCtrl =
        FixedExtentScrollController(initialItem: _selectedDay - 1);
    _monthCtrl =
        FixedExtentScrollController(initialItem: _selectedMonth - 1);
    _yearCtrl = FixedExtentScrollController(
      initialItem: _years.indexOf(_selectedYear),
    );
  }

  @override
  void dispose() {
    _dayCtrl.dispose();
    _monthCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  int _daysInMonth(int month, int yearBE) {
    final int yearCE = yearBE - 543;
    return DateTime(yearCE, month + 1, 0).day;
  }

  String get _selectedDateText {
    final String day = _selectedDay.toString().padLeft(2, '0');
    final String month = _thaiMonths[_selectedMonth - 1];
    return '$day $month $_selectedYear';
  }

  DateTime get _selectedDateTime {
    final int yearCE = _selectedYear - 543;
    return DateTime(yearCE, _selectedMonth, _selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    final int daysCount = _daysInMonth(_selectedMonth, _selectedYear);
    final double itemHeight = context.rs(44);
    final double drumHeight = itemHeight * 5; // แสดง 5 แถว

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ---- AppBar ----
            const AppBarBack(title: ''),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: context.rs(8)),

                    // ---- Mascot ----
                    Container(
                      width: context.rs(200),
                      height: context.rs(200),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/signup/mascotsignup.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // ---- Title ----
                    Text(
                      'วันเกิดของคุณคือวันไหน?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(18),
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: context.rs(8)),
                    Text(
                      'เพื่อใช้ขอประสบการณ์ที่เหมาะสมกับคุณ\nและแสดงข้อมูลที่เกี่ยวข้องได้อย่างถูกต้อง',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(12),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textGray,
                        height: 1.6,
                      ),
                    ),

                    SizedBox(height: context.rs(24)),

                    // ---- Drum Date Picker ----
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(context.rs(16)),
                        border: Border.all(
                          color: AppColors.inputBorder,
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.rs(8),
                        vertical: context.rs(8),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Highlight bar กลาง
                          Positioned(
                            top: drumHeight / 2 - itemHeight / 2,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: itemHeight,
                              decoration: BoxDecoration(
                                color: AppColors.purpleLight
                                    .withValues(alpha: 0.35),
                                borderRadius:
                                    BorderRadius.circular(context.rs(8)),
                              ),
                            ),
                          ),
                          // Columns
                          SizedBox(
                            height: drumHeight,
                            child: Row(
                              children: [
                                // วัน
                                Expanded(
                                  flex: 2,
                                  child: _DrumColumn(
                                    controller: _dayCtrl,
                                    itemCount: daysCount,
                                    itemHeight: itemHeight,
                                    selectedIndex: _selectedDay - 1,
                                    labelBuilder: (i) =>
                                        (i + 1).toString(),
                                    onChanged: (i) => setState(
                                        () => _selectedDay = i + 1),
                                  ),
                                ),
                                // เดือน
                                Expanded(
                                  flex: 3,
                                  child: _DrumColumn(
                                    controller: _monthCtrl,
                                    itemCount: 12,
                                    itemHeight: itemHeight,
                                    selectedIndex: _selectedMonth - 1,
                                    labelBuilder: (i) => _thaiMonths[i],
                                    onChanged: (i) {
                                      setState(() {
                                        _selectedMonth = i + 1;
                                        final int maxDay = _daysInMonth(
                                            _selectedMonth, _selectedYear);
                                        if (_selectedDay > maxDay) {
                                          _selectedDay = maxDay;
                                          _dayCtrl.jumpToItem(maxDay - 1);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                // ปี
                                Expanded(
                                  flex: 2,
                                  child: _DrumColumn(
                                    controller: _yearCtrl,
                                    itemCount: _years.length,
                                    itemHeight: itemHeight,
                                    selectedIndex:
                                        _years.indexOf(_selectedYear),
                                    labelBuilder: (i) =>
                                        _years[i].toString(),
                                    onChanged: (i) {
                                      setState(() {
                                        _selectedYear = _years[i];
                                        final int maxDay = _daysInMonth(
                                            _selectedMonth, _selectedYear);
                                        if (_selectedDay > maxDay) {
                                          _selectedDay = maxDay;
                                          _dayCtrl.jumpToItem(maxDay - 1);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: context.rs(16)),

                    // ---- วันเกิดที่เลือก ----
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.rs(16),
                        vertical: context.rs(12),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(context.rs(12)),
                        border: Border.all(
                          color: AppColors.inputBorder,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'วันเกิดที่เลือก  $_selectedDateText',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(13),
                          fontWeight: FontWeight.w500,
                          color: AppColors.purple,
                        ),
                      ),
                    ),

                    SizedBox(height: context.rs(20)),

                    // ---- ปุ่มถัดไป ----
                    SizedBox(
                      width: double.infinity,
                      height: context.rs(50),
                      child: ElevatedButton(
                        onPressed: () =>
                            widget.onNext?.call(_selectedDateTime),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(context.rs(30)),
                          ),
                        ),
                        child: Text(
                          'ถัดไป',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(15),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: context.rs(12)),

                    // ---- ข้ามไปก่อน ----
                    GestureDetector(
                      onTap: widget.onSkip,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: context.rs(8),
                        ),
                        child: Text(
                          'ข้ามไปก่อน',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(13),
                            fontWeight: FontWeight.w500,
                            color: AppColors.textGray,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.textGray,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: context.rs(24)),
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
// _DrumColumn — หนึ่งคอลัมน์ของ drum picker
// ============================================================
class _DrumColumn extends StatelessWidget {
  const _DrumColumn({
    required this.controller,
    required this.itemCount,
    required this.itemHeight,
    required this.selectedIndex,
    required this.labelBuilder,
    required this.onChanged,
  });

  final FixedExtentScrollController controller;
  final int itemCount;
  final double itemHeight;
  final int selectedIndex;
  final String Function(int index) labelBuilder;
  final void Function(int index) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: itemHeight,
      diameterRatio: 2.0,
      perspective: 0.003,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: onChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) {
          if (index < 0 || index >= itemCount) return null;
          final bool isSelected = index == selectedIndex;
          return Center(
            child: Text(
              labelBuilder(index),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isSelected
                    ? context.rs(15)
                    : context.rs(12),
                fontWeight: isSelected
                    ? FontWeight.w700
                    : FontWeight.w400,
                color: isSelected
                    ? AppColors.purple
                    : AppColors.textGray,
              ),
            ),
          );
        },
        childCount: itemCount,
      ),
    );
  }
}
