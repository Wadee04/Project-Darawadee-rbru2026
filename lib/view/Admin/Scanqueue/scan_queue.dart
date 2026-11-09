import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// ScanQueuePage — หน้าสแกน QR Code คิวของผู้ป่วย
// ============================================================
class ScanQueuePage extends StatefulWidget {
  const ScanQueuePage({
    super.key,
    this.onAddWalkIn,
    this.onNavTap,
    this.currentNavIndex = 1,
  });

  final VoidCallback? onAddWalkIn;
  final void Function(int)? onNavTap;
  final int currentNavIndex;

  @override
  State<ScanQueuePage> createState() => _ScanQueuePageState();
}

class _ScanQueuePageState extends State<ScanQueuePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scanLineCtrl;
  late final Animation<double> _scanLineAnim;

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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // พื้นหลังสีม่วงเข้มตามดีไซน์
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4B4B9F),
              Color(0xFF3A3A8C),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- Title ----
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.rs(20),
                  context.rs(16),
                  context.rs(20),
                  0,
                ),
                child: Text(
                  'สแกน QR โค้ดของผู้ป่วยเพื่อเช็คอิน',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(14),
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // ---- Body ----
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ---- QR Scanner Frame ----
                    _QRScannerFrame(scanLineAnim: _scanLineAnim),

                    SizedBox(height: context.rs(32)),

                    // ---- หรือ divider ----
                    _OrDivider(),

                    SizedBox(height: context.rs(20)),

                    // ---- Walk-in section ----
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.rs(32)),
                      child: Column(
                        children: [
                          // ---- label ----
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: context.rs(14),
                              horizontal: context.rs(16),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(context.rs(12)),
                            ),
                            child: Text(
                              'สำหรับลูกค้าที่มาหน้าร้าน (ไม่มีมือถือ/แอป)',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: context.rs(12),
                                color: AppColors.white.withValues(alpha: 0.85),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(height: context.rs(10)),

                          // ---- ปุ่มเพิ่มลูกค้าหน้าร้าน ----
                          GestureDetector(
                            onTap: widget.onAddWalkIn,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: context.rs(14),
                                horizontal: context.rs(16),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.12),
                                borderRadius:
                                    BorderRadius.circular(context.rs(12)),
                                border: Border.all(
                                  color:
                                      AppColors.white.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: context.rs(16),
                                    color: AppColors.white,
                                  ),
                                  SizedBox(width: context.rs(6)),
                                  Text(
                                    'เพิ่มคิวลูกค้าหน้าร้าน',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: context.rs(13),
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ---- Bottom Nav ----
              _AdminBottomNav(
                currentIndex: widget.currentNavIndex,
                onTap: widget.onNavTap ?? (_) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _QRScannerFrame — กรอบสแกน QR พร้อม scan line animation
// ============================================================
class _QRScannerFrame extends StatelessWidget {
  const _QRScannerFrame({required this.scanLineAnim});
  final Animation<double> scanLineAnim;

  static const double _frameSize = 240;

  @override
  Widget build(BuildContext context) {
    final double size = context.rs(_frameSize);
    final double cornerSize = context.rs(28);
    const double cornerThickness = 3.0;
    const Color cornerColor = Colors.white;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // ---- QR image placeholder ----
          ClipRRect(
            borderRadius: BorderRadius.circular(context.rs(8)),
            child: Container(
              width: size,
              height: size,
              color: AppColors.white,
              child: Image.asset(
                'assets/images/Book_an_appointment/qrcode.png',
                fit: BoxFit.cover,
                errorBuilder: (context, e, s) => Center(
                  child: Icon(
                    Icons.qr_code_2,
                    size: context.rs(120),
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
          ),

          // ---- scan line ----
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
                        AppColors.purple.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // ---- Corner: top-left ----
          Positioned(
            top: 0,
            left: 0,
            child: _Corner(
              size: cornerSize,
              thickness: cornerThickness,
              color: cornerColor,
              topLeft: true,
            ),
          ),
          // ---- Corner: top-right ----
          Positioned(
            top: 0,
            right: 0,
            child: _Corner(
              size: cornerSize,
              thickness: cornerThickness,
              color: cornerColor,
              topRight: true,
            ),
          ),
          // ---- Corner: bottom-left ----
          Positioned(
            bottom: 0,
            left: 0,
            child: _Corner(
              size: cornerSize,
              thickness: cornerThickness,
              color: cornerColor,
              bottomLeft: true,
            ),
          ),
          // ---- Corner: bottom-right ----
          Positioned(
            bottom: 0,
            right: 0,
            child: _Corner(
              size: cornerSize,
              thickness: cornerThickness,
              color: cornerColor,
              bottomRight: true,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _Corner — มุมสแกนเนอร์
// ============================================================
class _Corner extends StatelessWidget {
  const _Corner({
    required this.size,
    required this.thickness,
    required this.color,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  final double size;
  final double thickness;
  final Color color;
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CornerPainter(
          thickness: thickness,
          color: color,
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  const _CornerPainter({
    required this.thickness,
    required this.color,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  final double thickness;
  final Color color;
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final w = size.width;
    final h = size.height;

    if (topLeft) {
      canvas.drawLine(Offset(0, h), Offset(0, 0), paint);
      canvas.drawLine(Offset(0, 0), Offset(w, 0), paint);
    }
    if (topRight) {
      canvas.drawLine(Offset(0, 0), Offset(w, 0), paint);
      canvas.drawLine(Offset(w, 0), Offset(w, h), paint);
    }
    if (bottomLeft) {
      canvas.drawLine(Offset(0, 0), Offset(0, h), paint);
      canvas.drawLine(Offset(0, h), Offset(w, h), paint);
    }
    if (bottomRight) {
      canvas.drawLine(Offset(w, 0), Offset(w, h), paint);
      canvas.drawLine(Offset(0, h), Offset(w, h), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================
// _OrDivider — เส้นคั่น "หรือ"
// ============================================================
class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.rs(40)),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: AppColors.white.withValues(alpha: 0.3),
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.rs(12)),
            child: Text(
              'หรือ',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(12),
                color: AppColors.white.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: AppColors.white.withValues(alpha: 0.3),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _AdminBottomNav — bottom navigation bar ของ Admin
// ============================================================
class _AdminBottomNav extends StatelessWidget {
  const _AdminBottomNav({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'ภาพรวม'),
    _NavItem(icon: Icons.qr_code_scanner, activeIcon: Icons.qr_code_scanner, label: 'สแกนคิว'),
    _NavItem(icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2, label: 'สต็อก'),
    _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'โปรไฟล์'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A8C),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: context.rs(8)),
          child: Row(
            children: _items.asMap().entries.map((e) {
              final isSelected = e.key == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(e.key),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ---- scan icon มี container พิเศษ ----
                      if (e.key == 1)
                        Container(
                          width: context.rs(40),
                          height: context.rs(40),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.orange
                                : AppColors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            e.value.activeIcon,
                            size: context.rs(20),
                            color: AppColors.white,
                          ),
                        )
                      else
                        Icon(
                          isSelected ? e.value.activeIcon : e.value.icon,
                          size: context.rs(22),
                          color: isSelected
                              ? AppColors.white
                              : AppColors.white.withValues(alpha: 0.5),
                        ),
                      SizedBox(height: context.rs(3)),
                      Text(
                        e.value.label,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(10),
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? AppColors.white
                              : AppColors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
