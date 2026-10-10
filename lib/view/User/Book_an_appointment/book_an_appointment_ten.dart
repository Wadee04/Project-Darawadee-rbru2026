import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../HomeScreen/home_page_two.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// BookAnAppointmentTen - หน้าการจองเสร็จสมบูรณ์ (Booking Summary)
// ============================================================

class BookAnAppointmentTen extends StatelessWidget {
  const BookAnAppointmentTen({
    super.key,
    this.onClose,
    this.onContact,
    this.clinicName = 'Denbook Clinic สาขาจันทบุรี',
    this.bookingDate = 'วันพุธที่ 12 สิงหาคม 2569',
    this.bookingTime = '10:00 น.',
    this.doctorName = 'ทพญ. อรุณี ปรานอัศนี',
    this.doctorTitle = 'ทันตแพทย์ทั่วไป',
    this.serviceLabel = 'ตรวจสุขภาพช่องปากและฟัน',
    this.serviceSubLabel = '(Dental Check-up)',
    this.clinicAddress =
        '123/45 ถนนท่าแฉลบ ตำบลวัดใหม่ อำเภอเมืองจันทบุรี จังหวัด จันทบุรี',
    this.bookingId = 'SC680516-001',
    this.symptoms = const [],
    this.services = const [],
  });

  final VoidCallback? onClose;
  final VoidCallback? onContact;

  final String clinicName;
  final String bookingDate;
  final String bookingTime;
  final String doctorName;
  final String doctorTitle;
  final String serviceLabel;
  final String serviceSubLabel;
  final String clinicAddress;
  final String bookingId;
  final List<String> symptoms;
  final List<String> services;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFC5DEE8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- AppBar ----
              _SummaryAppBar(
                title: 'การจองเสร็จสมบูรณ์',
                onClose:
                    onClose ??
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomePageTwo(
                          appointmentService: serviceLabel,
                          appointmentDoctor: doctorName,
                          appointmentTime: bookingTime,
                          clinicName: clinicName,
                          symptoms: symptoms,
                          services: services,
                          bookingId: 'A-001',
                        ),
                      ),
                    ),
              ),

              SizedBox(height: context.rs(16)),

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
                              assetIcon: 'assets/images/Book_an_appointment/uim_calender.svg',
                              iconColor: AppColors.purple,
                              label: 'วันที่นัดหมาย',
                              value: bookingDate,
                            ),
                            _InfoRow(
                              assetIcon: 'assets/images/Book_an_appointment/schedule.svg',
                              iconColor: AppColors.purple,
                              label: 'เวลาที่นัดหมาย',
                              value: bookingTime,
                            ),
                            _DoctorRow(
                              assetIcon: 'assets/images/Book_an_appointment/doctor.svg',
                              iconColor: AppColors.purple,
                              label: 'ทันตแพทย์',
                              value: doctorName,
                              subValue: doctorTitle,
                            ),
                            _ServiceRow(
                              assetIcon: 'assets/images/Book_an_appointment/toothten.svg',
                              label: symptoms.isNotEmpty ? 'อาการ' : 'บริการ',
                              value: (symptoms.isNotEmpty ? symptoms : services)
                                  .join(' / '),
                              subLabel: serviceSubLabel,
                            ),
                            _LocationRow(
                              assetIcon: 'assets/images/Book_an_appointment/heroicons_map-pin-16-solid.svg',
                              label: 'สาขา',
                              clinicName: clinicName,
                              address: clinicAddress,
                            ),
                            _dashedDivider(context),
                            Padding(
                              padding: EdgeInsets.all(context.rs(16)),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.rs(16),
                                  vertical: context.rs(10),
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEEEFF),
                                  borderRadius: BorderRadius.circular(
                                    context.rs(16),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              'หมายเลขการจอง',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: context.rs(11),
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.textGray,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: context.rs(2),
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/images/Book_an_appointment/copy.svg',
                                            width: context.rs(9),
                                            height: context.rs(8),
                                            colorFilter: ColorFilter.mode(
                                              AppColors.purple,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: context.rs(4)),
                                    Center(
                                      child: Text(
                                        bookingId,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: context.rs(20),
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.purple,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: context.rs(12)),

                      // ---- ข้อมูลที่ควรทราบ ----
                      _SectionCard(
                        title: 'ข้อมูลที่ควรทราบ',
                        bottomPadding: 10,
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

  Widget _dashedDivider(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: context.rs(8)),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final dashWidth = context.rs(8);
        final dashGap = context.rs(4);
        final count = (constraints.maxWidth / (dashWidth + dashGap))
            .floor()
            .clamp(2, 50);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => Container(
              width: dashWidth,
              height: 1,
              decoration: BoxDecoration(
                color: Color(0xFFC9C9DF),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        );
      },
    ),
  );
}

// ============================================================
// _SummaryAppBar — arrow-left + title centered + right icon
// ============================================================
class _SummaryAppBar extends StatelessWidget {
  const _SummaryAppBar({required this.title, this.onClose});
  final String title;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.rs(54),
      padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
      alignment: Alignment.center,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(16),
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                alignment: Alignment.center,
                width: context.rs(24),
                height: context.rs(24),
                child: SvgPicture.asset(
                  'assets/images/Book_an_appointment/close.svg',
                  width: context.rs(11),
                  height: context.rs(11),
                  colorFilter: ColorFilter.mode(
                    AppColors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _SuccessBanner — green circle + white check + purple/gray text
// ============================================================
class _SuccessBanner extends StatelessWidget {
  const _SuccessBanner({required this.clinicName});
  final String clinicName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/images/Book_an_appointment/bluecheck.svg',
          width: context.rs(73),
          height: context.rs(72.78),
        ),
        SizedBox(width: context.rs(12)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- green check circle ----
            Text(
              'จองคิวสำเร็จ',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(18),
                fontWeight: FontWeight.w700,
                color: AppColors.purple,
              ),
            ),

            SizedBox(height: context.rs(4)),

            Text(
              'ขอบคุณที่วางใจ',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(12),
                fontWeight: FontWeight.w400,
                color: AppColors.textGray,
              ),
            ),

            SizedBox(height: context.rs(2)),

            Text(
              clinicName,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(12),
                fontWeight: FontWeight.w400,
                color: AppColors.textGray,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// _SectionCard — กล่องขอบโค้งพร้อม title section
// ============================================================
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.bottomPadding = 2,
  });
  final String title;
  final Widget child;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(16)),
        border: Border.all(color: AppColors.purple, width: context.rs(1)),
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
                fontSize: context.rs(16),
                fontWeight: FontWeight.w500,
                color: AppColors.purple,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.rs(16),
              0,
              context.rs(16),
              context.rs(bottomPadding),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _InfoRow — แถวข้อมูลทั่วไป (SVG icon + label + value)
// ============================================================
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.assetIcon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final String assetIcon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.rs(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assetIcon,
            width: context.rs(18),
            height: context.rs(18),
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
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
                    fontSize: context.rs(14),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGray,
                  ),
                ),
                SizedBox(height: context.rs(2)),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(14),
                    fontWeight: FontWeight.w500,
                    color: AppColors.purple,
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
// _DoctorRow — แถวทันตแพทย์ (icon + label + value + sub value)
// ============================================================
class _DoctorRow extends StatelessWidget {
  const _DoctorRow({
    required this.assetIcon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subValue,
  });

  final String assetIcon;
  final Color iconColor;
  final String label;
  final String value;
  final String subValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.rs(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assetIcon,
            width: context.rs(18),
            height: context.rs(18),
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
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
                    fontSize: context.rs(14),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGray,
                  ),
                ),
                SizedBox(height: context.rs(2)),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(14),
                    fontWeight: FontWeight.w500,
                    color: AppColors.purple,
                  ),
                ),
                SizedBox(height: context.rs(2)),
                Text(
                  subValue,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(14),
                    fontWeight: FontWeight.w500,
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
// _ServiceRow — แถวบริการ (SVG tooth icon + label + sub label)
// ============================================================
class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.assetIcon,
    required this.label,
    required this.value,
    required this.subLabel,
  });

  final String assetIcon;
  final String label;
  final String value;
  final String subLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.rs(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assetIcon,
            width: context.rs(18),
            height: context.rs(18),
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
                    fontSize: context.rs(14),
                    fontWeight: FontWeight.w500,
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
                    color: AppColors.purple,
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
  const _LocationRow({
    required this.assetIcon,
    required this.label,
    required this.clinicName,
    required this.address,
  });
  final String assetIcon;
  final String label;
  final String clinicName;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.rs(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assetIcon,
            width: context.rs(22),
            height: context.rs(22),
            colorFilter: ColorFilter.mode(AppColors.purple, BlendMode.srcIn),
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
                    fontSize: context.rs(12),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGray,
                  ),
                ),
                SizedBox(height: context.rs(2)),
                Text(
                  clinicName,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(14),
                    fontWeight: FontWeight.w500,
                    color: AppColors.purple,
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
// _GeneralInfoContent — เนื้อหาข้อมูลที่ควรทราบ (bullet list)
// ============================================================
class _GeneralInfoContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = _generalInfoItems(context);
    return Column(
      children: items.map((item) => _GeneralInfoItem(item: item)).toList(),
    );
  }

  List<_InfoItem> _generalInfoItems(BuildContext context) => [
    _InfoItem(
      assetIcon: 'assets/images/Book_an_appointment/schedule_bold.svg',
      iconColor: AppColors.purple,
      text: 'กรุณามาถึงก่อนเวลานัดหมายอย่างน้อย 15 นาที',
      highlight: null,
    ),
    _InfoItem(
      assetIcon: 'assets/images/Book_an_appointment/tdesign_money.svg',
      iconColor: AppColors.purple,
      text: 'กรณีหากต้องการยกเลิกหรือเลื่อน',
      highlight:
          '1. ยกเลิกล่วงหน้า **48 ชั่วโมง**ขึ้นไปคืนเงินมัดจำ **100%** \n'
          '2. ยกเลิกก่อนวันนัด **24-48 ชั่วโมง**คืนเงินมัดจำ **50%** \n'
          '3. ยกเลิกนัด**น้อยกว่า 24 ชั่วโมง** หรือไม่มาตามนัด **ไม่คืนเงินมัดจำ** \n'
          '4. กรณีคลินิกเป็นฝ่ายยกเลิก หรือ เลื่อนนัด คืนเงินเต็มจำนวน หรือ \n'
          '    ให้ผู้ป่วยเลือกเลื่อนนัดโดยใช้มัดจำเดิม',
    ),
    _InfoItem(
      assetIcon: 'assets/images/Book_an_appointment/mingcute_warning-line.svg',
      iconColor: AppColors.purple,
      text: 'กรุณานำบัตรประชาชนมาด้วยในวันนัดหมาย',
      highlight: null,
    ),
  ];
}

class _InfoItem {
  const _InfoItem({
    required this.assetIcon,
    required this.iconColor,
    required this.text,
    required this.highlight,
  });
  final String assetIcon;
  final Color iconColor;
  final String text;
  final String? highlight;
}

List<TextSpan> _highlightSpans(String text, {required TextStyle redStyle}) {
  final parts = text.split('**');
  return [
    for (var i = 0; i < parts.length; i++)
      TextSpan(text: parts[i], style: i.isOdd ? redStyle : null),
  ];
}

class _GeneralInfoItem extends StatelessWidget {
  const _GeneralInfoItem({required this.item});
  final _InfoItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.rs(6)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            item.assetIcon,
            width: context.rs(18),
            height: context.rs(18),
            colorFilter: ColorFilter.mode(item.iconColor, BlendMode.srcIn),
          ),
          SizedBox(width: context.rs(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.text,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(12),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGray,
                    height: 1.55,
                  ),
                ),
                if (item.highlight != null)
                  Padding(
                    padding: EdgeInsets.only(top: context.rs(4)),
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(10),
                          fontWeight: FontWeight.w400,
                          color: AppColors.textGray,
                          height: 1.55,
                        ),
                        children: _highlightSpans(
                          item.highlight!,
                          redStyle: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(10),
                            fontWeight: FontWeight.w500,
                            color: AppColors.red,
                            height: 1.55,
                          ),
                        ),
                      ),
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
        padding: EdgeInsets.symmetric(
          horizontal: context.rs(20),
          vertical: context.rs(5),
        ),
        decoration: BoxDecoration(
          color: AppColors.homeBackground,
          borderRadius: BorderRadius.circular(context.rs(16)),
        ),
        child: Row(
          children: [
            // ---- icon headphone ----
            SvgPicture.asset(
              'assets/images/Book_an_appointment/boxicons_headphone-mic.svg',
              width: context.rs(24),
              height: context.rs(24),
              colorFilter: ColorFilter.mode(AppColors.purple, BlendMode.srcIn),
            ),

            SizedBox(width: context.rs(12)),

            // ---- text ----
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ต้องการความช่วยเหลือ ?',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(14),
                      fontWeight: FontWeight.w500,
                      color: AppColors.purple,
                    ),
                  ),
                  Text(
                    'ติดต่อเราได้ที่ 039-123-456 หรือ Line @dentbook',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(11),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textGray,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
