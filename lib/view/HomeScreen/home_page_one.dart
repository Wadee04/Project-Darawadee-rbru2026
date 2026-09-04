import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';
import 'home_page_three.dart';

// ============================================================
// หน้าหลักตอนที่ยังไม่ได้เลือกคลินิก 
// ============================================================
class ClinicItem {
  const ClinicItem({
    required this.name,
    required this.province,
    this.logoAsset,
  });
  final String name;
  final String province;
  final String? logoAsset;
}

// ============================================================
// ฟังก์ชันแสดง Bottom Sheet เลือกคลินิก
// ============================================================
void showSelectClinicSheet(
  BuildContext context, {
  void Function(ClinicItem)? onSelect,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _SelectClinicSheet(onSelect: onSelect),
  );
}

class _SelectClinicSheet extends StatefulWidget {
  const _SelectClinicSheet({this.onSelect});
  final void Function(ClinicItem)? onSelect;

  @override
  State<_SelectClinicSheet> createState() => _SelectClinicSheetState();
}

class _SelectClinicSheetState extends State<_SelectClinicSheet> {
  // ข้อมูลตัวอย่างคลินิก
  static const List<ClinicItem> _allClinics = [
    ClinicItem(
      name: 'คลินิกทันตกรรมฟันเดย์',
      province: 'จันทบุรี',
      logoAsset: 'assets/images/homescreen/dental_funday.png',
    ),
    ClinicItem(
      name: 'คลินิกทันตกรรมมีใจ',
      province: 'กรุงเทพมหานคร',
      logoAsset: 'assets/images/homescreen/dental_meejai.png',
    ),
    ClinicItem(
      name: 'คลินิกทันตกรรมโรงพยาบาลกรุงเทพจันทบุรี',
      province: 'กรุงเทพมหานคร',
      logoAsset: 'assets/images/homescreen/dental_bangkok.png',
    ),
    ClinicItem(name: 'คลินิกทันตกรรมสไมล์', province: 'กรุงเทพมหานคร'),
    ClinicItem(name: 'คลินิกทันตกรรมสไมล์', province: 'กรุงเทพมหานคร'),
    ClinicItem(name: 'คลินิกทันตกรรมสไมล์', province: 'กรุงเทพมหานคร'),
    ClinicItem(name: 'คลินิกทันตกรรมสไมล์', province: 'กรุงเทพมหานคร'),
    ClinicItem(name: 'คลินิกทันตกรรมสไมล์', province: 'กรุงเทพมหานคร'),
  ];

  static const List<String> _provinces = [
    'ทุกจังหวัด',
    'กรุงเทพมหานคร',
    'จันทบุรี',
    'เชียงใหม่',
    'ภูเก็ต',
  ];

  String _searchQuery = '';
  String _selectedProvince = 'ทุกจังหวัด';
  final TextEditingController _searchCtrl = TextEditingController();

  List<ClinicItem> get _filtered {
    return _allClinics.where((c) {
      final matchName =
          _searchQuery.isEmpty || c.name.contains(_searchQuery);
      final matchProv = _selectedProvince == 'ทุกจังหวัด' ||
          c.province == _selectedProvince;
      return matchName && matchProv;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double sheetHeight =
        MediaQuery.of(context).size.height * 0.82;

    return Container(
      height: sheetHeight,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.rs(24)),
        ),
      ),
      child: Column(
        children: [
          // ---- Drag handle ----
          Padding(
            padding: EdgeInsets.only(
              top: context.rs(12),
              bottom: context.rs(16),
            ),
            child: Container(
              width: context.rs(40),
              height: context.rs(4),
              decoration: BoxDecoration(
                color: AppColors.inputBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ---- Search bar ----
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.rs(20)),
            child: Container(
              height: context.rs(44),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(context.rs(30)),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Row(
                children: [
                  SizedBox(width: context.rs(12)),
                  Icon(
                    Icons.search,
                    size: context.rs(18),
                    color: AppColors.inputHint,
                  ),
                  SizedBox(width: context.rs(8)),
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (v) =>
                          setState(() => _searchQuery = v),
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
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: context.rs(12)),

          // ---- Province dropdown ----
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.rs(20)),
            child: Container(
              height: context.rs(44),
              padding: EdgeInsets.symmetric(horizontal: context.rs(14)),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(context.rs(9)),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedProvince,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: context.rs(20),
                    color: AppColors.textGray,
                  ),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(13),
                    color: AppColors.black,
                  ),
                  items: _provinces
                      .map(
                        (p) => DropdownMenuItem(
                          value: p,
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: context.rs(16),
                                color: AppColors.purple,
                              ),
                              SizedBox(width: context.rs(6)),
                              Text(p),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _selectedProvince = v);
                    }
                  },
                ),
              ),
            ),
          ),

          SizedBox(height: context.rs(16)),

          // ---- Section title ----
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.rs(20)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ทั้งหมด',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(13),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),
          ),

          SizedBox(height: context.rs(8)),

          // ---- Clinic list ----
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: context.rs(20),
                vertical: context.rs(4),
              ),
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final clinic = _filtered[i];
                return _ClinicTile(
                  clinic: clinic,
                  onTap: () {
                    Navigator.pop(context);
                    widget.onSelect?.call(clinic);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _ClinicTile — แต่ละแถวของคลินิกใน Bottom Sheet
// ============================================================
class _ClinicTile extends StatelessWidget {
  const _ClinicTile({required this.clinic, this.onTap});
  final ClinicItem clinic;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: context.rs(6)),
        padding: EdgeInsets.symmetric(
          horizontal: context.rs(12),
          vertical: context.rs(10),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 2,
              spreadRadius: 0,
              offset: const Offset(0, -1),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 2,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Logo หรือ placeholder
            Container(
              width: context.rs(44),
              height: context.rs(44),
              decoration: BoxDecoration(
                color: AppColors.registerButton,
                borderRadius: BorderRadius.circular(context.rs(10)),
              ),
              clipBehavior: Clip.antiAlias,
              child: clinic.logoAsset != null
                  ? Image.asset(
                      clinic.logoAsset!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, e, s) =>
                          _placeholder(context),
                    )
                  : _placeholder(context),
            ),
            SizedBox(width: context.rs(12)),
            // ชื่อและจังหวัด
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clinic.name,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(13),
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: context.rs(2)),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: context.rs(11),
                        color: AppColors.textGray,
                      ),
                      SizedBox(width: context.rs(2)),
                      Text(
                        clinic.province,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(11),
                          color: AppColors.textGray,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: context.rs(18),
              color: AppColors.textGray,
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        'assets/images/homescreen/toothpopup.svg',
        width: context.rs(24),
        height: context.rs(24),
      ),
    );
  }
}

// ============================================================
// HomePage - หน้าหลัก(ไม่มีการนัดหมาย)
// ============================================================
class HomePageOne extends StatefulWidget {
  const HomePageOne({
    super.key,
    this.userName = 'คุณดาราวดี อาลัย',
    this.onNotification,
    this.onProfile,
    this.onSelectClinic,
    this.onBooking,
    this.onMyQueue,
  });

  final String userName;
  final VoidCallback? onNotification;
  final VoidCallback? onProfile;
  final VoidCallback? onSelectClinic;
  final VoidCallback? onBooking;
  final VoidCallback? onMyQueue;

  @override
  State<HomePageOne> createState() => _HomePageOneState();
}

class _HomePageOneState extends State<HomePageOne> {
  int _navIndex = 0;
  ClinicItem? _selectedClinic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  context.rs(20),
                  MediaQuery.of(context).size.height * 0.05,
                  context.rs(20),
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---- Header row ----
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Greeting
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'สวัสดีตอนบ่าย',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: context.rs(14),
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textGray,
                                ),
                              ),
                              SizedBox(height: context.rs(2)),
                              Text(
                                widget.userName,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: context.rs(16),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.purple,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Icons
                        Row(
                          children: [
                            _IconBtn(
                              svgAsset: 'assets/images/homescreen/bell.svg',
                              onTap: widget.onNotification,
                              width: 15,
                              height: 17,
                            ),
                            SizedBox(width: context.rs(25)),
                            _IconBtn(
                              svgAsset: 'assets/images/homescreen/contact.svg',
                              onTap: widget.onProfile,
                              width: 20,
                              height: 18.16,
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: context.rs(10)),

                    // ---- Location bar ----
                    GestureDetector(
                      onTap: () {
                        showSelectClinicSheet(context, onSelect: (clinic) {
                          setState(() => _selectedClinic = clinic);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomePageThree(
                                clinicName: clinic.name,
                                clinicProvince: clinic.province,
                              ),
                            ),
                          );
                          widget.onSelectClinic?.call();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          top: context.rs(8),
                          bottom: context.rs(8),
                        ),
                         decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius:
                              BorderRadius.circular(context.rs(10)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: context.rs(32),
                              height: context.rs(32),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius:
                                    BorderRadius.circular(context.rs(10)),
                                border: Border.all(
                                  color: AppColors.inputBorder,
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.location_on,
                                size: context.rs(16),
                                color: AppColors.purple,
                              ),
                            ),
                            SizedBox(width: context.rs(6)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedClinic?.name ?? 'ยังไม่ได้เลือกคลินิก',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: context.rs(14),
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.black60,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        _selectedClinic != null
                                            ? _selectedClinic!.province
                                            : 'กรุณาเลือกคลินิก เพื่อเริ่มใช้งาน',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: context.rs(11),
                                          color: AppColors.black60,
                                        ),
                                      ),
                                      SizedBox(width: context.rs(6)),
                                      Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: context.rs(15),
                                        color: AppColors.textGray,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: context.rs(10)),

                    // ---- Appointment card ----
                    _AppointmentCard(),

                    SizedBox(height: context.rs(20)),

                    // ---- บริการแนะนำ ----
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: context.rs(20),
                          decoration: BoxDecoration(
                            color: AppColors.purple,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(width: context.rs(8)),
                        Text(
                          'บริการแนะนำ',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(15),
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.rs(13)),
                    Row(
                      children: [
                        Expanded(
                          child: _ServiceCard(
                            svgAsset: 'assets/images/homescreen/check_up.svg',
                            label: 'ตรวจสุขภาพฟัน',
                            onTap: widget.onBooking,
                          ),
                        ),
                        SizedBox(width: context.rs(10)),
                        Expanded(
                          child: _ServiceCard(
                            svgAsset: 'assets/images/homescreen/teeth_scaling.svg',
                            label: 'ขูดหินปูน',
                            onTap: widget.onBooking,
                          ),
                        ),
                        SizedBox(width: context.rs(10)),
                        Expanded(
                          child: _ServiceCard(
                            svgAsset: 'assets/images/homescreen/tooth_ filling.svg',
                            label: 'อุดฟัน',
                            onTap: widget.onBooking,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: context.rs(24)),
                  ],
                ),
              ),
            ),

            // ---- Bottom Navigation ----
            _BottomNav(
              currentIndex: _navIndex,
              onTap: (i) {
                setState(() => _navIndex = i);
                if (i == 1) widget.onBooking?.call();
                if (i == 2) widget.onMyQueue?.call();
                if (i == 3) widget.onProfile?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _IconBtn — ปุ่ม icon วงกลมใน header
// ============================================================
class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.svgAsset,
    this.onTap,
    this.width = 20,
    this.height = 20,
  });
  final String svgAsset;
  final VoidCallback? onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        svgAsset,
        width: context.rs(width),
        height: context.rs(height),
        colorFilter: const ColorFilter.mode(
          Color(0xB3000000),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

// ============================================================
// _AppointmentCard — card นัดหมาย (gradient ม่วง)
// ============================================================
class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(20),
        vertical: context.rs(20),
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.cardAppointment1,
            AppColors.cardAppointment2,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon ปฏิทิน
          Container(
            width: context.rs(40),
            height: context.rs(40),
            decoration: BoxDecoration(
              color: AppColors.registerButton,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/homescreen/calender.svg',
                width: context.rs(26),
                height: context.rs(26),
                colorFilter: const ColorFilter.mode(AppColors.purple, BlendMode.srcIn),
              ),
            ),
          ),
          SizedBox(height: context.rs(12)),
          Text(
            'ยังไม่มีการนัดหมาย',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(16),
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: context.rs(4)),
          Text(
            'เมื่อคุณเลือกคลินิกแล้ว\nการนัดหมายของคุณจะแสดงที่นี่',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(14),
              fontWeight: FontWeight.w400,
              color: AppColors.white.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _ServiceCard — card บริการแนะนำ
// ============================================================
class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.svgAsset,
    required this.label,
    this.onTap,
  });

  final String svgAsset;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: context.rs(16),
          horizontal: context.rs(8),
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(context.rs(14)),
          border: Border.all(color: AppColors.introductioncard, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgAsset,
              width: context.rs(16),
              height: context.rs(16),
              colorFilter: ColorFilter.mode(AppColors.black, BlendMode.srcIn),
            ),
            SizedBox(height: context.rs(8)),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(12),
                fontWeight: FontWeight.w500,
                color: AppColors.black,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _BottomNav — Bottom Navigation Bar
// ============================================================
class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final List<_NavItem> items = const [
      _NavItem(svgPath: 'assets/images/homescreen/homepage.svg', label: 'หน้าหลัก'),
      _NavItem(svgPath: 'assets/images/homescreen/book_an_appointment.svg', label: 'จองคิว'),
      _NavItem(svgPath: 'assets/images/homescreen/queue_of.svg', label: 'คิวของฉัน'),
      _NavItem(svgPath: 'assets/images/homescreen/profile.svg', label: 'โปรไฟล์'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: context.rs(12),
        bottom: context.rs(15),
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final bool active = i == currentIndex;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    items[i].svgPath,
                    width: context.rs(24),
                    height: context.rs(24),
                    colorFilter: ColorFilter.mode(
                      active
                          ? AppColors.orange
                          : AppColors.black50,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(height: context.rs(4)),
                  Text(
                    items[i].label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(10),
                      fontWeight:
                          active ? FontWeight.w600 : FontWeight.w400,
                      color: active
                          ? AppColors.orange
                          : AppColors.black50,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.svgPath,
    required this.label,
  });
  final String svgPath;
  final String label;
}
