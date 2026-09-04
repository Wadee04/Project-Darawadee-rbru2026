import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';
import '../Book_an_appointment/book_an_appointment_one.dart';
import 'home_page_one.dart';
import 'home_page_two.dart';

// ============================================================
// HomePageThree - หน้าหลัก (สถานะ: เลือกคลินิกแล้ว ยังไม่มีนัด)
// ============================================================
class HomePageThree extends StatefulWidget {
  const HomePageThree({
    super.key,
    this.userName = 'คุณดาราวดี อลัย',
    this.clinicName = 'Dentbook Clinic',
    this.clinicProvince = 'กรุงเทพมหานคร',
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
  final ClinicQueueItem queueItem;
  final VoidCallback? onNotification;
  final VoidCallback? onProfile;
  final VoidCallback? onSelectClinic;
  final VoidCallback? onBooking;
  final VoidCallback? onMyQueue;

  @override
  State<HomePageThree> createState() => _HomePageThreeState();
}

class _HomePageThreeState extends State<HomePageThree> {
  int _navIndex = 0;

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

                    // ---- Location bar ----
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

                    // ---- Appointment card (ยังไม่มีนัด) ----
                    _NoAppointmentCard(onBooking: widget.onBooking),

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
// _IconBtn
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
// _NoAppointmentCard — card เมื่อยังไม่มีนัดหมาย
// ============================================================
class _NoAppointmentCard extends StatelessWidget {
  const _NoAppointmentCard({this.onBooking});
  final VoidCallback? onBooking;

  @override
  Widget build(BuildContext context) {
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
            'ยังไม่มีการนัดหมาย',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(14),
              fontWeight: FontWeight.w400,
              color: AppColors.white.withValues(alpha: 0.75),
            ),
          ),
          SizedBox(height: context.rs(13)),
          Text(
            'จองคิวล่วงหน้าไม่ต้องรอหน้าคลินิก',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(16),
              fontWeight: FontWeight.w700,
              color: AppColors.white,
              height: 1.1,
            ),
          ),
          SizedBox(height: context.rs(8)),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BookAnAppointmentOne(),
                ),
              );
            },
            child: Text(
              'จองคิวเลย',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(14),
                fontWeight: FontWeight.w500,
                color: AppColors.white.withValues(alpha: 0.9),
                decoration: TextDecoration.underline,
                decorationColor: AppColors.white.withValues(alpha: 0.9),
              ),
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
// _ServiceCard
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
