import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';
import 'book_an_appointment_nine.dart';

// ============================================================
// BookAnAppointmentEight - หน้าชำระมัดจำ
// ============================================================

class BookAnAppointmentEight extends StatelessWidget {
  const BookAnAppointmentEight({
    super.key,
    this.onBack,
    this.onPay,
    this.doctorName = 'ทพญ. อรุณี ปรานอัศนี',
    this.doctorSpecialty = 'ทันตแพทย์ทั่วไป',
    this.serviceName = 'ตรวจสุขภาพ + X-ray / อุดฟัน',
    this.appointmentDate = 'วันพุธ ที่ 12 สิงหาคม 2569',
    this.appointmentTime = '09:00',
    this.clinicName = 'DentBook Clinic สาขาจันทบุรี',
    this.bookingNumber = 'SC680516-001',
    this.depositAmount = 200,
  });

  final VoidCallback? onBack;
  final VoidCallback? onPay;
  final String doctorName;
  final String doctorSpecialty;
  final String serviceName;
  final String appointmentDate;
  final String appointmentTime;
  final String clinicName;
  final String bookingNumber;
  final int depositAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ---- AppBar ----
            AppBarBack(
              title: 'ชำระมัดจำ',
              onBack: onBack,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
                child: Column(
                  children: [
                    SizedBox(height: context.rs(28)),

                    // ---- Booking Summary Card ----
                    _BookingSummaryCard(
                      serviceName: serviceName,
                      doctorName: doctorName,
                      doctorSpecialty: doctorSpecialty,
                      appointmentDate: appointmentDate,
                      appointmentTime: appointmentTime,
                      clinicName: clinicName,
                      bookingNumber: bookingNumber,
                    ),

                    SizedBox(height: context.rs(16)),

                    // ---- Deposit Card ----
                    _DepositCard(amount: depositAmount),

                    SizedBox(height: context.rs(24)),
                  ],
                ),
              ),
            ),

            // ---- Bottom Button ----
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.rs(24),
                context.rs(8),
                context.rs(24),
                context.rs(48),
              ),
              child: SizedBox(
                width: double.infinity,
                height: context.rs(40),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BookAnAppointmentNine(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.rs(30)),
                    ),
                  ),
                  child: Text(
                    'จ่ายเลย',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(14),
                      fontWeight: FontWeight.w400,
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
// _BookingSummaryCard - การ์ดสรุปการจอง
// ============================================================
class _BookingSummaryCard extends StatelessWidget {
  const _BookingSummaryCard({
    required this.serviceName,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.clinicName,
    required this.bookingNumber,
  });

  final String serviceName;
  final String doctorName;
  final String doctorSpecialty;
  final String appointmentDate;
  final String appointmentTime;
  final String clinicName;
  final String bookingNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.rs(16)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x404E4C85),
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x404E4C85),
            offset: Offset(0, -2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Header: ชื่อ service ----
          Container(
            padding: EdgeInsets.fromLTRB(
              context.rs(18),
              context.rs(16),
              context.rs(18),
              context.rs(12),
            ),
            
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'สรุปการจองคิว',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(16),
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: context.rs(4)),
                    Text(
                      serviceName,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(14),
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: context.rs(8)),
                    // Badge Dental Chek-up
                    Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.rs(8),
                    vertical: context.rs(4),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEFFF),
                    borderRadius: BorderRadius.circular(context.rs(16)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Check icon
                      Container(
                        width: context.rs(10),
                        height: context.rs(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFF302F50),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          size: context.rs(6),
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(width: context.rs(4)),
                      Text(
                        'Dental Chek-up',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(8),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF302F50),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

          // ---- Detail rows ----
          Container(
            padding: EdgeInsets.fromLTRB(
              context.rs(18),
              context.rs(12),
              context.rs(18),
              context.rs(12),
            ),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // หมอ
                    _DetailRow(
                      svgPath: 'assets/images/Book_an_appointment/healthicons_doctor-male.svg',
                      lines: [doctorName, doctorSpecialty],
                    ),
                    SizedBox(height: context.rs(10)),
                    // วันที่
                    _DetailRow(
                      svgPath: 'assets/images/Book_an_appointment/uim_calender.svg',
                      lines: [appointmentDate],
                    ),
                    SizedBox(height: context.rs(10)),
                    // เวลา
                    _DetailRow(
                      svgPath: 'assets/images/Book_an_appointment/iconamoon_clock-fill.svg',
                      lines: [appointmentTime],
                    ),
                    SizedBox(height: context.rs(10)),
                    // สถานที่
                    _DetailRow(
                      svgPath: 'assets/images/Book_an_appointment/heroicons_map-pin-16-solid.svg',
                      lines: [clinicName],
                    ),
                  ],
                ),
                // รูป imageeight ชิดขวา กึ่งกลางแนวตั้ง
                Positioned(
                  right: 0,
                  top: context.rs(25),
                  child: SvgPicture.asset(
                    'assets/images/Book_an_appointment/imageeight.svg',
                    width: context.rs(112),
                  ),
                ),
              ],
            ),
            // เส้นแบ่งล่าง: ปะ ห่างจากสถานที่ 15
            SizedBox(height: context.rs(25)),
            LayoutBuilder(
              builder: (context, constraints) {
                final dashWidth = context.rs(8);
                final dashGap = context.rs(4);
                final count =
                    (constraints.maxWidth / (dashWidth + dashGap))
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
                        color: AppColors.purple,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                );
              },
            ),
              ],
            ),
          ),

          // ---- Booking number ----
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
                borderRadius: BorderRadius.circular(context.rs(16)),
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
                        // copy icon ชิดขวา ห่างจากขอบ 16
                        Padding(
                          padding: EdgeInsets.only(right: 16),
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
                      bookingNumber,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(16),
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
    );
  }
}

// ============================================================
// _DepositCard - การ์ดข้อมูลมัดจำ
// ============================================================
class _DepositCard extends StatelessWidget {
  const _DepositCard({required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.rs(16)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x404E4C85),
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x404E4C85),
            offset: Offset(0, -2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: context.rs(16), vertical: context.rs(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ชำระมัดจำเพื่อยืนยันการจอง',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(16),
              fontWeight: FontWeight.w500,
              color: AppColors.purple,
            ),
          ),
          SizedBox(height: context.rs(4)),
          Text(
            'คลินิกขอเก็บมัดจำเพื่อยืนยันการจองคิวของคุณ',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(13),
              fontWeight: FontWeight.w500,
              color: AppColors.textGray,
            ),
          ),
          SizedBox(height: context.rs(12)),

          // ---- Amount box ----
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IntrinsicWidth(
                child: Container(
                  padding: EdgeInsets.all(context.rs(14)),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(context.rs(16)),
                    border: Border.all(
                      color: const Color(0xFFA2A1BC),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'จำนวนมัดจำ',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(13),
                          fontWeight: FontWeight.w600,
                          color: AppColors.purple,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$amount',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: context.rs(24),
                              fontWeight: FontWeight.w800,
                              color: AppColors.purple,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'มัดจำถูกหักจากยอดรวมในวันเข้ารับการรักษา',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(9),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF595963),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: context.rs(4)),
              SvgPicture.asset(
                'assets/images/Book_an_appointment/baaone.svg',
                width: context.rs(102),
                height: context.rs(95),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _DetailRow - แถวแสดงข้อมูลพร้อม icon
// ============================================================
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    this.icon,
    this.svgPath,
    required this.lines,
  }) : assert(icon != null || svgPath != null,
            'ต้องระบุ icon หรือ svgPath อย่างใดอย่างหนึ่ง');

  final IconData? icon;
  final String? svgPath;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (svgPath != null)
          SvgPicture.asset(
            svgPath!,
            width: context.rs(18),
            height: context.rs(18),
            colorFilter: ColorFilter.mode(AppColors.purple, BlendMode.srcIn),
          )
        else
          Icon(
            icon,
            size: context.rs(18),
            color: AppColors.purple,
          ),
        SizedBox(width: context.rs(10)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lines
                .map(
                  (line) => Text(
                    line,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(11),
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
