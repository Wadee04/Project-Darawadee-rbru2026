import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';
import 'book_an_appointment_six.dart';

// ============================================================
// BookAnAppointmentFive - หน้าเลือกทันตแพทย์
// ============================================================

class BookAnAppointmentFive extends StatefulWidget {
  const BookAnAppointmentFive({super.key, this.onBack, this.onNext});

  final VoidCallback? onBack;
  final VoidCallback? onNext;

  @override
  State<BookAnAppointmentFive> createState() => _BookAnAppointmentFiveState();
}

class _BookAnAppointmentFiveState extends State<BookAnAppointmentFive> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  int? _selectedIndex;

  static const List<_DentistItem> _dentists = [
    _DentistItem(
      name: 'ทพญ. อรุณ ใจดี',
      specialty: 'ทันตกรรมทั่วไป',
      room: 'ห้องที่ 1',
      imagePlaceholderColor: Color(0xFFD6E4F0),
    ),
    _DentistItem(
      name: 'ทพ. ธนากร สังเคราะห์',
      specialty: 'ทันตกรรมประดิษฐ์',
      room: 'ห้องที่ 2',
      imagePlaceholderColor: Color(0xFFE8D6F0),
    ),
    _DentistItem(
      name: 'ทพญ. พิมพ์ชนก ใบบัว',
      specialty: 'ทันตกรรมจัดฟัน',
      room: 'ห้องที่ 3',
      imagePlaceholderColor: Color(0xFFD6F0E4),
    ),
  ];

  List<_DentistItem> get _filtered {
    if (_searchQuery.isEmpty) return _dentists;
    return _dentists
        .where((d) =>
            d.name.contains(_searchQuery) ||
            d.specialty.contains(_searchQuery))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  title: 'เลือกทันตแพทย์',
                  onBack: widget.onBack,
                ),

                SizedBox(height: context.rs(18)),

                // ---- Search Bar ----
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(14),
                      color: AppColors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'ค้นหาทันตแพทย์',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(14),
                        color: AppColors.inputHint,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.black50,
                        size: context.rs(20),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: context.rs(16),
                        vertical: context.rs(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.rs(24)),
                        borderSide: BorderSide(color: AppColors.black20, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(context.rs(24)),
                        borderSide: BorderSide(color: AppColors.black20, width: 1),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: context.rs(16)),

                // ---- Dentist List ----
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      context.rs(24),
                      0,
                      context.rs(24),
                      _selectedIndex != null
                          ? context.rs(48 + 48 + 12)
                          : context.rs(24),
                    ),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: context.rs(12)),
                    itemBuilder: (context, i) {
                      final dentist = _filtered[i];
                      final isSelected = _selectedIndex == i;
                      return _DentistCard(
                        item: dentist,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedIndex = i),
                      );
                    },
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
                onTap: _selectedIndex != null
                    ? () {
                        final selected = _filtered[_selectedIndex!];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookAnAppointmentSix(
                              doctorName: selected.name,
                              doctorSpecialty: selected.specialty,
                            ),
                          ),
                        );
                      }
                    : null,
                child: Container(
                  height: context.rs(40),
                  decoration: BoxDecoration(
                    color: _selectedIndex != null
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
                        color: _selectedIndex != null ? Colors.white : AppColors.black,
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
}

// ============================================================
// Dentist data class
// ============================================================
class _DentistItem {
  const _DentistItem({
    required this.name,
    required this.specialty,
    required this.room,
    required this.imagePlaceholderColor,
  });

  final String name;
  final String specialty;
  final String room;
  final Color imagePlaceholderColor;
}

// ============================================================
// Dentist Card
// ============================================================
class _DentistCard extends StatelessWidget {
  const _DentistCard({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _DentistItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(context.rs(16)),
          border: Border.all(
            color: isSelected ? AppColors.purple : AppColors.inputBorder,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ---- Photo ----
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(context.rs(16)),
                bottomLeft: Radius.circular(context.rs(16)),
              ),
              child: Container(
                width: context.rs(100),
                height: context.rs(100),
                color: item.imagePlaceholderColor,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Placeholder doctor icon
                    Center(
                      child: SvgPicture.asset(
                        'assets/images/Book_an_appointment/doctor.svg',
                        width: context.rs(40),
                        height: context.rs(40),
                        colorFilter: ColorFilter.mode(
                          AppColors.purple.withValues(alpha: 0.4),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(width: context.rs(14)),

            // ---- Info ----
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: context.rs(14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      item.name,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),

                    SizedBox(height: context.rs(4)),

                    // Specialty
                    Text(
                      item.specialty,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(12),
                        fontWeight: FontWeight.w400,
                        color: AppColors.black50,
                      ),
                    ),

                    SizedBox(height: context.rs(8)),

                    // Room
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: context.rs(18),
                          color: AppColors.purple,
                        ),
                        SizedBox(width: context.rs(4)),
                        Text(
                          item.room,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(13),
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(width: context.rs(12)),
          ],
        ),
      ),
    );
  }
}
