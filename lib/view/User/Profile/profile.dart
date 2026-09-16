import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/shared_widgets.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// ProfilePage — หน้าโปรไฟล์ผู้ใช้
// ============================================================
class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    this.userName = 'ดาราวดี อาลัย',
    this.userEmail = '6014837101@rbru.ac.th',
    this.userImagePath,
    this.appointmentCount = 5,
    this.treatmentHistoryCount = 12,
    this.currentNavIndex = 3,
    this.onNavTap,
    this.onPersonalInfo,
    this.onPrivacy,
    this.onNotification,
    this.onHelp,
    this.onContact,
    this.onSwitchAccount,
    this.onRateApp,
    this.onLogout,
  });

  final String userName;
  final String userEmail;
  final String? userImagePath;
  final int appointmentCount;
  final int treatmentHistoryCount;
  final int currentNavIndex;
  final void Function(int)? onNavTap;

  // callbacks เมนู
  final VoidCallback? onPersonalInfo;
  final VoidCallback? onPrivacy;
  final VoidCallback? onNotification;
  final VoidCallback? onHelp;
  final VoidCallback? onContact;
  final VoidCallback? onSwitchAccount;
  final VoidCallback? onRateApp;
  final VoidCallback? onLogout;

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
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.rs(24),
                  MediaQuery.of(context).size.height * 0.01,
                  context.rs(24),
                  context.rs(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'โปรไฟล์',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(15),
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // ---- Scrollable body ----
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.rs(16),
                    context.rs(8),
                    context.rs(16),
                    context.rs(16),
                  ),
                  child: Column(
                    children: [
                      // ---- Profile Header Card ----
                      _ProfileHeaderCard(
                        userName: userName,
                        userEmail: userEmail,
                        userImagePath: userImagePath,
                        appointmentCount: appointmentCount,
                        treatmentHistoryCount: treatmentHistoryCount,
                      ),

                      SizedBox(height: context.rs(12)),

                      // ---- เมนูหลัก ----
                      _MenuCard(
                        items: [
                          _MenuItem(
                            icon: Icons.person_outline,
                            label: 'ข้อมูลส่วนตัว',
                            onTap: onPersonalInfo,
                          ),
                          _MenuItem(
                            icon: Icons.shield_outlined,
                            label: 'ความปลอดภัยและรหัสผ่าน',
                            onTap: onPrivacy,
                          ),
                          _MenuItem(
                            icon: Icons.notifications_none_outlined,
                            label: 'การแจ้งเตือน',
                            onTap: onNotification,
                          ),
                          _MenuItem(
                            icon: Icons.help_outline,
                            label: 'ช่วยเหลือและคำถามพบบ่อย',
                            onTap: onHelp,
                          ),
                          _MenuItem(
                            icon: Icons.headset_mic_outlined,
                            label: 'ติดต่อเรา',
                            onTap: onContact,
                          ),
                          _MenuItem(
                            icon: Icons.people_outline,
                            label: 'เปลี่ยนบัญชี',
                            onTap: onSwitchAccount,
                          ),
                          _MenuItem(
                            icon: Icons.star_border_outlined,
                            label: 'ให้คะแนนแอป',
                            onTap: onRateApp,
                            showDivider: false,
                          ),
                        ],
                      ),

                      SizedBox(height: context.rs(12)),

                      // ---- ปุ่มออกจากระบบ ----
                      _LogoutButton(onLogout: onLogout),
                    ],
                  ),
                ),
              ),

              // ---- Bottom Nav ----
              AppBottomNav(
                currentIndex: currentNavIndex,
                onTap: onNavTap ?? (_) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _ProfileHeaderCard — รูปโปรไฟล์ + ชื่อ + email + สถิติ
// ============================================================
class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({
    required this.userName,
    required this.userEmail,
    this.userImagePath,
    required this.appointmentCount,
    required this.treatmentHistoryCount,
  });

  final String userName;
  final String userEmail;
  final String? userImagePath;
  final int appointmentCount;
  final int treatmentHistoryCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: context.rs(20),
        horizontal: context.rs(16),
      ),
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Column(
        children: [
          // ---- Avatar ----
          Container(
            width: context.rs(72),
            height: context.rs(72),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.purpleLight,
              border: Border.all(
                color: AppColors.purple.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: userImagePath != null
                  ? Image.asset(
                      userImagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, e, s) => _defaultAvatar(context),
                    )
                  : _defaultAvatar(context),
            ),
          ),

          SizedBox(height: context.rs(10)),

          // ---- ชื่อ ----
          Text(
            userName,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(15),
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          SizedBox(height: context.rs(3)),

          // ---- email ----
          Text(
            userEmail,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(12),
              fontWeight: FontWeight.w400,
              color: AppColors.textGray,
            ),
          ),

          SizedBox(height: context.rs(16)),

          // ---- Divider ----
          Divider(
            color: AppColors.inputBorder,
            height: 1,
            thickness: 0.5,
          ),

          SizedBox(height: context.rs(14)),

          // ---- สถิติ ----
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  svgAsset: 'assets/images/homescreen/book_an_appointment_active.svg',
                  count: appointmentCount,
                  label: 'การนัดหมาย',
                ),
              ),
              Container(
                width: 1,
                height: context.rs(36),
                color: AppColors.inputBorder,
              ),
              Expanded(
                child: _StatItem(
                  svgAsset: 'assets/images/Book_an_appointment/icons/checkup.svg',
                  count: treatmentHistoryCount,
                  label: 'ประวัติการรักษา',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar(BuildContext context) {
    return Icon(
      Icons.person,
      size: context.rs(40),
      color: AppColors.purple,
    );
  }
}

// ============================================================
// _StatItem — ตัวเลขสถิติ + label
// ============================================================
class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.svgAsset,
    required this.count,
    required this.label,
  });

  final String svgAsset;
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          svgAsset,
          width: context.rs(20),
          height: context.rs(20),
          colorFilter: const ColorFilter.mode(
            AppColors.purple,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(height: context.rs(4)),
        Text(
          '$count',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(18),
            fontWeight: FontWeight.w700,
            color: AppColors.purple,
          ),
        ),
        Text(
          'รายการ',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(11),
            fontWeight: FontWeight.w400,
            color: AppColors.textGray,
          ),
        ),
        SizedBox(height: context.rs(2)),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(11),
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// _MenuCard — กล่องเมนูรายการ
// ============================================================
class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.items});
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Column(
        children: items.map((item) => _MenuRow(item: item)).toList(),
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.showDivider = true,
  });
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool showDivider;
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.item});
  final _MenuItem item;

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
                Icon(
                  item.icon,
                  size: context.rs(20),
                  color: AppColors.black,
                ),
                SizedBox(width: context.rs(14)),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(13),
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
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
            child: Divider(
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
// _LogoutButton — ปุ่มออกจากระบบ
// ============================================================
class _LogoutButton extends StatelessWidget {
  const _LogoutButton({this.onLogout});
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: InkWell(
        onTap: onLogout,
        borderRadius: BorderRadius.circular(context.rs(16)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.rs(14),
            horizontal: context.rs(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout,
                size: context.rs(18),
                color: AppColors.reddentbook,
              ),
              SizedBox(width: context.rs(8)),
              Text(
                'ออกจากระบบ',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(14),
                  fontWeight: FontWeight.w500,
                  color: AppColors.reddentbook,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
