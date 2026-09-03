import 'package:flutter/material.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

// ============================================================
// BookAnAppointmentThree - หน้าเลือกบริการ
// ============================================================

class BookAnAppointmentThree extends StatefulWidget {
  const BookAnAppointmentThree({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  State<BookAnAppointmentThree> createState() => _BookAnAppointmentThreeState();
}

class _BookAnAppointmentThreeState extends State<BookAnAppointmentThree> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedFilter = 0;
  final Set<int> _selectedServices = {};

  static const List<String> _filterLabels = [
    'ทั้งหมด',
    'ประเภท/ต้องใช้',
    'กบฏ / ชนิดบริการ',
    'ราคา / ส่วนลด',
  ];

  static const List<_ServiceItem> _services = [
    _ServiceItem(label: 'ถอนฟัน', icon: Icons.medical_services_outlined),
    _ServiceItem(label: 'อุดฟัน/อุดฟันน้ำนม', icon: Icons.health_and_safety_outlined),
    _ServiceItem(label: 'ฉีดยาชา/เย็บแผล', icon: Icons.colorize_outlined),
    _ServiceItem(label: 'สเกลฟัน', icon: Icons.clean_hands_outlined),
    _ServiceItem(label: 'ฟันปลอม', icon: Icons.sentiment_satisfied_outlined),
    _ServiceItem(label: 'ขูดหินปูน', icon: Icons.brush_outlined),
    _ServiceItem(label: 'รักษารากฟัน', icon: Icons.healing_outlined),
    _ServiceItem(label: 'ครอบฟัน/ครอบฟัน', icon: Icons.circle_outlined),
    _ServiceItem(label: 'Surgical/ผ่าตัด', icon: Icons.local_hospital_outlined),
    _ServiceItem(label: 'เครื่องมือจัดฟัน', icon: Icons.settings_outlined),
    _ServiceItem(label: 'เคลือบหลุมร่องฟัน / ฟลู', icon: Icons.layers_outlined),
    _ServiceItem(label: 'ตรวจสภาพฟัน / X-ray', icon: Icons.search_outlined),
    _ServiceItem(label: 'พิมพ์ฟัน', icon: Icons.fingerprint_outlined),
    _ServiceItem(label: 'จัดฟัน / จัดฟันเฉพาะ', icon: Icons.tune_outlined),
    _ServiceItem(label: 'สกัด / เกาะตัว', icon: Icons.construction_outlined),
    _ServiceItem(label: 'กล่องฟัน', icon: Icons.inventory_2_outlined),
    _ServiceItem(label: 'ฝังรากเทียม', icon: Icons.anchor_outlined),
    _ServiceItem(label: 'ฟัน / จัดฟัน', icon: Icons.face_outlined),
    _ServiceItem(label: 'อุด / แก้', icon: Icons.edit_outlined),
    _ServiceItem(label: 'กระดาษ/ทำความสะอาด', icon: Icons.cleaning_services_outlined),
    _ServiceItem(label: 'พิมพ์', icon: Icons.print_outlined),
    _ServiceItem(label: 'ปิดเปิด / ถอดแถบ', icon: Icons.toggle_on_outlined),
    _ServiceItem(label: 'ปิดช่อง / จัดการทั่วไป', icon: Icons.build_outlined),
    _ServiceItem(label: 'ปิดหมาก / แก้ไขทั่วไป', icon: Icons.handyman_outlined),
    _ServiceItem(label: 'เมือกเยื่อ / จัดการในปาก', icon: Icons.spa_outlined),
    _ServiceItem(label: 'ระดับ', icon: Icons.bar_chart_outlined),
    _ServiceItem(label: 'และอื่นๆ ที่เกี่ยวข้อง', icon: Icons.more_horiz),
    _ServiceItem(label: 'กาแก้ไข', icon: Icons.redo_outlined),
    _ServiceItem(label: 'สิ่งแปลกปลอม / โรคในปาก', icon: Icons.bug_report_outlined),
    _ServiceItem(label: 'พัฒนาการเด็ก / โรคเด็ก', icon: Icons.child_care_outlined),
    _ServiceItem(label: 'ครอบแน่น / แก้', icon: Icons.lock_outlined),
    _ServiceItem(label: 'ประเมินไม่ได้', icon: Icons.help_outline),
    _ServiceItem(label: 'ฝังเข็ม', icon: Icons.add_circle_outline),
    _ServiceItem(label: 'ฟันน้ำนม / ฟัน', icon: Icons.child_friendly_outlined),
  ];

  List<_ServiceItem> get _filteredServices {
    if (_searchQuery.isEmpty) return _services;
    return _services
        .where((s) => s.label.contains(_searchQuery))
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
              title: 'เลือกบริการ',
              onBack: widget.onBack,
            ),

            SizedBox(height: context.rs(12)),

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
                  hintText: 'ค้นหาบริการ',
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
                  contentPadding: EdgeInsets.symmetric(
                    vertical: context.rs(10),
                  ),
                  filled: true,
                  fillColor: AppColors.homeBackground,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(context.rs(24)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(context.rs(24)),
                    borderSide: const BorderSide(color: AppColors.purple, width: 1),
                  ),
                ),
              ),
            ),

            SizedBox(height: context.rs(12)),

            // ---- Filter Chips ----
            SizedBox(
              height: context.rs(34),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: context.rs(16)),
                itemCount: _filterLabels.length,
                separatorBuilder: (_, __) => SizedBox(width: context.rs(8)),
                itemBuilder: (context, i) {
                  final selected = _selectedFilter == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.rs(14),
                        vertical: context.rs(6),
                      ),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.purple : AppColors.homeBackground,
                        borderRadius: BorderRadius.circular(context.rs(20)),
                      ),
                      child: Text(
                        _filterLabels[i],
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(12),
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                          color: selected ? AppColors.white : AppColors.textGray,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: context.rs(12)),

            // ---- Service Grid ----
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: context.rs(16),
                  vertical: context.rs(4),
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: context.rs(10),
                  crossAxisSpacing: context.rs(10),
                  childAspectRatio: 2.6,
                ),
                itemCount: _filteredServices.length,
                itemBuilder: (context, i) {
                  final service = _filteredServices[i];
                  final isSelected = _selectedServices.contains(i);
                  return _ServiceCard(
                    item: service,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedServices.remove(i);
                        } else {
                          _selectedServices.add(i);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Service Item data class
// ============================================================
class _ServiceItem {
  const _ServiceItem({required this.label, required this.icon});
  final String label;
  final IconData icon;
}

// ============================================================
// Service Card
// ============================================================
class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _ServiceItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(context.rs(12)),
          border: Border.all(
            color: isSelected ? AppColors.purple : AppColors.inputBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: context.rs(10),
          vertical: context.rs(8),
        ),
        child: Row(
          children: [
            // ---- Icon ----
            Container(
              width: context.rs(36),
              height: context.rs(36),
              decoration: BoxDecoration(
                color: AppColors.homeBackground,
                borderRadius: BorderRadius.circular(context.rs(8)),
              ),
              child: Icon(
                item.icon,
                size: context.rs(20),
                color: AppColors.purple,
              ),
            ),

            SizedBox(width: context.rs(8)),

            // ---- Label ----
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(11),
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // ---- Add / Remove button ----
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: context.rs(20),
                height: context.rs(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.reddentbook : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.reddentbook : AppColors.textGray,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  isSelected ? Icons.remove : Icons.add,
                  size: context.rs(12),
                  color: isSelected ? AppColors.white : AppColors.textGray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
