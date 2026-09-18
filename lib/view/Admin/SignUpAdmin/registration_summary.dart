import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/supabase_admin_service.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// RegistrationSummaryPage — หน้าสรุปข้อมูลการลงทะเบียน
// ============================================================
class RegistrationSummaryPage extends StatefulWidget {
  const RegistrationSummaryPage({
    super.key,
    this.onBack,
    this.onConfirm,
    // ข้อมูลส่วนตัว
    this.fullName = 'นางสาวดาราวดี อาลัย',
    this.email = '6614631011@rbru.ac.th',
    this.phone = '091-0156190',
    this.password = '',
    // ข้อมูลคลินิก
    this.clinicName = 'คลินิกทันตกรรมใจ๋',
    this.clinicEmail = 'admin@dental.com',
    this.clinicMapLink = 'https://maps.goo.gl/WLr8cxp25gHYFFf19',
    this.clinicAddress = 'เลขที่ 12/3 หมู่ที่ 4 ตามกำหาจำหน',
    this.province = 'จันทบุรี',
    this.district = 'เมือง',
    this.zipCode = '22000',
    this.registrationNumber = '',
    this.operatingHours = '',
  });

  final VoidCallback? onBack;
  final VoidCallback? onConfirm;

  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String clinicName;
  final String clinicEmail;
  final String clinicMapLink;
  final String clinicAddress;
  final String province;
  final String district;
  final String zipCode;
  final String registrationNumber;
  final String operatingHours;

  @override
  State<RegistrationSummaryPage> createState() =>
      _RegistrationSummaryPageState();
}

class _RegistrationSummaryPageState extends State<RegistrationSummaryPage> {
  bool _isSaving = false;

  Future<void> _handleConfirm() async {
    setState(() => _isSaving = true);
    try {
      await SupabaseAdminService.instance.registerAdmin(
        fullName: widget.fullName,
        email: widget.email,
        phone: widget.phone,
        password: widget.password,
        clinicName: widget.clinicName,
        registrationNumber: widget.registrationNumber.isNotEmpty ? widget.registrationNumber : null,
        operatingHours: widget.operatingHours.isNotEmpty ? widget.operatingHours : null,
        address: widget.clinicAddress.isNotEmpty ? widget.clinicAddress : null,
        province: widget.province.isNotEmpty ? widget.province : null,
        district: widget.district.isNotEmpty ? widget.district : null,
        zipCode: widget.zipCode.isNotEmpty ? widget.zipCode : null,
      );
      widget.onConfirm?.call();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ลงทะเบียนสำเร็จ กรุณารอการอนุมัติ')),
        );
      }
    } on AuthException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFFFFFFF), Color(0xFFC5DEE8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- Back button ----
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: onBack ?? () => Navigator.maybePop(context),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.rs(16),
                      MediaQuery.of(context).size.height * 0.01,
                      context.rs(16),
                      0,
                    ),
                    child: Icon(
                      Icons.chevron_left,
                      size: context.rs(28),
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),

              // ---- Body ----
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.rs(20),
                    context.rs(16),
                    context.rs(20),
                    context.rs(32),
                  ),
                  child: Column(
                    children: [
                      // ---- Hero Banner ----
                      _HeroBanner(),

                      SizedBox(height: context.rs(20)),

                      // ---- Summary Card ----
                      _SummaryCard(
                        title: 'ข้อมูลการลงทะเบียน',
                        rows: [
                          _SummaryRow(
                            icon: Icons.person_outline,
                            label: 'ชื่อ - นามสกุล',
                            value: fullName,
                          ),
                          _SummaryRow(
                            icon: Icons.email_outlined,
                            label: 'อีเมล',
                            value: email,
                          ),
                          _SummaryRow(
                            icon: Icons.phone_outlined,
                            label: 'เบอร์โทรศัพท์',
                            value: phone,
                          ),
                          _SummaryRow(
                            icon: Icons.local_hospital_outlined,
                            label: 'ชื่อคลินิก',
                            value: clinicName,
                          ),
                          _SummaryRow(
                            icon: Icons.email_outlined,
                            label: 'อีเมลคลินิก',
                            value: clinicEmail,
                          ),
                          _SummaryRow(
                            icon: Icons.map_outlined,
                            label: 'ลิงก์แผนที่คลินิก',
                            value: clinicMapLink,
                            isLink: true,
                          ),
                          _SummaryRow(
                            icon: Icons.home_outlined,
                            label: 'ที่อยู่คลินิก',
                            value: clinicAddress,
                          ),
                          _SummaryRow(
                            icon: Icons.location_city_outlined,
                            label: 'จังหวัด',
                            value: province,
                          ),
                          _SummaryRow(
                            icon: Icons.apartment_outlined,
                            label: 'เขต / อำเภอ',
                            value: district,
                          ),
                          _SummaryRow(
                            icon: Icons.markunread_mailbox_outlined,
                            label: 'รหัสไปรษณีย์',
                            value: zipCode,
                            showDivider: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ---- Bottom confirm button ----
              _ConfirmBar(onConfirm: onConfirm),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _HeroBanner — icon นาฬิกา + title + subtitle
// ============================================================
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(20),
        vertical: context.rs(20),
      ),
      decoration: BoxDecoration(
        color: AppColors.purpleLight,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- icon วงกลมสีเหลือง ----
          Container(
            width: context.rs(52),
            height: context.rs(52),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.access_time_rounded,
              size: context.rs(28),
              color: const Color(0xFFF59E0B),
            ),
          ),

          SizedBox(width: context.rs(14)),

          // ---- text ----
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ส่งข้อมูลลงทะเบียน',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(15),
                    fontWeight: FontWeight.w700,
                    color: AppColors.purple,
                  ),
                ),
                SizedBox(height: context.rs(5)),
                Text(
                  'ทีมงานกำลังตรวจสอบข้อมูล กรุณารอผล\nภายใน 7 วัน และแจ้งเตือนให้ทางอีเมล',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(11),
                    fontWeight: FontWeight.w400,
                    color: AppColors.purple.withValues(alpha: 0.75),
                    height: 1.55,
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
// _SummaryCard — กล่างรายการข้อมูลสรุป
// ============================================================
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title, required this.rows});
  final String title;
  final List<_SummaryRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- section title ----
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.rs(16),
              context.rs(14),
              context.rs(16),
              context.rs(8),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(13),
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),
          // ---- rows ----
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.rs(16),
              0,
              context.rs(16),
              context.rs(12),
            ),
            child: Column(children: rows),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _SummaryRow — แถวข้อมูล icon + label + value
// ============================================================
class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLink = false,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isLink;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: context.rs(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- icon ----
              Icon(icon, size: context.rs(18), color: AppColors.purple),
              SizedBox(width: context.rs(12)),
              // ---- text ----
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(11),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textGray,
                      ),
                    ),
                    SizedBox(height: context.rs(2)),
                    Text(
                      value,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(13),
                        fontWeight: FontWeight.w500,
                        color: isLink ? AppColors.purple : AppColors.black,
                        decoration:
                            isLink ? TextDecoration.underline : null,
                        decorationColor:
                            isLink ? AppColors.purple : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            color: AppColors.inputBorder,
            height: 1,
            thickness: 0.5,
          ),
      ],
    );
  }
}

// ============================================================
// _ConfirmBar — ปุ่มยืนยันการลงทะเบียนด้านล่าง
// ============================================================
class _ConfirmBar extends StatelessWidget {
  const _ConfirmBar({this.onConfirm});
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        context.rs(20),
        context.rs(10),
        context.rs(20),
        context.rs(28),
      ),
      child: SizedBox(
        width: double.infinity,
        height: context.rs(46),
        child: ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.purple,
            foregroundColor: AppColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.rs(30)),
            ),
          ),
          child: Text(
            'ยืนยันการลงทะเบียน',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(14),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
