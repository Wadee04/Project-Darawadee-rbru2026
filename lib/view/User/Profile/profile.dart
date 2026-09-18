import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../components/shared_widgets.dart';
import '../../../services/service_locator.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// ProfilePage — หน้าโปรไฟล์ผู้ใช้ (ดึงข้อมูลจาก Supabase)
// ============================================================
class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
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

  final int currentNavIndex;
  final void Function(int)? onNavTap;
  final VoidCallback? onPersonalInfo;
  final VoidCallback? onPrivacy;
  final VoidCallback? onNotification;
  final VoidCallback? onHelp;
  final VoidCallback? onContact;
  final VoidCallback? onSwitchAccount;
  final VoidCallback? onRateApp;
  final VoidCallback? onLogout;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _loading = true;
  String _userName = '';
  String _userEmail = '';
  String? _userImageUrl;
  int _appointmentCount = 0;
  int _treatmentHistoryCount = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      // ดึงข้อมูล user + สถิติการจองพร้อมกัน
      final results = await Future.wait<dynamic>([
        ServiceLocator.user.getCurrentUser(),
        ServiceLocator.booking.getBookingStats(),
      ]);
      final user = results[0] as UserModel;
      final stats = results[1] as Map<BookingStatus, int>;

      final upcoming = (stats[BookingStatus.confirmed] ?? 0) +
          (stats[BookingStatus.waitingPayment] ?? 0) +
          (stats[BookingStatus.inProgress] ?? 0);
      final history = stats[BookingStatus.completed] ?? 0;

      if (mounted) {
        setState(() {
          _userName = user.fullName;
          _userEmail = user.email;
          _userImageUrl = user.profileImageUrl;
          _appointmentCount = upcoming;
          _treatmentHistoryCount = history;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleLogout() async {
    try {
      await ServiceLocator.user.signOut();
      widget.onLogout?.call();
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFFFFFFF), Color(0xFFC5DEE8)],
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

              // ---- Body ----
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          context.rs(16),
                          context.rs(8),
                          context.rs(16),
                          context.rs(16),
                        ),
                        child: Column(
                          children: [
                            _ProfileHeaderCard(
                              userName: _userName,
                              userEmail: _userEmail,
                              userImageUrl: _userImageUrl,
                              appointmentCount: _appointmentCount,
                              treatmentHistoryCount: _treatmentHistoryCount,
                            ),
                            SizedBox(height: context.rs(12)),
                            _MenuCard(
                              items: [
                                _MenuItem(
                                  icon: Icons.person_outline,
                                  label: 'ข้อมูลส่วนตัว',
                                  onTap: widget.onPersonalInfo,
                                ),
                                _MenuItem(
                                  icon: Icons.shield_outlined,
                                  label: 'ความปลอดภัยและรหัสผ่าน',
                                  onTap: widget.onPrivacy,
                                ),
                                _MenuItem(
                                  icon: Icons.notifications_none_outlined,
                                  label: 'การแจ้งเตือน',
                                  onTap: widget.onNotification,
                                ),
                                _MenuItem(
                                  icon: Icons.help_outline,
                                  label: 'ช่วยเหลือและคำถามพบบ่อย',
                                  onTap: widget.onHelp,
                                ),
                                _MenuItem(
                                  icon: Icons.headset_mic_outlined,
                                  label: 'ติดต่อเรา',
                                  onTap: widget.onContact,
                                ),
                                _MenuItem(
                                  icon: Icons.people_outline,
                                  label: 'เปลี่ยนบัญชี',
                                  onTap: widget.onSwitchAccount,
                                ),
                                _MenuItem(
                                  icon: Icons.star_border_outlined,
                                  label: 'ให้คะแนนแอป',
                                  onTap: widget.onRateApp,
                                  showDivider: false,
                                ),
                              ],
                            ),
                            SizedBox(height: context.rs(12)),
                            _LogoutButton(onLogout: _handleLogout),
                          ],
                        ),
                      ),
              ),

              // ---- Bottom Nav ----
              AppBottomNav(
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
// _ProfileHeaderCard
// ============================================================
class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({
    required this.userName,
    required this.userEmail,
    this.userImageUrl,
    required this.appointmentCount,
    required this.treatmentHistoryCount,
  });

  final String userName;
  final String userEmail;
  final String? userImageUrl;
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
          // Avatar
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
              child: userImageUrl != null
                  ? Image.network(
                      userImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _defaultAvatar(context),
                    )
                  : _defaultAvatar(context),
            ),
          ),

          SizedBox(height: context.rs(10)),

          Text(
            userName.isNotEmpty ? userName : '-',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(15),
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          SizedBox(height: context.rs(3)),

          Text(
            userEmail.isNotEmpty ? userEmail : '-',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(12),
              color: AppColors.textGray,
            ),
          ),

          SizedBox(height: context.rs(16)),
          Divider(color: AppColors.inputBorder, height: 1, thickness: 0.5),
          SizedBox(height: context.rs(14)),

          Row(
            children: [
              Expanded(
                child: _StatItem(
                  svgAsset:
                      'assets/images/homescreen/book_an_appointment_active.svg',
                  count: appointmentCount,
                  label: 'การนัดหมาย',
                ),
              ),
              Container(
                  width: 1, height: context.rs(36), color: AppColors.inputBorder),
              Expanded(
                child: _StatItem(
                  svgAsset:
                      'assets/images/Book_an_appointment/icons/checkup.svg',
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

  Widget _defaultAvatar(BuildContext context) =>
      Icon(Icons.person, size: context.rs(40), color: AppColors.purple);
}

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
          colorFilter:
              const ColorFilter.mode(AppColors.purple, BlendMode.srcIn),
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
              color: AppColors.textGray),
        ),
        SizedBox(height: context.rs(2)),
        Text(
          label,
          style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(11),
              fontWeight: FontWeight.w500,
              color: AppColors.black),
        ),
      ],
    );
  }
}

// ============================================================
// _MenuCard
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
      child: Column(children: items.map((i) => _MenuRow(item: i)).toList()),
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
                Icon(item.icon, size: context.rs(20), color: AppColors.black),
                SizedBox(width: context.rs(14)),
                Expanded(
                  child: Text(item.label,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(13),
                          color: AppColors.black)),
                ),
                Icon(Icons.chevron_right,
                    size: context.rs(18), color: AppColors.textGray),
              ],
            ),
          ),
        ),
        if (item.showDivider)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.rs(16)),
            child: Divider(
                color: AppColors.inputBorder, height: 1, thickness: 0.5),
          ),
      ],
    );
  }
}

// ============================================================
// _LogoutButton
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
              vertical: context.rs(14), horizontal: context.rs(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout,
                  size: context.rs(18), color: AppColors.reddentbook),
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
