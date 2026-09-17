import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/shared_widgets.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';
import '../HomeScreen/home_page_two.dart';

// ============================================================
// BookAnAppointmentTen - หน้าการจองเสร็จสมบูรณ์ (Booking Summary)
// ============================================================

class BookAnAppointmentTen extends StatelessWidget {
  const BookAnAppointmentTen({
    super.key,
    this.onClose,
    this.onContact,
    this.clinicName = 'SmileCare Dental Clinic',
    this.bookingDate = 'วันพุธ 12 สิงหาคม 2569',
    this.bookingTime = '10:00 น.',
    this.doctorName = 'ทพญ. อรุณี ปธานนท์',
    this.serviceLabel = 'ตรวจสุขภาพฟันทั่วไปเพิ่มเติม',
    this.serviceSubLabel = 'Dental Check-up',
    this.clinicAddress =
        '123/45 ถนนราชดำเนิน ตำบลหน้าเมือง อำเภอเมืองจันทบุรี จังหวัด จันทบุรี',
    this.bookingId = 'SC680516-001',
  });

  final VoidCallback? onClose;
  final VoidCallback? onContact;

  final String clinicName;
  final String bookingDate;
  final String bookingTime;
  final String doctorName;
  final String serviceLabel;
  final String serviceSubLabel;
  final String clinicAddress;
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFC5DEE8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
          children: [
            // ---- AppBar ----
            _SummaryAppBar(
              title: 'การจองเสร็จสมบูรณ์',
              onClose: onClose,
            ),

            // ---- Scrollable Body ----
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  context.rs(16),
                  0,
                  context.rs(16),
                  context.rs(24),
                ),
                child: Column(
                  children: [
                    // ---- Success Banner ----
                    _SuccessBanner(clinicName: clinicName),

                    SizedBox(height: context.rs(16)),

                    // ---- ข้อมูลการจอง ----
                    _SectionCard(
                      title: 'ข้อมูลการจอง',
                      child: Column(
                        children: [
                          _InfoRow(
                            icon: Icons.calendar_today_outlined,
                            iconColor: AppColors.purple,
                            label: 'วันที่นัดหมาย',
                            value: bookingDate,
                          ),
                          _divider(context),
                          _InfoRow(
                            icon: Icons.access_time_outlined,
                            iconColor: AppColors.purple,
                            label: 'เวลานัดหมาย',
                            value: bookingTime,
                          ),
                          _divider(context),
                          _InfoRow(
                            icon: Icons.person_outline,
                            iconColor: AppColors.purple,
                            label: 'ทพญ. อรุณี ปธานนท์',
                            value: '',
                            isDoctor: true,
                            doctorName: doctorName,
                          ),
                          _divider(context),
                          _ServiceRow(
                            label: serviceLabel,
                            subLabel: serviceSubLabel,
                          ),
                          _divider(context),
                          _LocationRow(
                            clinicName: clinicName,
                            address: clinicAddress,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: context.rs(12)),

                    // ---- Booking ID ----
                    _BookingIdCard(bookingId: bookingId),

                    SizedBox(height: context.rs(12)),

                    // ---- ข้อมูลทั่วไป ----
                    _SectionCard(
                      title: 'ข้อมูลทั่วไป',
                      child: _GeneralInfoContent(),
                    ),

                    SizedBox(height: context.rs(12)),

                    // ---- Contact ----
                    _ContactCard(onContact: onContact),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _divider(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: context.rs(2)),
        child: Divider(
          color: AppColors.inputBorder,
          height: 1,
          thickness: 0.5,
        ),
      );
}

// ============================================================
// _SummaryAppBar — title กลาง + ปุ่ม X ขวา
// ============================================================
class _SummaryAppBar extends StatelessWidget {
  const _SummaryAppBar({required this.title, this.onClose});
  final String title;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.rs(24),
        MediaQuery.of(context).size.height * 0.01,
        context.rs(24),
        context.rs(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // placeholder ซ้าย
          SizedBox(width: context.rs(24)),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(15),
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          GestureDetector(
            onTap: onClose ?? () => Navigator.pushReplacement(
              context,
              noAnimRoute(const HomePageTwo()),
            ),
            child: Icon(
              Icons.close,
              size: context.rs(22),
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _SuccessBanner — พื้นหลังสีม่วง + icon check + ชื่อคลินิก
// ============================================================
class _SuccessBanner extends StatelessWidget {
  const _SuccessBanner({required this.clinicName});
  final String clinicName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: context.rs(20),
        horizontal: context.rs(16),
      ),
      decoration: BoxDecoration(
        color: AppColors.purple,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Column(
        children: [
          // ---- check circle ----
          Container(
            width: context.rs(52),
            height: context.rs(52),
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              size: context.rs(30),
              color: AppColors.purple,
            ),
          ),

          SizedBox(height: context.rs(10)),

          Text(
            'จองคิวสำเร็จแล้ว',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(16),
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),

          SizedBox(height: context.rs(4)),

          Text(
            clinicName,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(13),
              fontWeight: FontWeight.w400,
              color: AppColors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _SectionCard — กล่องขอบโค้งพร้อม title section
// ============================================================
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});
  final String title;
  final Widget child;

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
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.rs(16),
              0,
              context.rs(16),
              context.rs(14),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _InfoRow — แถวข้อมูลทั่วไป (icon + label + value)
// ============================================================
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.isDoctor = false,
    this.doctorName = '',
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool isDoctor;
  final String doctorName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.rs(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: context.rs(18), color: iconColor),
          SizedBox(width: context.rs(10)),
          Expanded(
            child: isDoctor
                ? Text(
                    doctorName,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(13),
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(12),
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
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
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
// _ServiceRow — แถวบริการ (icon ฟัน + ชื่อบริการ + sub label)
// ============================================================
class _ServiceRow extends StatelessWidget {
  const _ServiceRow({required this.label, required this.subLabel});
  final String label;
  final String subLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.rs(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/images/Book_an_appointment/icons/checkup.svg',
            width: context.rs(18),
            height: context.rs(18),
            colorFilter: const ColorFilter.mode(
              AppColors.purple,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: context.rs(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(13),
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: context.rs(2)),
                Text(
                  subLabel,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(12),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGray,
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
// _LocationRow — แถวที่อยู่คลินิก
// ============================================================
class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.clinicName, required this.address});
  final String clinicName;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.rs(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: context.rs(18),
            color: AppColors.purple,
          ),
          SizedBox(width: context.rs(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clinicName,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(13),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: context.rs(3)),
                Text(
                  address,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(12),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGray,
                    height: 1.5,
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
// _BookingIdCard — กล่องเลขที่อ้างอิงการจอง
// ============================================================
class _BookingIdCard extends StatelessWidget {
  const _BookingIdCard({required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: context.rs(14),
        horizontal: context.rs(16),
      ),
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Column(
        children: [
          Text(
            'หมายเลขการจอง',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(12),
              fontWeight: FontWeight.w400,
              color: AppColors.textGray,
            ),
          ),
          SizedBox(height: context.rs(6)),
          Text(
            bookingId,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(16),
              fontWeight: FontWeight.w700,
              color: AppColors.purple,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _GeneralInfoContent — เนื้อหาข้อมูลทั่วไป (bullet list)
// ============================================================
class _GeneralInfoContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = _generalInfoItems(context);
    return Column(
      children: items
          .map((item) => _GeneralInfoItem(item: item))
          .toList(),
    );
  }

  List<_InfoItem> _generalInfoItems(BuildContext context) => [
        _InfoItem(
          icon: Icons.access_time_outlined,
          iconColor: AppColors.orange,
          text: 'กรุณามาถึงก่อนเวลานัด อย่างน้อย 15 นาที',
          highlight: null,
        ),
        _InfoItem(
          icon: Icons.cancel_outlined,
          iconColor: AppColors.reddentbook,
          text:
              'หากยกเลิกการนัดหมายภายใน 48 ชั่วโมงก่อนวันนัด จะถูกหักค่ามัดจำ 30%\nหากยกเลิกหลังจากนั้น จะถูกหักค่ามัดจำ 100%',
          highlight: '48 ชั่วโมงก่อนวันนัด จะถูกหักค่ามัดจำ 30%\nหากยกเลิกหลังจากนั้น จะถูกหักค่ามัดจำ 100%',
        ),
        _InfoItem(
          icon: Icons.info_outline,
          iconColor: AppColors.purple,
          text:
              'กรุณาแจ้งโรคประจำตัว หรือยาที่รับประทานอยู่แก่ทันตแพทย์ก่อนรับบริการ',
          highlight: null,
        ),
        _InfoItem(
          icon: Icons.info_outline,
          iconColor: AppColors.purple,
          text: 'ห้ามรับประทานอาหารก่อนการรักษา 2 ชั่วโมง',
          highlight: null,
        ),
      ];
}

class _InfoItem {
  const _InfoItem({
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.highlight,
  });
  final IconData icon;
  final Color iconColor;
  final String text;
  final String? highlight;
}

class _GeneralInfoItem extends StatelessWidget {
  const _GeneralInfoItem({required this.item});
  final _InfoItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.rs(7)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.icon,
            size: context.rs(16),
            color: item.iconColor,
          ),
          SizedBox(width: context.rs(10)),
          Expanded(
            child: Text(
              item.text,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(12),
                fontWeight: FontWeight.w400,
                color: AppColors.black,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _ContactCard — กล่องติดต่อสอบถาม
// ============================================================
class _ContactCard extends StatelessWidget {
  const _ContactCard({this.onContact});
  final VoidCallback? onContact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onContact,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.rs(14)),
        decoration: BoxDecoration(
          color: AppColors.homeBackground,
          borderRadius: BorderRadius.circular(context.rs(16)),
        ),
        child: Row(
          children: [
            // ---- icon chat ----
            Container(
              width: context.rs(40),
              height: context.rs(40),
              decoration: BoxDecoration(
                color: AppColors.purpleLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: context.rs(20),
                color: AppColors.purple,
              ),
            ),

            SizedBox(width: context.rs(12)),

            // ---- text ----
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ต้องการสอบถามเพิ่มเติม?',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(13),
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: context.rs(2)),
                  Text(
                    'ติดต่อเราได้ที่ 039-134-456 หรือ Line @dentbook',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(11),
                      fontWeight: FontWeight.w400,
                      color: AppColors.textGray,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right,
              size: context.rs(20),
              color: AppColors.textGray,
            ),
          ],
        ),
      ),
    );
  }
}
