import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

// ============================================================
// BookAnAppointmentFour - หน้าเลือกบริการ (ทราบสาเหตุแล้ว)
// ============================================================
class BookAnAppointmentFour extends StatefulWidget {
  const BookAnAppointmentFour({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  State<BookAnAppointmentFour> createState() => _BookAnAppointmentFourState();
}

class _BookAnAppointmentFourState extends State<BookAnAppointmentFour> {
  final _searchController = TextEditingController();
  final _otherDetailController = TextEditingController();
  String _searchQuery = '';
  int _selectedFilter = 0;
  final Set<int> _selectedIndexes = {};
  bool _otherSelected = false;

  // ---- Filter labels ----
  static const List<String> _filters = [
    'ทั้งหมด',
    'ทันตกรรมป้องกัน',
    'ทันตกรรมบูรณะ',
    'ศัลยกรรมช่องปาก',
    'ทันตกรรมประดิษฐ์',
    'ทันตกรรมจัดฟัน',
    'รักษาโรคเหงือก / ปริทันต์',
    'ทันตกรรมเด็ก',
  ];

  static const String _imgBase =
      'assets/images/Book_an_appointment/list_of_services/';

  // ---- Service list ----
  // category: 0=อื่นๆ, 1=ทันตกรรมป้องกัน, 2=ทันตกรรมบูรณะ, 3=ศัลยกรรมช่องปาก,
  //           4=ทันตกรรมประดิษฐ์, 5=ทันตกรรมจัดฟัน, 6=รักษาโรคเหงือก/ปริทันต์, 7=ทันตกรรมเด็ก
  static const List<_ServiceItem> _allServices = [
    // 1: ทันตกรรมป้องกัน — ตรวจ, ทำความสะอาด, เคลือบป้องกัน
    _ServiceItem(imgPath: '${_imgBase}listservice1.png',  label: 'ตรวจฟัน + X-ray',                   subLabel: 'ฟรี - 500 บาท',              duration: '30 นาที', category: 1),
    _ServiceItem(imgPath: '${_imgBase}listservice3.png',  label: 'ขูดหินปูน',        subLabel: '500 - 1500 บาท',              duration: '45 นาที', category: 1),
    _ServiceItem(imgPath: '${_imgBase}listservice4.png',  label: 'เคลือบฟลูออไรด์ / หลุมร่องฟัน',    subLabel: '200 - 500 บาท/ซี่',           duration: '15 นาที', category: 1),

    // 2: ทันตกรรมบูรณะ — อุด, รักษาราก, ครอบ
    _ServiceItem(imgPath: '${_imgBase}listservice5.png',  label: 'อุดฟัน',                             subLabel: '1000 - 2000 บาท/ซี่',         duration: '30 นาที', category: 2),
    _ServiceItem(imgPath: '${_imgBase}listservice6.png',  label: 'รักษารากฟัน',                        subLabel: '4000 - 12000 บาท',            duration: '45 นาที', category: 2),
    _ServiceItem(imgPath: '${_imgBase}listservice7.png',  label: 'ทำครอบฟัน',                          subLabel: '8000 - 20000 บาท/ซี่',        duration: '60 นาที', category: 2),

    // 3: ศัลยกรรมช่องปาก — ถอน, ผ่า, ฝังราก
    _ServiceItem(imgPath: '${_imgBase}listservice8.png',  label: 'ถอนฟันธรรมดา',                      subLabel: '500 - 1500 บาท',              duration: '30 นาที', category: 3),
    _ServiceItem(imgPath: '${_imgBase}listservice9.png',  label: 'ผ่าฟันคุด',                          subLabel: '1500 - 5000 บาท',             duration: '90 นาที', category: 3),
    _ServiceItem(imgPath: '${_imgBase}listservice10.png', label: 'รากฟันเทียม (ฝังราก)',               subLabel: '30000 - 80000 บาท/ซี่',       duration: '60 นาที', category: 3),

    // 4: ทันตกรรมประดิษฐ์ — ฟันปลอม, ครอบ, วีเนียร์
    _ServiceItem(imgPath: '${_imgBase}listservice11.png', label: 'ฟันปลอมทั้งปาก / บางส่วน',          subLabel: '2000 - 20000 บาท',            duration: '60 นาที', category: 4),
    _ServiceItem(imgPath: '${_imgBase}listservice12.png', label: 'พิมพ์ปาก + X-ray',                   subLabel: '1800 - 2600 บาท',             duration: '60 นาที', category: 4),
    _ServiceItem(imgPath: '${_imgBase}listservice17.png', label: 'วีเนียร์คอมโพสิต',                   subLabel: '2000 - 5000 บาท/ซี่',         duration: '90 นาที', category: 4),
    _ServiceItem(imgPath: '${_imgBase}listservice18.png', label: 'วีเนียร์พอร์ซเลน',                   subLabel: '12000 - 25000 บาท/ซี่',       duration: '90 นาที', category: 4),

    // 5: ทันตกรรมจัดฟัน — จัดฟันทุกประเภท
    _ServiceItem(imgPath: '${_imgBase}listservice13.png', label: 'จัดฟันโลหะ (เต็มคอร์ส)',             subLabel: '30000 - 80000 บาท',           duration: '30 นาที', category: 5),
    _ServiceItem(imgPath: '${_imgBase}listservice14.png', label: 'จัดฟันดามอน / เซรามิก',              subLabel: '50000 - 100000 บาท',          duration: '30 นาที', category: 5),
    _ServiceItem(imgPath: '${_imgBase}listservice13.png', label: 'Invisalign',                           subLabel: '60000 - 150000 บาท',          duration: '30 นาที', category: 5),

    // 6: รักษาโรคเหงือก / ปริทันต์ — รักษาเหงือก, ฟอกสีฟัน
    _ServiceItem(imgPath: '${_imgBase}listservice1.png',  label: 'รักษาโรคเหงือก / ปริทันต์',          subLabel: 'หลักพัน - หลักหมื่น บาท',     duration: '45 นาที', category: 6),
    _ServiceItem(imgPath: '${_imgBase}listservice16.png', label: 'ฟอกสีฟัน',                           subLabel: '3500 - 6000 บาท',             duration: '45 นาที', category: 6),

    // 7: ทันตกรรมเด็ก — บริการสำหรับเด็กและฟันน้ำนม
    _ServiceItem(imgPath: '${_imgBase}listservice7.png',  label: 'ตรวจฟันเด็ก / วางแผน',              subLabel: '0 - 500 บาท',                 duration: '30 นาที', category: 7),
    _ServiceItem(imgPath: '${_imgBase}listservice8.png',  label: 'เคลือบฟลูออไรด์เด็ก',               subLabel: '200 - 500 บาท',               duration: '15 นาที', category: 7),
    _ServiceItem(imgPath: '${_imgBase}listservice2.png',  label: 'อุดฟันน้ำนม',                        subLabel: '500 - 1500 บาท/ซี่',          duration: '30 นาที', category: 7),
    _ServiceItem(imgPath: '${_imgBase}listservice3.png',  label: 'รักษารากฟันน้ำนม',                   subLabel: '1500 - 3500 บาท/ซี่',         duration: '45 นาที', category: 7),

    // อื่นๆ
    _ServiceItem(imgPath: '${_imgBase}listservice7.png',  label: 'อื่นๆ',                               subLabel: '',                            duration: '', category: 0),
  ];

  List<_ServiceItem> get _filtered {
    final byCategory = _selectedFilter == 0
        ? _allServices
        : _allServices.where((s) => s.category == _selectedFilter).toList();
    if (_searchQuery.isEmpty) return byCategory;
    return byCategory
        .where((s) =>
            s.label.contains(_searchQuery) ||
            s.subLabel.contains(_searchQuery))
        .toList();
  }

  List<_ServiceItem> get _filteredGrid =>
      _filtered.where((s) => s.label != 'อื่นๆ').toList();

  bool get _showOther => _filtered.any((s) => s.label == 'อื่นๆ');

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
                  padding:
                      EdgeInsets.symmetric(horizontal: context.rs(24)),
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
                        borderRadius:
                            BorderRadius.circular(context.rs(24)),
                        borderSide:
                            BorderSide(color: AppColors.black20, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(context.rs(24)),
                        borderSide:
                            BorderSide(color: AppColors.black20, width: 1),
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
                    padding: EdgeInsets.symmetric(
                        horizontal: context.rs(24)),
                    itemCount: _filters.length,
                    separatorBuilder: (_, x) =>
                        SizedBox(width: context.rs(8)),
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
                                    color: Colors.black.withValues(alpha: 0.20),
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
                                ? context.rs(48 + 48 + 12)
                                : context.rs(24),
                          ),
                          children: [
                            if (_filteredGrid.isNotEmpty)
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final spacing = context.rs(10);
                                  final cardWidth =
                                      (constraints.maxWidth - spacing) / 2;

                                  // รวม _filteredGrid + การ์ดอื่นๆ (ถ้ามี)
                                  final allItems = [
                                    ..._filteredGrid.asMap().entries.map((e) =>
                                        _GridItem.service(e.key, e.value)),
                                    if (_showOther) _GridItem.other(),
                                  ];

                                  final rows = <List<_GridItem>>[];
                                  for (var i = 0; i < allItems.length; i += 2) {
                                    rows.add([
                                      allItems[i],
                                      if (i + 1 < allItems.length)
                                        allItems[i + 1],
                                    ]);
                                  }

                                  return Column(
                                    children: [
                                      ...rows.map((row) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              bottom: spacing),
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
                                                      _selectedIndexes
                                                          .contains(i);
                                                  card = _ServiceCard(
                                                    item: _filteredGrid[i],
                                                    isSelected: isSelected,
                                                    onTap: () => setState(() {
                                                      if (isSelected) {
                                                        _selectedIndexes
                                                            .remove(i);
                                                      } else {
                                                        _selectedIndexes.add(i);
                                                      }
                                                    }),
                                                  );
                                                }
                                                return SizedBox(
                                                    width: cardWidth,
                                                    child: card);
                                              }).toList()
                                                ..insertAll(
                                                  1,
                                                  row.length > 1
                                                      ? [
                                                          SizedBox(
                                                              width: spacing)
                                                        ]
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
                                            hintText:
                                                'ระบุรายละเอียดบริการที่ต้องการ...',
                                            hintStyle: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: context.rs(12),
                                              color: AppColors.inputHint,
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: context.rs(10),
                                              vertical: context.rs(8),
                                            ),
                                            filled: true,
                                            fillColor:
                                                AppColors.homeBackground,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      context.rs(12)),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      context.rs(12)),
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
                      color: AppColors.orange,
                      borderRadius:
                          BorderRadius.circular(context.rs(30)),
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
    required this.subLabel,
    required this.duration,
    required this.category,
  });

  final String imgPath;
  final String label;
  final String subLabel;
  final String duration;
  final int category; // 0=อื่นๆ, 1=ป้องกัน, 2=บูรณะ, 3=ศัลยกรรมช่องปาก, 4=ประดิษฐ์, 5=จัดฟัน, 6=เหงือก/ปริทันต์, 7=เด็ก
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
// _OtherCard — full-width, แสดง TextField เมื่อ selected
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
                      'assets/images/Book_an_appointment/list_of_services/listservice7.png',
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

// ============================================================
// _ServiceCard
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
                  // ---- Icon (centered) ----
                  Container(
                    child: Center(
                      child: Image.asset(
                        item.imgPath,
                        width: context.rs(30),
                        height: context.rs(30),
                      ),
                    ),
                  ),

                  SizedBox(height: context.rs(10)),

                  // ---- Service name ----
                  Text(
                    item.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(12),
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(), // ดัน price ลงล่าง

                  // ---- Bottom row: price ----
                  if (item.subLabel.isNotEmpty) ...[
                    SizedBox(height: context.rs(3)),
                    Text(
                      item.subLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(12),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textGray,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
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

            // ---- Duration badge — top right ----
            if (item.duration.isNotEmpty)
              Positioned(
                top: context.rs(8),
                right: context.rs(8),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.rs(6),
                    vertical: context.rs(2),
                  ),
                  child: Text(
                    item.duration,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(10),
                      fontWeight: FontWeight.w400,
                      color: AppColors.textGray,
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
