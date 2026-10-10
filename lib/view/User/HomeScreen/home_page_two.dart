import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/shared_widgets.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';
import '../Book_an_appointment/book_an_appointment_one.dart';
import '../My_queue/my_queue_one.dart';
import '../Profile/profile.dart';
import 'home_page_one.dart';
import 'home_page_three.dart';

// ============================================================
// HomePageTwo - หน้าหลัก (สถานะ: เลือกคลินิกแล้ว มีนัดหมาย)
// ============================================================

/// ข้อมูลแถวคิวแต่ละห้อง
class ClinicQueueItem {
  const ClinicQueueItem({
    required this.roomName,
    required this.doctorName,
    this.currentNumber,
    this.isServing = false,
  });

  final String roomName;
  final String doctorName;
  final int? currentNumber;
  final bool isServing;
}

class HomePageTwo extends StatefulWidget {
  const HomePageTwo({
    super.key,
    this.userName = 'คุณดาราวดี อลัย',
    this.clinicName = 'Dentbook Clinic',
    this.clinicProvince = 'กรุงเทพมหานคร',
    this.appointmentService,
    this.appointmentDoctor,
    this.appointmentTime,
    this.symptoms = const [],
    this.services = const [],
    this.bookingId,
    this.queueItem = const ClinicQueueItem(
      roomName: 'ห้อง 1',
      doctorName: 'ทพญ. อรุณี',
      currentNumber: 14,
      isServing: true,
    ),
    this.onNotification,
    this.onProfile,
    this.onSelectClinic,
    this.onBooking,
    this.onMyQueue,
  });

  final String userName;
  final String clinicName;
  final String clinicProvince;
  final String? appointmentService;
  final String? appointmentDoctor;
  final String? appointmentTime;
  final List<String> symptoms;
  final List<String> services;
  final String? bookingId;
  final ClinicQueueItem queueItem;
  final VoidCallback? onNotification;
  final VoidCallback? onProfile;
  final VoidCallback? onSelectClinic;
  final VoidCallback? onBooking;
  final VoidCallback? onMyQueue;

  @override
  State<HomePageTwo> createState() => _HomePageTwoState();
}

class _HomePageTwoState extends State<HomePageTwo> {
  int _navIndex = 0;

  void _showAppointmentDetail(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: context.rs(20), vertical: context.rs(24)),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(context.rs(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: EdgeInsets.all(context.rs(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(context.rs(10)),
                    decoration: BoxDecoration(
                      color: AppColors.purpleLight,
                      borderRadius: BorderRadius.circular(context.rs(12)),
                    ),
                    child: Icon(
                      Icons.calendar_today_rounded,
                      size: context.rs(20),
                      color: AppColors.purple,
                    ),
                  ),
                  SizedBox(width: context.rs(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'รายละเอียดการจอง',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(16),
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          widget.clinicName,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(12),
                            color: AppColors.textGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      padding: EdgeInsets.all(context.rs(6)),
                      decoration: BoxDecoration(
                        color: AppColors.homeBackground,
                        borderRadius: BorderRadius.circular(context.rs(8)),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: context.rs(18),
                        color: AppColors.textGray,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.rs(20)),

              // Divider
              Divider(color: AppColors.inputBorder, height: 1),
              SizedBox(height: context.rs(16)),

              // Booking ID
              if (widget.bookingId != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.confirmation_number_rounded,
                      size: context.rs(18),
                      color: AppColors.purple,
                    ),
                    SizedBox(width: context.rs(10)),
                    Text(
                      'หมายเลขการจอง',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(12),
                        color: AppColors.textGray,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      widget.bookingId!,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(14),
                        fontWeight: FontWeight.w700,
                        color: AppColors.purple,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.rs(16)),
              ],

              // Date & Time
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: context.rs(18),
                    color: AppColors.purple,
                  ),
                  SizedBox(width: context.rs(10)),
                  Text(
                    'วันเวลานัดหมาย',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(12),
                      color: AppColors.textGray,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${widget.appointmentTime ?? '10:00 น.'}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.rs(12)),

              // Doctor
              Row(
                children: [
                  Icon(
                    Icons.person_rounded,
                    size: context.rs(18),
                    color: AppColors.purple,
                  ),
                  SizedBox(width: context.rs(10)),
                  Text(
                    'ทันตแพทย์',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(12),
                      color: AppColors.textGray,
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      widget.appointmentDoctor ?? 'ทพ.อรุณี ใจดี',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.rs(12)),

              // Service / Symptoms
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.medical_services_rounded,
                    size: context.rs(18),
                    color: AppColors.purple,
                  ),
                  SizedBox(width: context.rs(10)),
                  Text(
                    widget.symptoms.isNotEmpty ? 'อาการ' : 'บริการ',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(12),
                      color: AppColors.textGray,
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      _buildServiceSymptomsText(),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.rs(20)),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        // TODO: Handle change appointment
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.purple, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.rs(12)),
                        ),
                        padding: EdgeInsets.symmetric(vertical: context.rs(12)),
                      ),
                      child: Text(
                        'เปลี่ยนวัน/เวลา',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(13),
                          fontWeight: FontWeight.w600,
                          color: AppColors.purple,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: context.rs(12)),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        // TODO: Handle cancel
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.rs(12)),
                        ),
                        padding: EdgeInsets.symmetric(vertical: context.rs(12)),
                      ),
                      child: Text(
                        'ยกเลิกนัด',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildServiceSymptomsText() {
    if (widget.symptoms.isNotEmpty) {
      if (widget.symptoms.length <= 2) {
        return widget.symptoms.join(', ');
      } else {
        return '${widget.symptoms.take(2).join(', ')} +${widget.symptoms.length - 2}';
      }
    } else if (widget.services.isNotEmpty) {
      if (widget.services.length == 1) {
        return widget.services.first;
      } else if (widget.services.length == 2) {
        return '${widget.services[0]}, ${widget.services[1]}';
      } else {
        return '${widget.services[0]}, ${widget.services[1]} +${widget.services.length - 2}';
      }
    }
    return widget.appointmentService ?? 'ตรวจสุขภาพช่องปากและฟัน';
  }

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
                        Row(
                          children: [
                            _IconBtn(
                              svgAsset:
                                  'assets/images/homescreen/bell.svg',
                              onTap: widget.onNotification,
                              width: 15,
                              height: 17,
                            ),
                            SizedBox(width: context.rs(25)),
                            _IconBtn(
                              svgAsset:
                                  'assets/images/homescreen/contact.svg',
                              onTap: widget.onProfile,
                              width: 20,
                              height: 18.16,
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: context.rs(10)),

                    // ---- Location bar (คลินิกที่เลือกแล้ว) ----
                    GestureDetector(
                      onTap: () {
                        showSelectClinicSheet(context,
                            onSelect: (clinic) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomePageThree(
                                clinicName: clinic.name,
                                clinicProvince: clinic.province,
                              ),
                            ),
                          );
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
                                borderRadius: BorderRadius.circular(
                                    context.rs(10)),
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
                                    widget.clinicName,
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
                                        widget.clinicProvince,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: context.rs(11),
                                          color: AppColors.black60,
                                        ),
                                      ),
                                      SizedBox(width: context.rs(6)),
                                      Icon(
                                        Icons
                                            .keyboard_arrow_down_rounded,
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

                    // ---- Appointment card (มีนัด) ----
                    GestureDetector(
                      onTap: () => _showAppointmentDetail(context),
                      child: _ActiveAppointmentCard(
                        service: widget.appointmentService ?? 'ขูดหินปูน',
                        doctor: widget.appointmentDoctor ?? 'ทพ.อรุณี ใจดี',
                        time: widget.appointmentTime ?? '10.00 น.',
                        symptoms: widget.symptoms,
                        services: widget.services,
                        bookingId: widget.bookingId,
                      ),
                    ),

                    SizedBox(height: context.rs(20)),

                    // ---- คิวคลินิกวันนี้ ----
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
                          'คิวคลินิกวันนี้',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(15),
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.rs(10)),
                    _QueueRow(item: widget.queueItem),
                    SizedBox(height: context.rs(8)),
                    _QueueRow(
                      item: const ClinicQueueItem(
                        roomName: 'ห้อง 2',
                        doctorName: 'ทพ. ธนากร',
                        currentNumber: 9,
                        isServing: true,
                      ),
                    ),
                    SizedBox(height: context.rs(8)),
                    _QueueRow(
                      item: const ClinicQueueItem(
                        roomName: 'ห้อง 3',
                        doctorName: 'ทพ. พิมพ์ชนก',
                        currentNumber: null,
                        isServing: false,
                      ),
                    ),

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
                            svgAsset:
                                'assets/images/homescreen/check_up.svg',
                            label: 'ตรวจสุขภาพฟัน',
                            onTap: widget.onBooking,
                          ),
                        ),
                        SizedBox(width: context.rs(10)),
                        Expanded(
                          child: _ServiceCard(
                            svgAsset:
                                'assets/images/homescreen/teeth_scaling.svg',
                            label: 'ขูดหินปูน',
                            onTap: widget.onBooking,
                          ),
                        ),
                        SizedBox(width: context.rs(10)),
                        Expanded(
                          child: _ServiceCard(
                            svgAsset:
                                'assets/images/homescreen/tooth_ filling.svg',
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
            AppBottomNav(
              currentIndex: _navIndex,
              onTap: (i) {
                setState(() => _navIndex = i);
                if (i == 0) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePageOne()),
                    (route) => false,
                  );
                }
                if (i == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BookAnAppointmentOne()),
                  );
                }
                if (i == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyQueueOne()),
                  );
                }
                if (i == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfilePage(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _IconBtn — ปุ่ม icon SVG ใน header
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
// _ActiveAppointmentCard — card นัดหมายที่มีข้อมูล
// ============================================================
class _ActiveAppointmentCard extends StatelessWidget {
  const _ActiveAppointmentCard({
    this.service = 'ขูดหินปูน',
    this.doctor = 'ทพ.อรุณี ใจดี',
    this.time = '10.00 น.',
    this.symptoms = const [],
    this.services = const [],
    this.bookingId,
  });

  final String service;
  final String doctor;
  final String time;
  final List<String> symptoms;
  final List<String> services;
  final String? bookingId;

  String _buildDisplayText() {
    if (symptoms.isNotEmpty) {
      if (symptoms.length <= 2) {
        return symptoms.join(', ');
      } else {
        return '${symptoms.take(2).join(', ')} +${symptoms.length - 2}';
      }
    } else if (services.isNotEmpty) {
      if (services.length == 1) {
        return services.first;
      } else if (services.length == 2) {
        return '${services[0]}, ${services[1]}';
      } else {
        return '${services[0]}, ${services[1]} +${services.length - 2}';
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _buildDisplayText();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(24),
        vertical: context.rs(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'นัดหมายถัดไปของคุณ',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(14),
              fontWeight: FontWeight.w400,
              color: AppColors.white.withValues(alpha: 0.75),
            ),
          ),
          SizedBox(height: context.rs(13)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(16),
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                        height: 1.1,
                      ),
                    ),
                    if (displayText.isNotEmpty) ...[
                      SizedBox(height: context.rs(4)),
                      Text(
                        displayText,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(13),
                          fontWeight: FontWeight.w500,
                          color: AppColors.white.withValues(alpha: 0.9),
                          height: 1.1,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (bookingId != null)
                Text(
                  bookingId!,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(20),
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                    letterSpacing: 1,
                  ),
                ),
            ],
          ),
          SizedBox(height: context.rs(8)),
          Text(
            '$doctor - $time',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(14),
              fontWeight: FontWeight.w400,
              color: AppColors.white.withValues(alpha: 0.85),
              height: 0.9,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _QueueRow — แถวคิว
// ============================================================
class _QueueRow extends StatelessWidget {
  const _QueueRow({required this.item});
  final ClinicQueueItem item;

  @override
  Widget build(BuildContext context) {
    final bool isServing =
        item.isServing && item.currentNumber != null;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(14),
        vertical: context.rs(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.rs(12)),
        border: Border.all(
          color: AppColors.introductioncard,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // ซ้าย: ชื่อห้อง + dot + ชื่อหมอ
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.roomName,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(14),
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(width: context.rs(6)),
                    Container(
                      width: context.rs(8),
                      height: context.rs(8),
                      decoration: BoxDecoration(
                        color: isServing
                            ? AppColors.orange
                            : AppColors.greendentbook,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.rs(2)),
                Text(
                  item.doctorName,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(14),
                    color: AppColors.black60,
                  ),
                ),
              ],
            ),
          ),
          // ขวา: สถานะ + เลข
          if (isServing) ...[
            Text(
              'กำลังให้บริการ',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(14),
                color: AppColors.black60,
              ),
            ),
            SizedBox(width: context.rs(6)),
            Text(
              item.currentNumber!.toString().padLeft(3, '0'),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(14),
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              ),
            ),
          ] else ...[
            Text(
              'ว่าง',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(14),
                color: AppColors.black60,
              ),
            ),
            SizedBox(width: context.rs(6)),
            Text(
              '-',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(14),
                fontWeight: FontWeight.w800,
                color: AppColors.black60,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================
// _ServiceCard — card บริการแนะนำ (SVG icon เหมือน HomePageOne)
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
              colorFilter: ColorFilter.mode(
                  AppColors.black, BlendMode.srcIn),
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
