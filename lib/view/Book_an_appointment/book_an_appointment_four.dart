import 'package:flutter/material.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

// ============================================================
// BookAnAppointmentFour - หน้าเลือกบริการ (พร้อมราคาและเวลา)
// ============================================================

class BookAnAppointmentFour extends StatefulWidget {
  const BookAnAppointmentFour({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  State<BookAnAppointmentFour> createState() => _BookAnAppointmentFourState();
}

class _BookAnAppointmentFourState extends State<BookAnAppointmentFour> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedFilter = 0;
  final Set<int> _selectedServices = {};

  static const List<String> _filterLabels = [
    'ทั้งหมด',
    'ทันตกรรมป้องกัน',
    'ทันตกรรมบูรณะ',
    'ศัลยกรรมช่องปาก',
  ];

  static const List<_ServiceItem> _services = [
    _ServiceItem(
      label: 'ตรวจฟัน + X-ray',
      subLabel: 'ฟรี - 500 บาท',
      duration: '30 นาที',
      iconAsset: 'assets/Book_an_appointment/tooth5.svg',
    ),
    _ServiceItem(
      label: 'อุดฟันน้ำนมปาก',
      subLabel: '500 - 1500 บาท',
      duration: '45 นาที',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'เคลือบฟลูออไรด์ / หลุมร่องฟัน',
      subLabel: '200 - 500 บาท',
      duration: '15 นาที',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'อุดฟัน',
      subLabel: '1000 - 2000 บาท/ซี่',
      duration: '45 นาที',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'รักษารากฟัน',
      subLabel: '4000 - 12000 บาท',
      duration: '90 นาที',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'ทำครอบฟัน',
      subLabel: '8000 - 20000+ บาท/ซี่',
      duration: '90 นาที',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'ถอนฟันธรรมดา',
      subLabel: '500 - 1500 บาท',
      duration: '30 นาที',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'ผ่าฟันคุด',
      subLabel: '1500 - 5000+ บาท',
      duration: '60 นาที',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'รากฟันเทียม(ฟิกซาก)',
      subLabel: '30000 - 80000 บาท',
      duration: '90 นาที',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'ฟันปลอม',
      subLabel: '2000 - 20000 บาท',
      duration: '30 นาที',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'พิมพ์ฟัน + X-ray',
      subLabel: '1900 - 2600 บาท',
      duration: '45 นาที',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'จัดฟันโลหะ(เต็มปาก/ซี่)',
      subLabel: '30000 - 80000 บาท',
      duration: '90 นาที',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'จัดฟันกาวอย/เซรามิค',
      subLabel: '50000 - 100000 บาท',
      duration: '90 นาที',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'Invisalign',
      subLabel: '60000 - 150000 บาท',
      duration: '90 นาที',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'ฟอกสีฟันที่คลินิก',
      subLabel: '3000 - 8000 บาท',
      duration: '45 นาที',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'ฟอกสีฟันที่บ้าน',
      subLabel: '2000 - 5000 บาท',
      duration: 'ทำที่บ้าน',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'วีเนียร์คอมโพสิต',
      subLabel: '2000 - 5000 บาท/ซี่',
      duration: '30 นาที',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'วีเนียร์พอร์ซเลน',
      subLabel: '12000 - 25000 บาท/ซี่',
      duration: '45 นาที',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'รักษาเหงือกขั้นรุนแรง',
      subLabel: 'หลักพัน - หลักหมื่น',
      duration: '60 นาที',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'อุดฟันน้ำนม',
      subLabel: '12000 - 25000 บาท/ซี่',
      duration: '45 นาที',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'รักษารากฟันน้ำนม',
      subLabel: '1500 - 3500 บาท/ซี่',
      duration: '60 นาที',
      iconAsset: null,
    ),
    _ServiceItem(
      label: 'อื่นๆ',
      subLabel: '',
      duration: '',
      iconAsset: null,
    ),
  ];

  List<_ServiceItem> get _filteredServices {
    if (_searchQuery.isEmpty) return _services;
    return _services
        .where((s) =>
            s.label.contains(_searchQuery) ||
            s.subLabel.contains(_searchQuery))
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
                    borderSide:
                        const BorderSide(color: AppColors.purple, width: 1),
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
                separatorBuilder: (_, _) => SizedBox(width: context.rs(8)),
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
                        color: selected
                            ? AppColors.orange
                            : AppColors.homeBackground,
                        borderRadius: BorderRadius.circular(context.rs(20)),
                      ),
                      child: Text(
                        _filterLabels[i],
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(12),
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: selected
                              ? AppColors.white
                              : AppColors.textGray,
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
                  childAspectRatio: 1.55,
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
  const _ServiceItem({
    required this.label,
    required this.subLabel,
    required this.duration,
    this.iconAsset,
  });

  final String label;
  final String subLabel;
  final String duration;
  final String? iconAsset;
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
          borderRadius: BorderRadius.circular(context.rs(14)),
          border: Border.all(
            color:
                isSelected ? AppColors.orange : AppColors.inputBorder,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black20.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(context.rs(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Top row: icon + add/remove button ----
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon with glow background
                _GlowIcon(size: context.rs(48)),

                const Spacer(),

                // Duration badge
                if (item.duration.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.rs(6),
                      vertical: context.rs(2),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.homeBackground,
                      borderRadius: BorderRadius.circular(context.rs(20)),
                    ),
                    child: Text(
                      item.duration,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(9),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textGray,
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: context.rs(6)),

            // ---- Service name ----
            Text(
              item.label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(11),
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const Spacer(),

            // ---- Bottom row: price + add button ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Price
                if (item.subLabel.isNotEmpty)
                  Expanded(
                    child: Text(
                      item.subLabel,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(9),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textGray,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                // Add / Remove button
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: context.rs(20),
                    height: context.rs(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppColors.reddentbook
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.reddentbook
                            : AppColors.textGray,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      isSelected ? Icons.remove : Icons.add,
                      size: context.rs(12),
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textGray,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _GlowIcon - icon วงกลมมีพื้นหลังแบบ radial gradient ฟุ้งๆ
// ============================================================
class _GlowIcon extends StatelessWidget {
  const _GlowIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow layer — radial gradient, no hard edge
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFCDBFF6).withValues(alpha: 0.6),
                  const Color(0xFFCDBFF6).withValues(alpha: 0.25),
                  const Color(0xFFCDBFF6).withValues(alpha: 0.0),
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
          // Icon
          Icon(
            Icons.medical_services_outlined,
            size: size * 0.48,
            color: AppColors.orange,
          ),
        ],
      ),
    );
  }
}
