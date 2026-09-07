// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:ant_icons_plus/ant_icons_plus.dart';

import '../../components/shared_widgets.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';
import 'getting_started_user.dart';

/// หน้าเลือกประเภทบัญชี (Select Account Type)
///
/// โครงหน้า: แถบหัวสีม่วงพร้อมโลโก้ DentBook ด้านบน แล้วมี "แผ่นการ์ดสีขาว"
/// มุมโค้งซ้อนขึ้นมา บรรจุหัวข้อต้อนรับ + การ์ดเลือกบัญชี 2 ใบ (User / Admin)
/// และข้อความความปลอดภัยด้านล่าง
///
/// Responsive: ใช้ LayoutBuilder + context.rs() ให้ทุกอย่างย่อ/ขยายตามหน้าจอ
/// - มือถือ  : เนื้อหาเต็มความกว้าง
/// - แท็บเล็ต/เดสก์ท็อป (กว้าง >= 600) : จำกัดความกว้างเนื้อหาไว้กึ่งกลาง
///
/// หมายเหตุ: ยังไม่ต่อ logic จริง (การกดการ์ดยังไม่พาไปหน้าไหน) รอสั่งขั้นถัดไป
class SelectAccountType extends StatelessWidget {
  const SelectAccountType({super.key});

  // เกินความกว้างนี้ถือว่าเป็นแท็บเล็ต/เดสก์ท็อป
  static const double _tabletBreakpoint = 600;

  // ความกว้างเนื้อหาสูงสุดบนจอกว้าง (จัดกึ่งกลาง)
  static const double _maxContentWidth = 440;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purple,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final double height = constraints.maxHeight;
          final bool isTablet = width >= _tabletBreakpoint;

          // สัดส่วนแถบหัวสีม่วง (จอเตี้ยลดสัดส่วนลงเล็กน้อยกันล้น)
          final double headerHeight =
              (height * (isTablet ? 0.30 : 0.28)).clamp(180.0, 320.0);

          return Stack(
            children: [
              // ---- แถบหัวสีม่วง + โลโก้ ----
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: headerHeight,
                child: const SafeArea(
                  bottom: false,
                  // ค่าดีไซน์ 32 — BrandLogo จะปรับสเกลตามหน้าจอให้เอง
                  child: Center(
                    child: BrandLogo(fontSize: 32),
                  ),
                ),
              ),

              // ---- แผ่นการ์ดสีขาวมุมโค้ง (ซ้อนขึ้นมาทับแถบม่วง) ----
              Positioned(
                top: headerHeight - context.rs(24),
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(context.rs(28)),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(maxWidth: _maxContentWidth),
                        child: LayoutBuilder(
                          builder: (context, sheetConstraints) {
                            return SingleChildScrollView(
                              padding: EdgeInsets.fromLTRB(
                                context.rs(24),
                                context.rs(35),
                                context.rs(24),
                                context.rs(48),
                              ),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: (sheetConstraints.maxHeight -
                                          context.rs(28) -
                                          context.rs(48))
                                      .clamp(0.0, double.infinity),
                                ),
                                child: IntrinsicHeight(
                                  child: const _SheetContent(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// เนื้อหาภายในแผ่นการ์ดสีขาว (หัวข้อ + การ์ด 2 ใบ + footer)
class _SheetContent extends StatelessWidget {
  const _SheetContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---- หัวข้อต้อนรับ ----
        Text(
          'ยินดีต้อนรับ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(16),
            fontWeight: FontWeight.w800,
            color: AppColors.purple,
          ),
        ),
        SizedBox(height: context.rs(6)),
        Text(
          'กรุณาเลือกประเภทบัญชีเพื่อ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(16),
            fontWeight: FontWeight.w400,
            color: AppColors.textGray,
          ),
        ),
        SizedBox(height: context.rs(41)),

        // ---- การ์ดผู้ใช้ (User) โทนฟ้า/ม่วง ----
        AccountTypeCard(
          icon: Container(
            width: context.rs(89),
            height: context.rs(89),
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/images/onboarding/user1.png',
              width: context.rs(24),
              height: context.rs(24),
            ),
          ),
          title: 'เข้าสู่ระบบและลงทะเบียน\nสำหรับผู้ใช้(User)',
          description: 'จองคิว ดูประวัติการนัดหมาย\nและจัดการข้อมูลส่วนตัว',
          backgroundColor: AppColors.userCardBg,
          accentColor: AppColors.purple,
          arrowColor: AppColors.purpleLight,
          iconColor: AppColors.purple,
          onTap: () {
            Navigator.push(
              context,
              noAnimRoute(const GettingStartedUser()),
            );
          },
        ),
        SizedBox(height: context.rs(30)),

        // ---- การ์ดแอดมิน (Admin) โทนส้ม ----
        AccountTypeCard(
          icon: Container(
            width: context.rs(89),
            height: context.rs(89),
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/images/onboarding/security2.png',
              width: context.rs(24),
              height: context.rs(24),
            ),
          ),
          title: 'เข้าสู่ระบบและลงทะเบียน\nสำหรับผู้แอดมิน(Admin)',
          description: 'จัดการคลินิก จัดการนัดหมาย\nและข้อมูลระบบ',
          backgroundColor: AppColors.adminCardBg,
          accentColor: AppColors.orange,
          arrowColor: AppColors.orangeLight,
          iconColor: AppColors.orange,
          onTap: () {
            // ยังไม่ต่อ logic (รอสั่งในขั้นถัดไป)
          },
        ),
        // ดันข้อความความปลอดภัยไปชิดขอบล่าง
        const Spacer(),
        SizedBox(height: context.rs(12)),

        // ---- ข้อความความปลอดภัยด้านล่าง ----
        Center(
          child: Container(
            width: context.rs(327),
            height: context.rs(40),
            padding: EdgeInsets.symmetric(
              horizontal: context.rs(16),
              vertical: context.rs(12),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(context.rs(45)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  AntIcons.safetyOutlined,
                  size: context.rs(14),
                  color: AppColors.textGray,
                ),
                SizedBox(width: context.rs(6)),
                Text(
                  'ปลอดภัย มั่นใจ ใช้งานได้กับทุกคลินิกทันตกรรม',
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
        ),
      ],
    );
  }
}

class AccountTypeCard extends StatelessWidget {
  const AccountTypeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.accentColor,
    required this.arrowColor,
    required this.iconColor,
    this.onTap,
  });

  final Widget icon;
  final String title;
  final String description;
  final Color backgroundColor;
  final Color accentColor;
  final Color arrowColor;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(context.rs(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.rs(16)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.rs(14),
            vertical: context.rs(16),
          ),
          child: Row(
            children: [
              icon,
              SizedBox(width: context.rs(14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(14),
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        color: accentColor,
                      ),
                    ),
                    SizedBox(height: context.rs(4)),
                    Text(
                      description,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(10.5),
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.rs(10)),
              Container(
                width: context.rs(26),
                height: context.rs(26),
                decoration: BoxDecoration(
                  color: arrowColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_right,
                  color: iconColor,
                  size: context.rs(18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
