import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../components/shared_widgets.dart';
import '../../../services/service_locator.dart';
import '../../../supabase_client.dart';
import 'book_an_appointment_ten.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// BookAnAppointmentNine - หน้าชำระมัดจำ
// ============================================================

class BookAnAppointmentNine extends StatefulWidget {
  const BookAnAppointmentNine({
    super.key,
    this.onBack,
    this.onConfirm,
    this.bookingId = 'SC680516-001',
    this.accountName = 'ดาราวดี อาลัย',
    this.accountNumber = '067-1349768',
    this.clinicName = 'DentBook Clinic',
    this.qrImageAsset,
  });

  final VoidCallback? onBack;
  final void Function(XFile? slipFile)? onConfirm;
  final String bookingId;
  final String accountName;
  final String accountNumber;
  final String clinicName;
  final String? qrImageAsset;

  @override
  State<BookAnAppointmentNine> createState() => _BookAnAppointmentNineState();
}

class _BookAnAppointmentNineState extends State<BookAnAppointmentNine> {
  XFile? _slipFile;
  final ImagePicker _picker = ImagePicker();

  // ---- เลือกรูปจาก Gallery ----
  Future<void> _pickFile() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked != null && mounted) {
        setState(() => _slipFile = picked);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ไม่สามารถเลือกรูปได้: $e')),
        );
      }
    }
  }

  // ---- ถ่ายรูปด้วยกล้อง ----
  Future<void> _openCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (photo != null && mounted) {
        setState(() => _slipFile = photo);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ไม่สามารถเปิดกล้องได้: $e')),
        );
      }
    }
  }

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
              onBack: widget.onBack,
            ),

            SizedBox(height: context.rs(19)),

            // ---- Scrollable content ----
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
                    // ---- ส่วนรายละเอียดชำระ ----
                    _PaymentInfoCard(
                      clinicName: widget.clinicName,
                      bookingId: widget.bookingId,
                      accountName: widget.accountName,
                      accountNumber: widget.accountNumber,
                      qrImageAsset: widget.qrImageAsset,
                      slipFile: _slipFile,
                      onPickFile: () => _pickFile(),
                      onOpenCamera: () => _openCamera(),
                    ),

                    SizedBox(height: context.rs(20)),
                  ],
                ),
              ),
            ),

            // ---- ปุ่มยืนยัน ----
            _BottomConfirmBar(
              isEnabled: _slipFile != null,
              onConfirm: () {
                widget.onConfirm?.call(_slipFile);
                Navigator.push(
                  context,
                  noAnimRoute(const BookAnAppointmentTen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _PaymentInfoCard — กรอบสีม่วงอ่อน: หัวข้อ + QR + ข้อมูลบัญชี
// ============================================================
class _PaymentInfoCard extends StatelessWidget {
  const _PaymentInfoCard({
    required this.clinicName,
    required this.bookingId,
    required this.accountName,
    required this.accountNumber,
    required this.slipFile,
    required this.onPickFile,
    required this.onOpenCamera,
    this.qrImageAsset,
  });

  final String clinicName;
  final String bookingId;
  final String accountName;
  final String accountNumber;
  final XFile? slipFile;
  final VoidCallback onPickFile;
  final VoidCallback onOpenCamera;
  final String? qrImageAsset;

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
            'โปรดชำระระเบียนมัดจำ',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(14),
              fontWeight: FontWeight.w500,
              color: AppColors.purple,
            ),
          ),

          SizedBox(height: context.rs(6)),

          Text(
            clinicName,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(16),
              fontWeight: FontWeight.w800,
              color: AppColors.purple,
            ),
          ),

          SizedBox(height: context.rs(6)),

          // ---- เลขที่อ้างอิง ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'เลขที่อ้างอิง',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(14),
                  fontWeight: FontWeight.w500,
                  color: AppColors.purple,
                ),
              ),
              Text(
                bookingId,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(14),
                  fontWeight: FontWeight.w700,
                  color: AppColors.purple,
                ),
              ),
            ],
          ),

          SizedBox(height: context.rs(20)),

          // ---- QR Code ----
          Center(
            child: _QrBox(
              imageAsset: 'assets/images/Book_an_appointment/qrcode.png',
            ),
          ),

          SizedBox(height: context.rs(20)),

          // ---- ข้อมูลบัญชี ----
          Center(
            child: Column(
              children: [
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.purple,
                    ),
                    children: [
                      TextSpan(text: 'ชื่อบัญชี : '),
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
                      fontSize: context.rs(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.purple,
                    ),
                    children: [
                      TextSpan(text: 'เลขบัญชี : '),
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

          _SlipUploadSection(
            slipFile: slipFile,
            onPickFile: onPickFile,
          ),

          SizedBox(height: context.rs(24)),

          _OrDivider(),

          SizedBox(height: context.rs(24)),

          SizedBox(
            width: double.infinity,
            height: context.rs(36),
            child: ElevatedButton.icon(
              onPressed: () => onOpenCamera(),
              icon: SvgPicture.asset(
                'assets/images/Book_an_appointment/solar_camera-bold.svg',
                width: context.rs(12),
                height: context.rs(12),
                colorFilter: ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
              label: Text(
                'Open Camera & Take Photo',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(11),
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
// _QrBox — กล่อง QR code (placeholder ถ้าไม่มี asset)
// ============================================================
class _QrBox extends StatelessWidget {
  const _QrBox({this.imageAsset});
  final String? imageAsset;

  @override
  Widget build(BuildContext context) {
    final double size = context.rs(180);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.rs(10)),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: imageAsset != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(context.rs(8)),
              child: Image.asset(
                imageAsset!,
                fit: BoxFit.cover,
              ),
            )
          : _QrPlaceholder(),
    );
  }
}

// ---- QR placeholder วาดด้วย CustomPaint ----
class _QrPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _QrPainter(),
    );
  }
}

class _QrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint fill = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;

    final Paint empty = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    final double cell = size.width / 21; // QR grid 21x21 (version 1)

    // -- วาด 3 มุม finder pattern --
    _drawFinderPattern(canvas, fill, empty, 0, 0, cell);
    _drawFinderPattern(canvas, fill, empty, 14 * cell, 0, cell);
    _drawFinderPattern(canvas, fill, empty, 0, 14 * cell, cell);

    // -- วาด data dots ตัวอย่าง (pattern สุ่มเพื่อให้ดูเหมือน QR) --
    final List<Offset> dots = [
      Offset(8, 2), Offset(9, 2), Offset(12, 2),
      Offset(8, 4), Offset(10, 4), Offset(11, 4),
      Offset(8, 6), Offset(9, 6), Offset(13, 6),
      Offset(2, 9), Offset(4, 9), Offset(6, 9), Offset(8, 9), Offset(10, 9), Offset(12, 9), Offset(14, 9), Offset(16, 9), Offset(18, 9),
      Offset(9, 10), Offset(11, 10), Offset(15, 10), Offset(17, 10),
      Offset(2, 11), Offset(5, 11), Offset(8, 11), Offset(11, 11), Offset(14, 11),
      Offset(3, 12), Offset(6, 12), Offset(9, 12), Offset(12, 12), Offset(15, 12), Offset(18, 12),
      Offset(2, 13), Offset(4, 13), Offset(7, 13), Offset(10, 13), Offset(13, 13), Offset(16, 13),
      Offset(3, 14), Offset(5, 14), Offset(8, 14), Offset(11, 14), Offset(14, 14), Offset(17, 14),
      Offset(16, 10), Offset(17, 11), Offset(18, 10),
      Offset(2, 16), Offset(4, 16), Offset(6, 16), Offset(8, 16), Offset(10, 16),
      Offset(3, 17), Offset(5, 17), Offset(7, 17), Offset(9, 17), Offset(11, 17), Offset(13, 17),
      Offset(2, 18), Offset(6, 18), Offset(10, 18), Offset(12, 18),
      Offset(3, 19), Offset(5, 19), Offset(9, 19), Offset(11, 19), Offset(13, 19),
    ];

    for (final d in dots) {
      canvas.drawRect(
        Rect.fromLTWH(d.dx * cell, d.dy * cell, cell * 0.85, cell * 0.85),
        fill,
      );
    }
  }

  void _drawFinderPattern(
    Canvas canvas,
    Paint fill,
    Paint empty,
    double x,
    double y,
    double cell,
  ) {
    // outer 7×7
    canvas.drawRect(Rect.fromLTWH(x, y, cell * 7, cell * 7), fill);
    // inner white 5×5
    canvas.drawRect(
      Rect.fromLTWH(x + cell, y + cell, cell * 5, cell * 5),
      empty,
    );
    // center 3×3
    canvas.drawRect(
      Rect.fromLTWH(x + cell * 2, y + cell * 2, cell * 3, cell * 3),
      fill,
    );
  }

  @override
  bool shouldRepaint(_QrPainter old) => false;
}

// ============================================================
// _SlipUploadSection — กรอบ dashed สำหรับอัปโหลดสลิป
// ============================================================
class _SlipUploadSection extends StatelessWidget {
  const _SlipUploadSection({
    required this.slipFile,
    required this.onPickFile,
  });

  final XFile? slipFile;
  final VoidCallback onPickFile;

  @override
  Widget build(BuildContext context) {
    if (slipFile != null) {
      return _SlipPreviewCard(
        slipFile: slipFile!,
        onReplace: onPickFile,
      );
    }

    // ---- Empty state ----
    return GestureDetector(
      onTap: () => onPickFile(),
      child: Container(
        width: double.infinity,
        height: context.rs(140),
        decoration: BoxDecoration(
          color: AppColors.homeBackground,
          borderRadius: BorderRadius.circular(context.rs(16)),
          border: Border.all(color: AppColors.purple, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/Book_an_appointment/image.svg',
              width: context.rs(18),
              height: context.rs(18),
              colorFilter: ColorFilter.mode(AppColors.textGray, BlendMode.srcIn),
            ),
            SizedBox(height: context.rs(8)),
            Text(
              'Select image',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(14),
                fontWeight: FontWeight.w400,
                color: AppColors.textGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _SlipPreviewCard — card แสดงสลิปหลังเพิ่มรูปแล้ว
// ============================================================
class _SlipPreviewCard extends StatelessWidget {
  const _SlipPreviewCard({
    required this.slipFile,
    required this.onReplace,
  });

  final XFile slipFile;
  final VoidCallback onReplace;

  @override
  Widget build(BuildContext context) {
    // รูป thumbnail: web ใช้ Image.network, mobile ใช้ Image.file
    final Widget thumbnail = ClipRRect(
      borderRadius: BorderRadius.circular(context.rs(10)),
      child: kIsWeb
          ? Image.network(
              slipFile.path,
              width: context.rs(72),
              height: context.rs(72),
              fit: BoxFit.cover,
            )
          : Image.file(
              File(slipFile.path),
              width: context.rs(72),
              height: context.rs(72),
              fit: BoxFit.cover,
            ),
    );

    // ชื่อไฟล์สั้น
    final String fileName = slipFile.name.isNotEmpty
        ? slipFile.name
        : slipFile.path.split('/').last;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rs(12)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.rs(16)),
        border: Border.all(color: AppColors.inputBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- thumbnail + info ----
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              thumbnail,
              SizedBox(width: context.rs(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // icon แถบสลิป
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.rs(8),
                        vertical: context.rs(4),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.homeBackground,
                        borderRadius: BorderRadius.circular(context.rs(8)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: context.rs(14),
                            color: AppColors.purple,
                          ),
                          SizedBox(width: context.rs(6)),
                          Text(
                            'สลิปการโอนเงิน',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: context.rs(11),
                              fontWeight: FontWeight.w500,
                              color: AppColors.purple,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.rs(6)),
                    Text(
                      'ไฟล์รูปภาพ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(10),
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: context.rs(10)),

          // ---- ชื่อไฟล์ + ปุ่มเปลี่ยนรูป ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  fileName,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(11),
                    color: AppColors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: context.rs(8)),
              GestureDetector(
                onTap: onReplace,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.rs(10),
                    vertical: context.rs(5),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.homeBackground,
                    borderRadius: BorderRadius.circular(context.rs(20)),
                    border: Border.all(color: AppColors.inputBorder, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: context.rs(12),
                        color: AppColors.purple,
                      ),
                      SizedBox(width: context.rs(4)),
                      Text(
                        'เปลี่ยนรูป',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(11),
                          fontWeight: FontWeight.w500,
                          color: AppColors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _OrDivider — เส้น or ตรงกลาง
// ============================================================
class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: AppColors.inputBorder, height: 1),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.rs(12)),
          child: Text(
            'or',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(13),
              fontWeight: FontWeight.w400,
              color: AppColors.textGray,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: AppColors.inputBorder, height: 1),
        ),
      ],
    );
  }
}

// ============================================================
// _BottomConfirmBar — ปุ่มยืนยันด้านล่าง (สีเทา ตาม Figma)
// ============================================================
class _BottomConfirmBar extends StatelessWidget {
  const _BottomConfirmBar({
    required this.isEnabled,
    required this.onConfirm,
  });

  final bool isEnabled;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: EdgeInsets.fromLTRB(
        context.rs(24),
        context.rs(8),
        context.rs(24),
        context.rs(48),
      ),
      child: SizedBox(
        height: context.rs(40),
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
            'ยืนยัน',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(14),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
