import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final _otherDetailController = TextEditingController();
  String _searchQuery = '';
  int _selectedFilter = 0;
  final Set<int> _selectedIndexes = {};
  bool _otherSelected = false;

  // ---- Filter labels ----
  static const List<String> _filters = [
    'ทั้งหมด',
    'ปวดฟัน / เสียวฟัน',
    'ฟันผุ / โครงสร้างฟัน',
    'เหงือก / ปริทันต์',
    'กลิ่นปาก / รสชาติผิดปกติ',
    'การเรียงฟัน / การสบฟัน',
    'สี / ผิวฟัน',
    'ขากรรไกร / ข้อต่อ(TMJ)',
    'เนื้อเยื่ออ่อน / แผลในปาก',
    'อุบัติเหตุ / บาดเจ็บ',
    'ฟันปลอม / รากฟันเทียม / ครอบฟัน',
    'เด็ก / ฟันน้ำนม',
  ];

  // ---- Service list (imgPath + label + category) ----
  static const String _iconBase =
      'assets/images/Book_an_appointment/list_of_symptoms/';

  static const List<_ServiceItem> _allServices = [
    // --- 1: ปวดฟัน / เสียวฟัน ---
    _ServiceItem(imgPath: '${_iconBase}list1.png',   label: 'ปวดฟัน',                                      category: 1),
    _ServiceItem(imgPath: '${_iconBase}list1.png',   label: 'ปวดฟันเฉียบพลัน',                            category: 1),
    _ServiceItem(imgPath: '${_iconBase}list1.png',   label: 'ปวดฟันเรื้อรัง',                              category: 1),
    _ServiceItem(imgPath: '${_iconBase}list14.png',  label: 'เสียวฟัน',                                    category: 1),
    _ServiceItem(imgPath: '${_iconBase}list1.png',   label: 'ปวดเมื่อกัด',                                 category: 1),
    _ServiceItem(imgPath: '${_iconBase}list1.png',   label: 'ปวดร้าวไปหู / ศีรษะ / ขากรรไกร',            category: 1),

    // --- 2: ฟันผุ / โครงสร้างฟัน ---
    _ServiceItem(imgPath: '${_iconBase}list2.png',   label: 'ฟันผุ',                                       category: 2),
    _ServiceItem(imgPath: '${_iconBase}list15.png',  label: 'ฟันแตก',                                      category: 2),
    _ServiceItem(imgPath: '${_iconBase}list38.png',  label: 'ฟันสึก',                                      category: 2),
    _ServiceItem(imgPath: '${_iconBase}list37.png',  label: 'ฟันหลุด',                                     category: 2),
    _ServiceItem(imgPath: '${_iconBase}list19.png',  label: 'วัสดุอุดฟันหลุด / แตก',                      category: 2),

    // --- 3: เหงือก / ปริทันต์ ---
    _ServiceItem(imgPath: '${_iconBase}list3.png',   label: 'เหงือกอักเสบ / แดง',                         category: 3),
    _ServiceItem(imgPath: '${_iconBase}list16.png',  label: 'เลือดออกตามไรฟัน',                           category: 3),
    _ServiceItem(imgPath: '${_iconBase}list17.png',  label: 'เหงือกร่น',                                   category: 3),
    _ServiceItem(imgPath: '${_iconBase}list18.png',  label: 'มีหนอง / ฝีในช่องปาก',                       category: 3),
    _ServiceItem(imgPath: '${_iconBase}list4.png',   label: 'ฟันโยก / คลอน',                              category: 3),
    _ServiceItem(imgPath: '${_iconBase}list20.png',  label: 'เหงือกบวม',                                   category: 3),

    // --- 4: กลิ่นปาก / รสชาติผิดปกติ ---
    _ServiceItem(imgPath: '${_iconBase}list21.png',  label: 'กลิ่นปาก',                                    category: 4),

    // --- 5: การเรียงฟัน / การสบฟัน ---
    _ServiceItem(imgPath: '${_iconBase}list7.png',   label: 'ฟันแท้ขึ้นผิดตำแหน่ง',                      category: 5),
    _ServiceItem(imgPath: '${_iconBase}list23.png',  label: 'ฟันเก / ฟันซ้อน',                            category: 5),
    _ServiceItem(imgPath: '${_iconBase}list5.png',   label: 'ฟันห่าง',                                    category: 5),
    _ServiceItem(imgPath: '${_iconBase}list22.png',  label: 'สบฟันผิดปกติ',                               category: 5),

    // --- 6: สี / ผิวฟัน ---
    _ServiceItem(imgPath: '${_iconBase}list25.png',  label: 'ฟันเหลือง / มีคราบสี',                       category: 6),
    _ServiceItem(imgPath: '${_iconBase}list8.png',   label: 'ฟันเป็นจุดขาว / จุดด่าง',                   category: 6),
    _ServiceItem(imgPath: '${_iconBase}list26.png',  label: 'คราบหินปูน / คราบพลัค',                      category: 6),

    // --- 7: ขากรรไกร / ข้อต่อ (TMJ) ---
    _ServiceItem(imgPath: '${_iconBase}list27.png',  label: 'เสียงคลิก / ล็อกที่ขากรรไกร',               category: 7),
    _ServiceItem(imgPath: '${_iconBase}list28.png',  label: 'อ้าปากลำบาก',                                category: 7),
    _ServiceItem(imgPath: '${_iconBase}list9.png',   label: 'ปวดขากรรไกร',                                category: 7),
    _ServiceItem(imgPath: '${_iconBase}list29.png',  label: 'นอนกัดฟัน / ขบฟันแน่น',                     category: 7),

    // --- 8: เนื้อเยื่ออ่อน / แผลในปาก ---
    _ServiceItem(imgPath: '${_iconBase}list30.png',  label: 'แผลในช่องปาก',                               category: 8),
    _ServiceItem(imgPath: '${_iconBase}list31.png',  label: 'ปุ่ม / ก้อน / ตุ่มในช่องปาก',               category: 8),
    _ServiceItem(imgPath: '${_iconBase}list10.png',  label: 'ลิ้น / กระพุ้งแก้มอักเสบ, มีแผล',           category: 8),

    // --- 9: อุบัติเหตุ / บาดเจ็บ ---
    _ServiceItem(imgPath: '${_iconBase}list33.png',  label: 'ฟันบิ่น / หักจากอุบัติเหตุ',                category: 9),
    _ServiceItem(imgPath: '${_iconBase}list34.png',  label: 'ฟันหลุดจากอุบัติเหตุ',                      category: 9),
    _ServiceItem(imgPath: '${_iconBase}list11.png',  label: 'ริมฝีปาก / เหงือกฉีกขาดจากการกระแทก',       category: 9),

    // --- 10: ฟันปลอม / รากฟันเทียม / ครอบฟัน ---
    _ServiceItem(imgPath: '${_iconBase}list35.png',  label: 'ฟันปลอมหลวม / ไม่กระชับ',                   category: 10),
    _ServiceItem(imgPath: '${_iconBase}list35.png',  label: 'ครอบฟันหลุด / แตก',                         category: 10),
    _ServiceItem(imgPath: '${_iconBase}list39.png',  label: 'รากเทียมมีปัญหา',                            category: 10),

    // --- 11: เด็ก / ฟันน้ำนม ---
    _ServiceItem(imgPath: '${_iconBase}list30.png',  label: 'ฟันน้ำนมผุ',                                 category: 11),
    _ServiceItem(imgPath: '${_iconBase}list40.png',  label: 'ฟันน้ำนมไม่หลุดตามวัย',                     category: 11),

    // --- อื่นๆ (ทั้งหมด) ---
    _ServiceItem(imgPath: '${_iconBase}list13.png',  label: 'อื่นๆ',                                      category: 0),
  ];

  List<_ServiceItem> get _filtered {
    final byCategory = _selectedFilter == 0
        ? _allServices
        : _allServices.where((s) => s.category == _selectedFilter).toList();
    if (_searchQuery.isEmpty) return byCategory;
    return byCategory.where((s) => s.label.contains(_searchQuery)).toList();
  }

  // รายการไม่รวม "อื่นๆ"
  List<_ServiceItem> get _filteredGrid =>
      _filtered.where((s) => s.label != 'อื่นๆ').toList();

  // มี "อื่นๆ" ใน filtered หรือไม่
  bool get _showOther =>
      _filtered.any((s) => s.label == 'อื่นๆ');

  @override
  void dispose() {
    _searchController.dispose();
    _otherDetailController.dispose();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // ---- AppBar ----
            AppBarBack(
              title: 'เลือกบริการ',
              onBack: widget.onBack,
            ),

            SizedBox(height: context.rs(18)),

            // ---- Search Bar ----
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() {
                  _searchQuery = v;
                  _selectedIndexes.clear();
                }),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(14),
                  color: AppColors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'ค้นหาบริการ',
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
                  contentPadding:
                      EdgeInsets.symmetric(vertical: context.rs(10)),
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

            SizedBox(height: context.rs(15)),

            // ---- Filter Chips ----
            SizedBox(
              height: context.rs(32),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding:
                    EdgeInsets.symmetric(horizontal: context.rs(24)),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => SizedBox(width: context.rs(8)),
                itemBuilder: (context, i) {
                  final selected = _selectedFilter == i;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedFilter = i;
                      _selectedIndexes.clear();
                    }),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.rs(14),
                        vertical: context.rs(5),
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.orange
                            : Colors.white,
                        border: selected
                            ? null
                            : Border.all(
                                color: Colors.black.withOpacity(0.20),
                                width: 1,
                              ),
                        borderRadius:
                            BorderRadius.circular(context.rs(20)),
                      ),
                      child: Center(
                        child: Text(
                          _filters[i],
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(11),
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: selected
                                ? AppColors.white
                                : AppColors.textGray,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: context.rs(12)),

            // ---- Grid ----
            Expanded(
              child: _filteredGrid.isEmpty && !_showOther
                  ? Center(
                      child: Text(
                        'ไม่พบบริการที่ค้นหา',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(13),
                          color: AppColors.textGray,
                        ),
                      ),
                    )
                  : ListView(
                      padding: EdgeInsets.fromLTRB(
                        context.rs(24),
                        0,
                        context.rs(24),
                        (_selectedIndexes.isNotEmpty || _otherSelected)
                            ? context.rs(48 + 48 + 12) // เผื่อพื้นที่ปุ่มถัดไป
                            : context.rs(24),
                      ),
                      children: [
                        // --- Grid ของ items รวม อื่นๆ ---
                        if (_filteredGrid.isNotEmpty || _showOther)
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final spacing = context.rs(10);
                              final cardWidth =
                                  (constraints.maxWidth - spacing) / 2;

                              final allItems = [
                                ..._filteredGrid.asMap().entries.map(
                                    (e) => _GridItem.service(e.key, e.value)),
                                if (_showOther) _GridItem.other(),
                              ];

                              final rows = <List<_GridItem>>[];
                              for (var i = 0; i < allItems.length; i += 2) {
                                rows.add([
                                  allItems[i],
                                  if (i + 1 < allItems.length) allItems[i + 1],
                                ]);
                              }

                              return Column(
                                children: [
                                  ...rows.map((row) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.only(bottom: spacing),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: row.map((gridItem) {
                                            Widget card;
                                            if (gridItem.isOther) {
                                              card = _OtherCard(
                                                isSelected: _otherSelected,
                                                onTap: () => setState(() =>
                                                    _otherSelected =
                                                        !_otherSelected),
                                              );
                                            } else {
                                              final i = gridItem.index!;
                                              final isSelected =
                                                  _selectedIndexes.contains(i);
                                              card = _ServiceCard(
                                                item: _filteredGrid[i],
                                                isSelected: isSelected,
                                                onTap: () => setState(() {
                                                  if (isSelected) {
                                                    _selectedIndexes.remove(i);
                                                  } else {
                                                    _selectedIndexes.add(i);
                                                  }
                                                }),
                                              );
                                            }
                                            return SizedBox(
                                                width: cardWidth, child: card);
                                          }).toList()
                                            ..insertAll(
                                              1,
                                              row.length > 1
                                                  ? [SizedBox(width: spacing)]
                                                  : [],
                                            ),
                                        ),
                                      ),
                                    );
                                  }),
                                  // ---- TextField สำหรับ อื่นๆ ----
                                  if (_otherSelected)
                                    TextField(
                                      controller: _otherDetailController,
                                      maxLines: 3,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: context.rs(12),
                                        color: AppColors.black,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'ระบุรายละเอียดอาการ...',
                                        hintStyle: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: context.rs(12),
                                          color: AppColors.inputHint,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: context.rs(10),
                                          vertical: context.rs(8),
                                        ),
                                        filled: true,
                                        fillColor: AppColors.homeBackground,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(context.rs(12)),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(context.rs(12)),
                                          borderSide: const BorderSide(
                                              color: AppColors.orange,
                                              width: 1.5),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
            ),
          ],
        ),

            // ---- ปุ่มถัดไป (ลอย) ----
            if (_selectedIndexes.isNotEmpty || _otherSelected)
              Positioned(
                left: context.rs(24),
                right: context.rs(24),
                bottom: context.rs(48),
                child: GestureDetector(
                  onTap: () {
                    // TODO: navigate to next step
                  },
                  child: Container(
                    height: context.rs(40),
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.circular(context.rs(30)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x40000000),
                          offset: Offset(0, -2),
                          blurRadius: 2,
                        ),
                        BoxShadow(
                          color: Color(0x40000000),
                          offset: Offset(0, 2),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'ถัดไป',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(15),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
// Data class
// ============================================================
class _ServiceItem {
  const _ServiceItem({
    required this.imgPath,
    required this.label,
    required this.category, // 0=ทั้งหมด, 1=ป้องกัน, 2=บูรณะ, 3=ศัลยกรรม, 4=ประดิษฐ์
  });

  final String imgPath;
  final String label;
  final int category; // 0=ทั้งหมด/อื่นๆ, 1=ปวดฟัน/เสียวฟัน, 2=ฟันผุ/โครงสร้างฟัน, 3=เหงือก/ปริทันต์
                      // 4=กลิ่นปาก, 5=การเรียงฟัน/การสบฟัน, 6=สี/ผิวฟัน, 7=ขากรรไกร/TMJ
                      // 8=เนื้อเยื่ออ่อน/แผลในปาก, 9=อุบัติเหตุ/บาดเจ็บ, 10=ฟันปลอม/รากเทียม/ครอบฟัน, 11=เด็ก/ฟันน้ำนม
}

// ============================================================
// _GridItem — helper สำหรับรวม service card และ other card ใน grid
// ============================================================
class _GridItem {
  final int? index;
  final bool isOther;

  const _GridItem.service(this.index, _) : isOther = false;
  const _GridItem.other()
      : index = null,
        isOther = true;
}

// ============================================================
// Other Card — full-width, แสดง TextField เมื่อ selected
// ============================================================
class _OtherCard extends StatelessWidget {
  const _OtherCard({
    required this.isSelected,
    required this.onTap,
  });

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(context.rs(16)),
          border: Border.all(
            color: isSelected ? AppColors.orange : AppColors.black20,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            // ---- Main content ----
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.rs(10),
                context.rs(10),
                context.rs(10),
                context.rs(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ---- Icon ----
                  Center(
                    child: Image.asset(
                      'assets/images/Book_an_appointment/list_of_symptoms/list13.png',
                      width: context.rs(30),
                      height: context.rs(30),
                    ),
                  ),
                  SizedBox(height: context.rs(8)),
                  // ---- Label ----
                  Text(
                    'อื่นๆ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(12),
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            // ---- Checkbox — top left ----
            Positioned(
              top: context.rs(8),
              left: context.rs(8),
              child: GestureDetector(
                onTap: onTap,
                child: isSelected
                    ? SvgPicture.asset(
                        'assets/images/Book_an_appointment/checkmarklist.svg',
                        width: context.rs(13),
                        height: context.rs(13),
                      )
                    : SvgPicture.asset(
                        'assets/images/Book_an_appointment/el_plus-sign.svg',
                        width: context.rs(13),
                        height: context.rs(13),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
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
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(context.rs(16)),
          border: Border.all(
            color: isSelected ? AppColors.orange : AppColors.black20,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Stack(
          children: [
            // ---- Main content: emoji + label ----
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.rs(10),
                context.rs(10),
                context.rs(10),
                context.rs(10),
              ),
              child: Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // PNG Icon
                  Image.asset(
                    item.imgPath,
                    width: context.rs(31),
                    height: context.rs(31),
                  ),

                  SizedBox(height: context.rs(15)),

                  // Label — ชิดล่าง
                  Text(
                    item.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(12),
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                ),
              ),
            ),

            // ---- Checkbox circle — top left ----
            Positioned(
              top: context.rs(8),
              left: context.rs(8),
              child: GestureDetector(
                onTap: onTap,
                child: isSelected
                    ? SvgPicture.asset(
                        'assets/images/Book_an_appointment/checkmarklist.svg',
                        width: context.rs(13),
                        height: context.rs(13),
                      )
                    : SvgPicture.asset(
                        'assets/images/Book_an_appointment/el_plus-sign.svg',
                        width: context.rs(13),
                        height: context.rs(13),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
