import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// ScanStockPage — หน้าสแกนบาร์โค้ด/QR สินค้าสต็อก
// ============================================================
class ScanStockPage extends StatefulWidget {
  const ScanStockPage({
    super.key,
    this.onBack,
    this.onScanned,
  });

  final VoidCallback? onBack;
  final void Function(String barcode)? onScanned;

  @override
  State<ScanStockPage> createState() => _ScanStockPageState();
}

class _ScanStockPageState extends State<ScanStockPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scanLineCtrl;
  late final Animation<double> _scanLineAnim;

  // mock: จำลองว่ากำลังสแกนอยู่
  final bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    _scanLineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanLineAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scanLineCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scanLineCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenW = MediaQuery.of(context).size.width;
    final double screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ---- Camera preview placeholder ----
          SizedBox(
            width: screenW,
            height: screenH,
            child: Image.asset(
              'assets/images/onboarding/toothmascot.png',
              fit: BoxFit.cover,
              errorBuilder: (context, e, s) => Container(
                color: const Color(0xFF2A2A2A),
                child: Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: context.rs(80),
                    color: Colors.white24,
                  ),
                ),
              ),
            ),
          ),

          // ---- Dark overlay ----
          _ScanOverlay(screenW: screenW, screenH: screenH),

          // ---- Safe area content ----
          SafeArea(
            child: Column(
              children: [
                // ---- AppBar ----
                _ScanAppBar(onBack: widget.onBack),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ---- Scanner frame ----
                      _BarcodeFrame(
                        scanLineAnim: _scanLineAnim,
                        isScanning: _isScanning,
                      ),
                    ],
                  ),
                ),

                // ---- Bottom hint ----
                _BottomHint(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _ScanOverlay — overlay มืดรอบกรอบ
// ============================================================
class _ScanOverlay extends StatelessWidget {
  const _ScanOverlay({required this.screenW, required this.screenH});
  final double screenW;
  final double screenH;

  @override
  Widget build(BuildContext context) {
    final double frameSize = context.rs(260);
    final double frameCenterY = screenH * 0.42;

    return CustomPaint(
      size: Size(screenW, screenH),
      painter: _OverlayPainter(
        frameSize: frameSize,
        frameCenterY: frameCenterY,
        screenW: screenW,
        screenH: screenH,
      ),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  const _OverlayPainter({
    required this.frameSize,
    required this.frameCenterY,
    required this.screenW,
    required this.screenH,
  });

  final double frameSize;
  final double frameCenterY;
  final double screenW;
  final double screenH;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.55);
    final left = (screenW - frameSize) / 2;
    final top = frameCenterY - frameSize / 2;

    // Top
    canvas.drawRect(Rect.fromLTWH(0, 0, screenW, top), paint);
    // Bottom
    canvas.drawRect(Rect.fromLTWH(0, top + frameSize, screenW, screenH - top - frameSize), paint);
    // Left
    canvas.drawRect(Rect.fromLTWH(0, top, left, frameSize), paint);
    // Right
    canvas.drawRect(Rect.fromLTWH(left + frameSize, top, screenW - left - frameSize, frameSize), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================
// _ScanAppBar — back button + title
// ============================================================
class _ScanAppBar extends StatelessWidget {
  const _ScanAppBar({this.onBack});
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.rs(8),
        context.rs(8),
        context.rs(8),
        0,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ---- back button ----
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onBack ?? () => Navigator.maybePop(context),
              child: Container(
                padding: EdgeInsets.all(context.rs(8)),
                child: Icon(
                  Icons.chevron_left,
                  size: context.rs(28),
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          // ---- title ----
          Text(
            'แสกนสต็อก',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(15),
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _BarcodeFrame — กรอบสแกนบาร์โค้ด พร้อม corner + scan line
// ============================================================
class _BarcodeFrame extends StatelessWidget {
  const _BarcodeFrame({
    required this.scanLineAnim,
    required this.isScanning,
  });

  final Animation<double> scanLineAnim;
  final bool isScanning;

  @override
  Widget build(BuildContext context) {
    final double size = context.rs(260);
    final double cornerLen = context.rs(28);
    const double cornerThick = 3.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // ---- scan line animation ----
          if (isScanning)
            AnimatedBuilder(
              animation: scanLineAnim,
              builder: (context, child) {
                return Positioned(
                  top: size * scanLineAnim.value,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.orange.withValues(alpha: 0.9),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

          // ---- star icon (จากดีไซน์) ----
          Positioned(
            bottom: context.rs(14),
            right: context.rs(14),
            child: Icon(
              Icons.star,
              size: context.rs(22),
              color: AppColors.orange,
            ),
          ),

          // ---- Corner: top-left ----
          Positioned(
            top: 0, left: 0,
            child: _CornerMark(size: cornerLen, thick: cornerThick, tl: true),
          ),
          // ---- Corner: top-right ----
          Positioned(
            top: 0, right: 0,
            child: _CornerMark(size: cornerLen, thick: cornerThick, tr: true),
          ),
          // ---- Corner: bottom-left ----
          Positioned(
            bottom: 0, left: 0,
            child: _CornerMark(size: cornerLen, thick: cornerThick, bl: true),
          ),
          // ---- Corner: bottom-right ----
          Positioned(
            bottom: 0, right: 0,
            child: _CornerMark(size: cornerLen, thick: cornerThick, br: true),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _CornerMark — มุมกรอบสแกน
// ============================================================
class _CornerMark extends StatelessWidget {
  const _CornerMark({
    required this.size,
    required this.thick,
    this.tl = false,
    this.tr = false,
    this.bl = false,
    this.br = false,
  });

  final double size;
  final double thick;
  final bool tl, tr, bl, br;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CornerPainter(thick: thick, tl: tl, tr: tr, bl: bl, br: br),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  const _CornerPainter({
    required this.thick,
    this.tl = false,
    this.tr = false,
    this.bl = false,
    this.br = false,
  });

  final double thick;
  final bool tl, tr, bl, br;

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = AppColors.white
      ..strokeWidth = thick
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    if (tl) {
      canvas.drawLine(Offset(0, s.height), Offset(0, 0), p);
      canvas.drawLine(Offset(0, 0), Offset(s.width, 0), p);
    }
    if (tr) {
      canvas.drawLine(Offset(0, 0), Offset(s.width, 0), p);
      canvas.drawLine(Offset(s.width, 0), Offset(s.width, s.height), p);
    }
    if (bl) {
      canvas.drawLine(Offset(0, 0), Offset(0, s.height), p);
      canvas.drawLine(Offset(0, s.height), Offset(s.width, s.height), p);
    }
    if (br) {
      canvas.drawLine(Offset(s.width, 0), Offset(s.width, s.height), p);
      canvas.drawLine(Offset(0, s.height), Offset(s.width, s.height), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ============================================================
// _BottomHint — ข้อความล่างสุด
// ============================================================
class _BottomHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.rs(24),
        context.rs(16),
        context.rs(24),
        context.rs(32),
      ),
      child: Column(
        children: [
          Text(
            'ส่องกล้องไปที่บาร์โค้ดสินค้า',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(14),
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: context.rs(6)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.rs(20),
              vertical: context.rs(10),
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(context.rs(30)),
            ),
            child: Text(
              'ระบบจะสแกนอัตโนมัติเมื่อเจอรหัสสินค้า',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(12),
                fontWeight: FontWeight.w400,
                color: AppColors.white.withValues(alpha: 0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
