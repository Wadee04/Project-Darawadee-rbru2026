import 'package:flutter/material.dart';

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
                            icon: Icons.phone_outlined,
                            iconColor: AppColors.purple,
                            title: 'โทรศัพท์',
                            value: '02-123-4567',
                            subValue: 'จันทร์ - ศุกร์ 09:00 - 18:00 น.',
                            onTap: onPhone,
                          ),
                          _ContactItem(
                            icon: Icons.email_outlined,
                            iconColor: AppColors.purple,
                            title: 'อีเมล',
                            value: 'support@dentbook.com',
                            subValue: 'ตอบกลับภายใน 1-2 ชั่วโมง',
                            onTap: onEmail,
                            showDivider: true,
                          ),
                          _ContactItem(
                            icon: Icons.chat_outlined,
                            iconColor: const Color(0xFF06C755),
                            title: 'Line Official',
                            value: '@dentbook.app',
                            subValue: 'ตอบกลับภายใน 1-2 ชั่วโมง',
                            onTap: onLine,
                            showDivider: false,
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
        color: AppColors.purpleLight,
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
                      fontSize: context.rs(14),
                      fontWeight: FontWeight.w700,
                      color: AppColors.purple,
                    ),
                  ),
                  SizedBox(height: context.rs(6)),
                  Text(
                    'หากมีข้อสงสัย สัมภาษณ์\nหรือต้องการความช่วยเหลือ ติดต่อเราได้เลย',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(11),
                      fontWeight: FontWeight.w400,
                      color: AppColors.purple.withValues(alpha: 0.75),
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
              'assets/images/onboarding/toothmascot.png',
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
        color: AppColors.homeBackground,
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
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subValue,
    this.onTap,
    this.showDivider = true,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subValue;
  final VoidCallback? onTap;
  final bool showDivider;
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
                  width: context.rs(38),
                  height: context.rs(38),
                  decoration: BoxDecoration(
                    color: item.iconColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon,
                    size: context.rs(18),
                    color: item.iconColor,
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
                          fontSize: context.rs(13),
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: context.rs(2)),
                      Text(
                        item.value,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(12),
                          fontWeight: FontWeight.w400,
                          color: AppColors.textGray,
                        ),
                      ),
                      SizedBox(height: context.rs(1)),
                      Text(
                        item.subValue,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(11),
                          fontWeight: FontWeight.w400,
                          color: AppColors.inputHint,
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
        if (item.showDivider)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.rs(16)),
            child: const Divider(
              color: AppColors.inputBorder,
              height: 1,
              thickness: 0.5,
            ),
          ),
      ],
    );
  }
}
