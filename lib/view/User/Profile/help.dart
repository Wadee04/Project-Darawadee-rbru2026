import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/shared_widgets.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// HelpPage — หน้าช่วยเหลือ
// ============================================================
class HelpPage extends StatelessWidget {
  const HelpPage({
    super.key,
    this.onBack,
    this.onSeeAll,
    this.onEmailContact,
    this.onPhoneContact,
    this.onFaqTap,
  });

  final VoidCallback? onBack;
  final VoidCallback? onSeeAll;
  final VoidCallback? onEmailContact;
  final VoidCallback? onPhoneContact;
  final void Function(String topic)? onFaqTap;

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
                title: 'ช่วยเหลือ',
                onBack: onBack,
              ),

              // ---- Body ----
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.rs(24),
                    context.rs(16),
                    context.rs(24),
                    context.rs(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---- Hero banner ----
                      _HeroBanner(),

                      SizedBox(height: context.rs(20)),

                      // ---- คำถามที่พบบ่อย header ----
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'คำถามที่พบบ่อย',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: context.rs(14),
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: onSeeAll,
                            child: Text(
                              'ดูทั้งหมด',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: context.rs(14),
                                fontWeight: FontWeight.w400,
                                color: AppColors.purple,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: context.rs(10)),

                      // ---- FAQ list ----
                      _FaqCard(
                        items: [
                          _FaqItem(
                            imageAsset: 'assets/images/profile/mini-message-box.png',
                            imageWidth: 28,
                            imageHeight: 24,
                            title: 'การจองและนัดหมาย',
                            subtitle: 'การจองคิว, เลื่อนนัด, ยกเลิกนัด',
                          ),
                          _FaqItem(
                            imageAsset: 'assets/images/profile/famicons_card.png',
                            imageWidth: 20,
                            imageHeight: 20,
                            title: 'การชำระและการมัดจำ',
                            subtitle: 'การชำระเงิน, แก้ไขข้อมูล, การคืนเงิน',
                          ),
                          _FaqItem(
                            imageAsset: 'assets/images/profile/mini-healthicons_clinic.png',
                            imageWidth: 21,
                            imageHeight: 21,
                            title: 'เกี่ยวกับคลินิก',
                            subtitle: 'บริการ, โปรโมชั่น, สาขา',
                          ),
                          _FaqItem(
                            imageAsset: 'assets/images/profile/weui_setting-filled.png',
                            imageWidth: 24,
                            imageHeight: 24,
                            title: 'การใช้งานแอป',
                            subtitle: 'การใช้งานทั่วไป, การตั้งค่า',
                            showDivider: false,
                          ),
                        ],
                        onTap: onFaqTap,
                      ),

                      SizedBox(height: context.rs(20)),

                      // ---- ต้องการความช่วยเหลือ? ----
                      Text(
                        'ยังต้องการความช่วยเหลือ?',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(14),
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),

                      SizedBox(height: context.rs(6)),

                      Text(
                        'ติดต่อทีมงานของเราได้ผ่านช่องทางด้านล่าง',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(14),
                          fontWeight: FontWeight.w400,
                          color: AppColors.textGray,
                        ),
                      ),

                      SizedBox(height: context.rs(12)),

                      // ---- ปุ่มช่องทางติดต่อ ----
                       Wrap(
                         spacing: context.rs(12),
                         runSpacing: context.rs(12),
                         children: [
                           _ContactButton(
                             svgAsset: 'assets/images/profile/clarity_email-line.svg',
                             label: 'ติดต่อเราทางอีเมล',
                             subLabel: 'support@dentb.com',
                             onTap: onEmailContact,
                             width: context.rs(107),
                           ),
                           _ContactButton(
                             svgAsset: 'assets/images/profile/boxicons_phone.svg',
                             label: 'โทรหาเรา',
                             subLabel: '02-123-4567',
                             onTap: onPhoneContact,
                             width: context.rs(110),
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
// _HeroBanner — banner ม่วงพร้อม icon ?
// ============================================================
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(20),
        vertical: context.rs(20),
      ),
      decoration: BoxDecoration(
        color: Color(0xFFE6D5FF),
        borderRadius: BorderRadius.circular(context.rs(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // ---- text ----
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'เราพร้อมช่วยเหลือคุณ',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(16),
                    fontWeight: FontWeight.w700,
                    color: AppColors.purple,
                  ),
                ),
                SizedBox(height: context.rs(4)),
                Text(
                  'หากมีข้อสงสัย หรือต้องการ\nความช่วยเหลือ สามารถติดต่อเราได้เลย',
                  softWrap: false,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(11),
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: context.rs(12)),

          // ---- icon ? bubble ----
          Image.asset(
            'assets/images/profile/message-box.png',
            width: context.rs(101),
            height: context.rs(75),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _FaqCard — กล่าง FAQ list
// ============================================================
class _FaqCard extends StatelessWidget {
  const _FaqCard({required this.items, this.onTap});
  final List<_FaqItem> items;
  final void Function(String topic)? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: items
              .map((item) => _FaqRow(item: item, onTap: onTap))
              .toList(),
        ),
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({
    this.imageAsset,
    this.imageWidth,
    this.imageHeight,
    required this.title,
    required this.subtitle,
    this.showDivider = true,
  });
  final String? imageAsset;
  final double? imageWidth;
  final double? imageHeight;
  final String title;
  final String subtitle;
  final bool showDivider;
}

class _FaqRow extends StatelessWidget {
  const _FaqRow({required this.item, this.onTap});
  final _FaqItem item;
  final void Function(String topic)? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => onTap?.call(item.title),
          borderRadius: BorderRadius.circular(context.rs(16)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.rs(16),
              vertical: context.rs(13),
            ),
            child: Row(
              children: [
                // ---- icon circle ----
                 Container(
                   width: context.rs(36),
                   height: context.rs(36),
                   decoration: BoxDecoration(
                     color: AppColors.lavender,
                     borderRadius: BorderRadius.circular(context.rs(8)),
                   ),
                   child: Center(
                     child: Image.asset(
                       item.imageAsset!,
                       width: context.rs(item.imageWidth ?? 24),
                       height: context.rs(item.imageHeight ?? 24),
                       fit: BoxFit.contain,
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
                                 fontWeight: FontWeight.w400,
                                 color: AppColors.black,
                               ),
                             ),
                             SizedBox(height: context.rs(2)),
                             Text(
                               item.subtitle,
                               style: TextStyle(
                                 fontFamily: 'Inter',
                                 fontSize: context.rs(11),
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

// ============================================================
// _ContactButton — ปุ่มช่องทางติดต่อ
// ============================================================
class _ContactButton extends StatelessWidget {
  const _ContactButton({
    this.svgAsset,
    required this.label,
    required this.subLabel,
    this.onTap,
    this.width,
  });

  final String? svgAsset;
  final String label;
  final String subLabel;
  final VoidCallback? onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(
          vertical: context.rs(9),
          horizontal: context.rs(10),
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(context.rs(16)),
        ),
        child: Column(
          children: [
             SvgPicture.asset(
               svgAsset!,
               width: context.rs(24),
               height: context.rs(24),
               colorFilter: ColorFilter.mode(AppColors.purple, BlendMode.srcIn),
             ),
            SizedBox(height: context.rs(8)),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(10),
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: context.rs(3)),
            Text(
              subLabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(8),
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
