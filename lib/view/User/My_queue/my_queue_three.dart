import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/shared_widgets.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';
import 'my_queue_one.dart';

// ============================================================
// MyQueueThree - หน้าชำระมัดจำ (จากหน้าคิวของฉัน)
// เหมือน BookAnAppointmentNine แต่เข้าถึงจาก My Queue
// ============================================================
class MyQueueThree extends StatefulWidget {
  const MyQueueThree({
    super.key,
    required this.queue,
    this.onBack,
    this.onConfirm,
    this.accountName = 'ดาราวดี อาลัย',
    this.accountNumber = '067-1349768',
  });

  final QueueItem queue;
  final VoidCallback? onBack;
  final void Function(File? slipFile)? onConfirm;
  final String accountName;
  final String accountNumber;

  @override
  State<MyQueueThree> createState() => _MyQueueThreeState();
}

class _MyQueueThreeState extends State<MyQueueThree> {
  File? _slipFile;
  bool _isLoading = false;

  void _pickFile() => _showPickerSheet();
  void _openCamera() => _showPickerSheet(isCamera: true);

  void _showPickerSheet({bool isCamera = false}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.rs(16)),
        ),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          context.rs(24),
          context.rs(20),
          context.rs(24),
          context.rs(32),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: context.rs(36),
              height: context.rs(4),
              margin: EdgeInsets.only(bottom: context.rs(20)),
              decoration: BoxDecoration(
                color: AppColors.inputBorder,
                borderRadius: BorderRadius.circular(context.rs(99)),
              ),
            ),
            Icon(
              isCamera ? Icons.camera_alt_outlined : Icons.upload_file_outlined,
              size: context.rs(48),
              color: AppColors.purple,
            ),
            SizedBox(height: context.rs(12)),
            Text(
              isCamera ? 'เปิดกล้อง' : 'เลือกไฟล์',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(15),
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: context.rs(6)),
            Text(
              'กรุณาเพิ่ม package image_picker\nเพื่อใช้งานฟีเจอร์นี้',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(12),
                color: AppColors.textGray,
              ),
            ),
            SizedBox(height: context.rs(20)),
            SizedBox(
              width: double.infinity,
              height: context.rs(40),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.rs(30)),
                  ),
                ),
                child: Text(
                  'ตกลง',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleConfirm() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    widget.onConfirm?.call(_slipFile);
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.rs(16)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: context.rs(60),
              height: context.rs(60),
              decoration: const BoxDecoration(
                color: AppColors.greendentbook,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                size: context.rs(32),
                color: AppColors.white,
              ),
            ),
            SizedBox(height: context.rs(14)),
            Text(
              'ส่งหลักฐานสำเร็จ',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(16),
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: context.rs(6)),
            Text(
              'ระบบกำลังตรวจสอบการชำระเงิน\nคุณจะได้รับการยืนยันเร็วๆ นี้',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(12),
                color: AppColors.textGray,
                height: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context); // ปิด dialog
                Navigator.pop(context); // กลับ MyQueueTwo
                Navigator.pop(context); // กลับ MyQueueOne
              },
              child: Text(
                'กลับหน้าหลัก',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.purple,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
                AppBarBack(
                  title: 'ชำระมัดจำ',
                  onBack: widget.onBack,
                ),

                SizedBox(height: context.rs(16)),

                // ---- Scrollable ----
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      context.rs(24),
                      0,
                      context.rs(24),
                      context.rs(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ---- Summary mini card ----
                        _QueueSummaryCard(queue: widget.queue),

                        SizedBox(height: context.rs(16)),

                        // ---- Payment info ----
                        _PaymentCard(
                          clinicName: widget.queue.clinicName,
                          bookingId: widget.queue.bookingId,
                          accountName: widget.accountName,
                          accountNumber: widget.accountNumber,
                          depositAmount: widget.queue.depositAmount ?? 0,
                          slipFile: _slipFile,
                          onPickFile: _pickFile,
                          onOpenCamera: _openCamera,
                        ),
                      ],
                    ),
                  ),
                ),

                // ---- Bottom confirm ----
                _ConfirmBar(
                  isEnabled: _slipFile != null,
                  onConfirm: _handleConfirm,
                ),
              ],
            ),
          ),
          ),

          if (_isLoading) const ToothLoadingOverlay(),
        ],
      ),
    );
  }
}

// ============================================================
// _QueueSummaryCard — สรุปคิวย่อ
// ============================================================
class _QueueSummaryCard extends StatelessWidget {
  const _QueueSummaryCard({required this.queue});
  final QueueItem queue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rs(14)),
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(12)),
      ),
      child: Row(
        children: [
          Container(
            width: context.rs(40),
            height: context.rs(40),
            decoration: BoxDecoration(
              color: AppColors.purpleLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.medical_services_outlined,
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
                  queue.serviceName,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(13),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: context.rs(3)),
                Text(
                  '${queue.appointmentDate} • ${queue.appointmentTime}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(11),
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
// _PaymentCard — กล่องชำระ QR + อัปโหลดสลิป
// ============================================================
class _PaymentCard extends StatelessWidget {
  const _PaymentCard({
    required this.clinicName,
    required this.bookingId,
    required this.accountName,
    required this.accountNumber,
    required this.depositAmount,
    required this.slipFile,
    required this.onPickFile,
    required this.onOpenCamera,
  });

  final String clinicName;
  final String bookingId;
  final String accountName;
  final String accountNumber;
  final int depositAmount;
  final File? slipFile;
  final VoidCallback onPickFile;
  final VoidCallback onOpenCamera;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      padding: EdgeInsets.all(context.rs(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- หัวข้อ ----
          Text(
            'โปรดชำระมัดจำ',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(13),
              fontWeight: FontWeight.w500,
              color: AppColors.purple,
            ),
          ),
          SizedBox(height: context.rs(4)),
          Text(
            clinicName,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(15),
              fontWeight: FontWeight.w800,
              color: AppColors.purple,
            ),
          ),
          SizedBox(height: context.rs(6)),

          // ---- เลขอ้างอิง ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'เลขที่อ้างอิง',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(13),
                  fontWeight: FontWeight.w500,
                  color: AppColors.purple,
                ),
              ),
              Text(
                bookingId,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(13),
                  fontWeight: FontWeight.w700,
                  color: AppColors.purple,
                ),
              ),
            ],
          ),

          SizedBox(height: context.rs(6)),

          // ---- ยอดมัดจำ ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ยอดมัดจำ',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(13),
                  fontWeight: FontWeight.w500,
                  color: AppColors.purple,
                ),
              ),
              Text(
                '฿$depositAmount',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(18),
                  fontWeight: FontWeight.w800,
                  color: AppColors.purple,
                ),
              ),
            ],
          ),

          SizedBox(height: context.rs(20)),

          // ---- QR code ----
          Center(
            child: Container(
              width: context.rs(180),
              height: context.rs(180),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(context.rs(10)),
                border: Border.all(color: AppColors.inputBorder, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(context.rs(8)),
                child: Image.asset(
                  'assets/images/Book_an_appointment/qrcode.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, e, s) => Center(
                    child: Icon(
                      Icons.qr_code_2,
                      size: context.rs(80),
                      color: AppColors.purple,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: context.rs(16)),

          // ---- ข้อมูลบัญชี ----
          Center(
            child: Column(
              children: [
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(13),
                      fontWeight: FontWeight.w600,
                      color: AppColors.purple,
                    ),
                    children: [
                      const TextSpan(text: 'ชื่อบัญชี : '),
                      TextSpan(
                        text: accountName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.rs(4)),
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(13),
                      fontWeight: FontWeight.w600,
                      color: AppColors.purple,
                    ),
                    children: [
                      const TextSpan(text: 'เลขบัญชี : '),
                      TextSpan(
                        text: accountNumber,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: context.rs(22)),

          // ---- อัปโหลดสลิป ----
          Text(
            'แนบหลักฐานการชำระเงิน',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(13),
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: context.rs(8)),
          _SlipUpload(slipFile: slipFile, onPickFile: onPickFile),

          SizedBox(height: context.rs(16)),

          // ---- Divider or ----
          Row(
            children: [
              Expanded(child: Divider(color: AppColors.inputBorder, height: 1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.rs(12)),
                child: Text(
                  'หรือ',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(12),
                    color: AppColors.textGray,
                  ),
                ),
              ),
              Expanded(child: Divider(color: AppColors.inputBorder, height: 1)),
            ],
          ),

          SizedBox(height: context.rs(16)),

          // ---- ปุ่มเปิดกล้อง ----
          SizedBox(
            width: double.infinity,
            height: context.rs(38),
            child: ElevatedButton.icon(
              onPressed: onOpenCamera,
              icon: SvgPicture.asset(
                'assets/images/Book_an_appointment/solar_camera-bold.svg',
                width: context.rs(14),
                height: context.rs(14),
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
              label: Text(
                'ถ่ายรูปสลิปด้วยกล้อง',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(13),
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purple,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.rs(30)),
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
// _SlipUpload — กล่อง dashed สำหรับอัปโหลดสลิป
// ============================================================
class _SlipUpload extends StatelessWidget {
  const _SlipUpload({required this.slipFile, required this.onPickFile});
  final File? slipFile;
  final VoidCallback onPickFile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPickFile,
      child: Container(
        width: double.infinity,
        height: context.rs(130),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(context.rs(16)),
          border: Border.all(color: AppColors.purple, width: 1.5),
        ),
        child: slipFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(context.rs(14)),
                child: Image.file(slipFile!, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/Book_an_appointment/image.svg',
                    width: context.rs(20),
                    height: context.rs(20),
                    colorFilter: ColorFilter.mode(
                      AppColors.textGray,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(height: context.rs(8)),
                  Text(
                    'แตะเพื่อเลือกไฟล์',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(13),
                      color: AppColors.textGray,
                    ),
                  ),
                  SizedBox(height: context.rs(4)),
                  Text(
                    'รองรับไฟล์ JPG, PNG',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(10),
                      color: AppColors.inputHint,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ============================================================
// _ConfirmBar — ปุ่มยืนยันด้านล่าง
// ============================================================
class _ConfirmBar extends StatelessWidget {
  const _ConfirmBar({required this.isEnabled, required this.onConfirm});
  final bool isEnabled;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.fromLTRB(
        context.rs(24),
        context.rs(8),
        context.rs(24),
        context.rs(32),
      ),
      child: SizedBox(
        width: double.infinity,
        height: context.rs(42),
        child: ElevatedButton(
          onPressed: isEnabled ? onConfirm : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.purple,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.registerButton,
            disabledForegroundColor: AppColors.textGray,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.rs(30)),
            ),
          ),
          child: Text(
            'ยืนยันการชำระเงิน',
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
