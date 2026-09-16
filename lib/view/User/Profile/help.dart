import 'package:flutter/material.dart';

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
                title: 'ช่วยเหลือ',
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

                      // ---- คำถามที่พบบ่อย header ----
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'คำถามที่พบบ่อย',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: context.rs(13),
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: onSeeAll,
                            child: Text(
                              'ดูทั้งหมด',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: context.rs(12),
                                fontWeight: FontWeight.w500,
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
                            icon: Icons.calendar_today_outlined,
                            title: 'การจองและนัดหมาย',
                            subtitle: 'การจองคิว, เลื่อนนัด, ยกเลิกนัด',
                          ),
                          _FaqItem(
                            icon: Icons.payment_outlined,
                            title: 'การชำระและการมัดจำ',
                            subtitle: 'การชำระเงิน, มัดจำ/คืนมัดจำ, ใบเสร็จ',
                          ),
                          _FaqItem(
                            icon: Icons.local_hospital_outlined,
                            title: 'เกี่ยวกับคลินิก',
                            subtitle: 'บริการ, โปรโมชั่น, คลินิก',
                          ),
                          _FaqItem(
                            icon: Icons.medical_services_outlined,
                            title: 'เกี่ยวกับคลินิก',
                            subtitle: 'บริการ, โปรโมชั่น, สาขา',
                          ),
                          _FaqItem(
                            icon: Icons.phone_iphone_outlined,
                            title: 'การใช้งานแอป',
                            subtitle: 'การตั้งค่าบัญชี, การแจ้งเตือน',
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
                          fontSize: context.rs(13),
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),

                      SizedBox(height: context.rs(6)),

                      Text(
                        'ติดต่อทีมงานของเราได้หน้าที่ผ่านทางช่องทางด้านล่าง',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(12),
                          fontWeight: FontWeight.w400,
                          color: AppColors.textGray,
                        ),
                      ),

                      SizedBox(height: context.rs(12)),

                      // ---- ปุ่มช่องทางติดต่อ ----
                      Row(
                        children: [
                          Expanded(
                            child: _ContactButton(
                              icon: Icons.email_outlined,
                              label: 'ติดต่อทางอีเมล',
                              subLabel: 'support@dentb.com',
                              onTap: onEmailContact,
                            ),
                          ),
                          SizedBox(width: context.rs(12)),
                          Expanded(
                            child: _ContactButton(
                              icon: Icons.phone_outlined,
                              label: 'โทรหาเรา',
                              subLabel: '0800 - 18:00',
                              onTap: onPhoneContact,
                            ),
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
        color: AppColors.purpleLight,
        borderRadius: BorderRadius.circular(context.rs(16)),
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
                    fontSize: context.rs(14),
                    fontWeight: FontWeight.w700,
                    color: AppColors.purple,
                  ),
                ),
                SizedBox(height: context.rs(4)),
                Text(
                  'หากมีข้อสงสัย หรือต้องการ\nความช่วยเหลือ สามารถติดต่อเราได้เลย',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(11),
                    fontWeight: FontWeight.w400,
                    color: AppColors.purple.withValues(alpha: 0.75),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: context.rs(12)),

          // ---- icon ? bubble ----
          Stack(
            clipBehavior: Clip.none,
            children: [
              // chat bubble หลัก
              Container(
                width: context.rs(56),
                height: context.rs(56),
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  borderRadius: BorderRadius.circular(context.rs(14)),
                ),
                child: Center(
                  child: Text(
                    '?',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(28),
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              // เงาม่วงอ่อน
              Positioned(
                right: -context.rs(6),
                bottom: -context.rs(6),
                child: Container(
                  width: context.rs(40),
                  height: context.rs(40),
                  decoration: BoxDecoration(
                    color: AppColors.purple.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(context.rs(10)),
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
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Column(
        children: items
            .map((item) => _FaqRow(item: item, onTap: onTap))
            .toList(),
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.showDivider = true,
  });
  final IconData icon;
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
                    color: AppColors.purpleLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon,
                    size: context.rs(18),
                    color: AppColors.purple,
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
                          fontWeight: FontWeight.w500,
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

// ============================================================
// _ContactButton — ปุ่มช่องทางติดต่อ
// ============================================================
class _ContactButton extends StatelessWidget {
  const _ContactButton({
    required this.icon,
    required this.label,
    required this.subLabel,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String subLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: context.rs(16),
          horizontal: context.rs(12),
        ),
        decoration: BoxDecoration(
          color: AppColors.homeBackground,
          borderRadius: BorderRadius.circular(context.rs(16)),
        ),
        child: Column(
          children: [
            Container(
              width: context.rs(40),
              height: context.rs(40),
              decoration: BoxDecoration(
                color: AppColors.purpleLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: context.rs(20),
                color: AppColors.purple,
              ),
            ),
            SizedBox(height: context.rs(8)),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(12),
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: context.rs(3)),
            Text(
              subLabel,
              textAlign: TextAlign.center,
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
    );
  }
}
