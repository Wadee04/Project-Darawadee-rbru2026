import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../components/shared_widgets.dart';
import '../../../services/service_locator.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';
import '../Book_an_appointment/book_an_appointment_one.dart';
import '../My_queue/my_queue_one.dart';
import '../HomeScreen/home_page_one.dart';
import 'edit_personal_infomation.dart';

// ============================================================
// ProfilePage — หน้าโปรไฟล์ผู้ใช้ (ดึงข้อมูลจาก Supabase)
// ============================================================
class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    this.currentNavIndex = 3,
    this.onNavTap,
    this.onEditAvatar,
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
  final VoidCallback? onEditAvatar;
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
      final results = await Future.wait<dynamic>([
        ServiceLocator.user.getCurrentUser(),
        ServiceLocator.booking.getBookingStats(),
      ]);
      final user = results[0];
      final stats = results[1];

      int confirmed = 0;
      int inProgress = 0;
      int completed = 0;
      if (stats is Map) {
        confirmed = (stats[BookingStatus.confirmed] ?? stats['confirmed'] ?? 0) as int;
        inProgress = (stats[BookingStatus.inProgress] ?? stats['in_progress'] ?? 0) as int;
        completed = (stats[BookingStatus.completed] ?? stats['completed'] ?? 0) as int;
      }

      if (mounted) {
        setState(() {
          _userName = (user as dynamic).fullName?.toString() ?? '';
          _userEmail = (user as dynamic).email?.toString() ?? '';
          _userImageUrl = (user as dynamic).profileImageUrl?.toString();
          _appointmentCount = confirmed + inProgress;
          _treatmentHistoryCount = completed;
        });
      }
    } catch (e) {
      debugPrint('Profile load error: $e');
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
      backgroundColor: const Color(0xFFEEEAFF),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEAE9FF), Color(0xFFF6F6F6)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- AppBar ----
              const AppBarBack(title: 'โปรไฟล์', showBack: false),
              // ---- Body ----
              Expanded(
                child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          context.rs(16),
                          context.rs(30),
                          context.rs(16),
                          context.rs(16),
                        ),
                        child: Column(
                          children: [
                            _AvatarSection(
                              userName: _userName,
                              userEmail: _userEmail,
                              userImageUrl: _userImageUrl,
                              onEdit: widget.onEditAvatar,
                            ),
                            SizedBox(height: context.rs(20)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.rs(12),
                                vertical: context.rs(14),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  context.rs(16),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    offset: const Offset(0, 1),
                                    blurRadius: 1,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _StatCard(
                                      svgAsset:
                                          'assets/images/my_queue/simple-line-icons_calender.svg',
                                      label: 'การนัดหมาย',
                                      count: _appointmentCount,
                                      iconSize: 19,
                                    ),
                                  ),
                                  SizedBox(width: context.rs(20)),
                                  Container(
                                    width: 1,
                                    height: context.rs(47),
                                    color: AppColors.registerButton,
                                  ),
                                  SizedBox(width: context.rs(20)),
                                  Expanded(
                                    child: _StatCard(
                                      svgAsset:
                                          'assets/images/my_queue/la_tooth.svg',
                                      label: 'ประวัติการรักษา',
                                      count: _treatmentHistoryCount,
                                      iconSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: context.rs(16)),
                            _MenuCard(
                              items: [
                                _MenuItem(
                                   icon: Icons.person_outline,
                                   label: 'ข้อมูลส่วนตัว',
                                   onTap: widget.onPersonalInfo ??
                                    () => Navigator.push(
                                              context,
                                              noAnimRoute(
                                                const EditPersonalInformation(),
                                              ),
                                            ),
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
                            SizedBox(height: context.rs(14)),
                            _LogoutButton(onLogout: _handleLogout),
                          ],
                        ),
                      ),
              ),

              // ---- Bottom Nav ----
              AppBottomNav(
                currentIndex: widget.currentNavIndex,
                onTap: (i) {
                  if (i == 0) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePageOne()),
                      (route) => false,
                    );
                  } else if (i == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BookAnAppointmentOne(),
                      ),
                    );
                  } else if (i == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyQueueOne()),
                    );
                  } else {
                    widget.onNavTap?.call(i);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _AvatarSection — รูปโปรไฟล์ + ปุ่มแก้ไข + ชื่อ + อีเมล
// ============================================================
class _AvatarSection extends StatelessWidget {
  const _AvatarSection({
    required this.userName,
    required this.userEmail,
    this.userImageUrl,
    this.onEdit,
  });

  final String userName;
  final String userEmail;
  final String? userImageUrl;
  final VoidCallback? onEdit;

  static const Color _editOrange = Color(0xFFF5A04A);

  @override
  Widget build(BuildContext context) {
    final size = context.rs(96);
    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.purpleLight,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.registerButton,
                      spreadRadius: 1,
                      blurRadius: 0,
                      offset: Offset.zero,
                    ),
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: userImageUrl != null
                      ? Image.network(
                          userImageUrl!,
                          width: size,
                          height: size,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _defaultAvatar(context),
                        )
                      : _defaultAvatar(context),
                ),
              ),
              Positioned(
                right: context.rs(7),
                bottom: context.rs(3),
                child: GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: context.rs(20),
                    height: context.rs(20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          offset: const Offset(0, 1),
                          blurRadius: 1,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      'assets/images/profile/boxicons_pencil.svg',
                      width: context.rs(11),
                      height: context.rs(11),
                      fit: BoxFit.contain,
                      colorFilter: const ColorFilter.mode(
                        Colors.orange,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.rs(12)),
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
            fontSize: context.rs(11),
            color: AppColors.textGray,
          ),
        ),
      ],
    );
  }

  Widget _defaultAvatar(BuildContext context) =>
      Icon(Icons.person, size: context.rs(48), color: AppColors.purple);
}

// ============================================================
// _StatCard — การ์ดสถิติ (ไอคอนวงกลม + ข้อความ)
// ============================================================
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.svgAsset,
    required this.label,
    required this.count,
    this.iconSize = 20,
  });

  final String svgAsset;
  final String label;
  final int count;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(10),
        vertical: context.rs(6),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.rs(40),
            height: context.rs(40),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFEEEAFF),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              svgAsset,
              width: context.rs(iconSize),
              height: context.rs(iconSize),
              colorFilter:
                  const ColorFilter.mode(AppColors.purple, BlendMode.srcIn),
            ),
          ),
          SizedBox(width: context.rs(10)),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(11),
                    color: AppColors.textGray,
                  ),
                ),
                SizedBox(height: context.rs(2)),
                Text(
                  '$count',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(14),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  'รายการ',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(11),
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.rs(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            offset: const Offset(0, 1),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
      ),
child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _MenuRow(item: items[i], isLast: i == items.length - 1),
            if (i < items.length - 1)
              SizedBox(height: context.rs(0)),
          ],
          SizedBox(height: context.rs(20)),
        ],
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.showDivider = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool showDivider;
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.item, this.isLast = false});
  final _MenuItem item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(context.rs(16)),
          child: Padding(
            padding: EdgeInsets.only(
              top: context.rs(20),
              left: context.rs(16),
              right: context.rs(16),
              bottom: isLast ? context.rs(0) : context.rs(6),
            ),
            child: Row(
              children: [
                Icon(item.icon, size: context.rs(20), color: AppColors.purple),
                SizedBox(width: context.rs(14)),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(13),
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: context.rs(18),
                  color: AppColors.black,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.rs(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            offset: const Offset(0, 1),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
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
