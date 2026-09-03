import 'package:flutter/material.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

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
        child: Column(
          children: [
            // ---- AppBar ----
            AppBarBack(
              title: 'เลือกทันตแพทย์',
              onBack: widget.onBack,
            ),

            SizedBox(height: context.rs(16)),

            // ---- Search Bar ----
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rs(16)),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(13),
                  color: AppColors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'ค้นหาทันตแพทย์',
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(13),
                    color: AppColors.inputHint,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.inputHint,
                    size: context.rs(20),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: context.rs(10)),
                  filled: true,
                  fillColor: AppColors.homeBackground,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(context.rs(24)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(context.rs(24)),
                    borderSide:
                        const BorderSide(color: AppColors.purple, width: 1),
                  ),
                ),
              ),
            ),

            SizedBox(height: context.rs(16)),

            // ---- Dentist List ----
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: context.rs(16)),
                itemCount: _filtered.length,
                separatorBuilder: (_, _) =>
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

            // ---- Bottom Button ----
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.rs(16),
                context.rs(12),
                context.rs(16),
                context.rs(24),
              ),
              child: PillButton(
                label: 'ถัดไป',
                variant: _selectedIndex != null
                    ? PillButtonVariant.primary
                    : PillButtonVariant.secondary,
                onPressed:
                    _selectedIndex != null ? widget.onNext : null,
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
                    // Glow background — same style as birthday.dart
                    Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFCDBFF6).withValues(alpha: 0.5),
                            const Color(0xFFCDBFF6).withValues(alpha: 0.15),
                            const Color(0xFFCDBFF6).withValues(alpha: 0.0),
                          ],
                          stops: const [0.0, 0.55, 1.0],
                        ),
                      ),
                    ),
                    // Placeholder person icon
                    Center(
                      child: Icon(
                        Icons.person,
                        size: context.rs(48),
                        color: AppColors.purple.withValues(alpha: 0.4),
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
                        fontSize: context.rs(13),
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),

                    SizedBox(height: context.rs(4)),

                    // Specialty
                    Text(
                      item.specialty,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(11),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textGray,
                      ),
                    ),

                    SizedBox(height: context.rs(8)),

                    // Room
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: context.rs(14),
                          color: AppColors.purple,
                        ),
                        SizedBox(width: context.rs(4)),
                        Text(
                          item.room,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(11),
                            fontWeight: FontWeight.w500,
                            color: AppColors.purple,
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
