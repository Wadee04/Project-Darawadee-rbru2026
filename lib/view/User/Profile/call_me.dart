import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/shared_widgets.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// CallMePage — หน้าติดต่อเรา
// ============================================================
class CallMePage extends StatelessWidget {
  const CallMePage({
    super.key,
    this.onBack,
    this.onPhone,
    this.onEmail,
    this.onLine,
  });

  final VoidCallback? onBack;
  final VoidCallback? onPhone;
  final VoidCallback? onEmail;
  final VoidCallback? onLine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.settingsBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- AppBar ----
              AppBarBack(
                title: 'ติดต่อเรา',
                onBack: onBack,
              ),

              // ---- Body ----
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.rs(16),
                    context.rs(16),
                    context.rs(16),
                    context.rs(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---- Hero banner ----
                      _HeroBanner(),

                      SizedBox(height: context.rs(20)),

                      // ---- section label ----
                      Padding(
                        padding: EdgeInsets.only(
                          left: context.rs(4),
                          bottom: context.rs(10),
                        ),
                        child: Text(
                          'ช่องทางการติดต่อ',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(13),
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ),

                      // ---- ช่องทางติดต่อ ----
                      _ContactCard(
                        items: [
                          _ContactItem(
                            iconAsset: 'assets/images/profile/griddy-icons_phone-filled.svg',
                            iconSize: 24,
                            title: 'โทรศัพท์',
                            value: '02-123-4567',
                            subValue: 'จันทร์ - ศุกร์ 09:00 - 18:00 น.',
                            onTap: onPhone,
                          ),
                          _ContactItem(
                            iconAsset: 'assets/images/profile/clarity_email-solid.svg',
                            iconSize: 24,
                            title: 'อีเมล',
                            value: 'support@dentbook.com',
                            subValue: 'ตอบกลับภายใน 1 วันทำการ',
                            onTap: onEmail,
                          ),
                          _ContactItem(
                            iconAsset: 'assets/images/profile/ri_line-fill.svg',
                            iconSize: 24,
                            title: 'Line Official',
                            value: '@dentbook.app',
                            subValue: 'ตอบกลับภายใน 1 วันทำการ',
                            onTap: onLine,
                          ),
                        ],
                      ),
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
}

// ============================================================
// _HeroBanner — banner พร้อม mascot
// ============================================================
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        context.rs(20),
        context.rs(20),
        0,
        context.rs(0),
      ),
      decoration: BoxDecoration(
        color: AppColors.blue15,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ---- text ----
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: context.rs(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'เราพร้อมช่วยคุณเสมอ',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: context.rs(6)),
                  Text(
                    'หากมีข้อสงสัย ปัญหา\nหรือต้องการความช่วยเหลือ ติดต่อเราได้เลย',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(11),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textGray,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---- mascot image ----
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(context.rs(16)),
            ),
            child: Image.asset(
              'assets/images/profile/mascot-orange.png',
              width: context.rs(110),
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter,
              errorBuilder: (context, e, s) => SizedBox(
                width: context.rs(110),
                height: context.rs(110),
                child: Icon(
                  Icons.sentiment_very_satisfied_outlined,
                  size: context.rs(60),
                  color: AppColors.purple,
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
// _ContactCard — กล่างรายการช่องทางติดต่อ
// ============================================================
class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.items});
  final List<_ContactItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Column(
        children: items.map((item) => _ContactRow(item: item)).toList(),
      ),
    );
  }
}

class _ContactItem {
  const _ContactItem({
    required this.iconAsset,
    this.iconSize,
    required this.title,
    required this.value,
    required this.subValue,
    this.onTap,
  });

  final String iconAsset;
  final double? iconSize;
  final String title;
  final String value;
  final String subValue;
  final VoidCallback? onTap;
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.item});
  final _ContactItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(context.rs(16)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.rs(16),
              vertical: context.rs(14),
            ),
            child: Row(
              children: [
                // ---- icon circle ----
                Container(
                  width: context.rs(36),
                  height: context.rs(36),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.lavender,
                    borderRadius: BorderRadius.circular(context.rs(8)),
                  ),
                  child: SvgPicture.asset(
                    item.iconAsset,
                    width: context.rs(item.iconSize ?? 16),
                    height: context.rs(item.iconSize ?? 16),
                    colorFilter: ColorFilter.mode(
                      AppColors.purple,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: context.rs(12)),
                // ---- text ----
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(14),
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: context.rs(2)),
                      Text(
                        item.value,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(10),
                          fontWeight: FontWeight.w400,
                          color: AppColors.textGray,
                        ),
                      ),
                      SizedBox(height: context.rs(1)),
                      Text(
                        item.subValue,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(10),
                          fontWeight: FontWeight.w400,
                          color: AppColors.textGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: context.rs(18),
                  color: AppColors.textGray,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
