import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/admin/admin_clinic_service.dart';
import '../../../services/admin/admin_models.dart';
import '../../../services/supabase_user_service.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// ProfileAdminPage — โปรไฟล์แอดมิน / ข้อมูลคลินิก (Supabase)
// ============================================================
class ProfileAdminPage extends StatefulWidget {
  const ProfileAdminPage({
    super.key,
    this.onBack,
    this.onNavTap,
    this.onEditClinic,
    this.onChangePassword,
    this.onLogout,
    this.currentNavIndex = 3,
  });

  final VoidCallback? onBack;
  final void Function(int)? onNavTap;
  final VoidCallback? onEditClinic;
  final VoidCallback? onChangePassword;
  final VoidCallback? onLogout;
  final int currentNavIndex;

  @override
  State<ProfileAdminPage> createState() => _ProfileAdminPageState();
}

class _ProfileAdminPageState extends State<ProfileAdminPage> {
  bool _loading = true;
  AdminUser? _admin;
  int _totalDoctors = 0;
  int _totalServices = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final admin = await AdminClinicService.instance.getAdminUser();

      // ดึงจำนวนหมอและบริการของคลินิก
      int doctors = 0;
      int services = 0;
      if (admin.clinicId.isNotEmpty) {
        final db = Supabase.instance.client;
        final dRes = await db.from('doctors').select('id').eq('clinic_id', admin.clinicId);
        final sRes = await db.from('services').select('id').eq('clinic_id', admin.clinicId);
        doctors = (dRes as List).length;
        services = (sRes as List).length;
      }

      if (mounted) {
        setState(() {
          _admin = admin;
          _totalDoctors = doctors;
          _totalServices = services;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleLogout() async {
    try {
      await SupabaseUserService.instance.signOut();
      widget.onLogout?.call();
    } on AuthException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final admin = _admin;

    // map AdminClinicStatus → ClinicStatus (local enum)
    ClinicStatus clinicStatus = ClinicStatus.pending;
    if (admin != null) {
      switch (admin.clinicStatus) {
        case AdminClinicStatus.approved: clinicStatus = ClinicStatus.approved; break;
        case AdminClinicStatus.rejected: clinicStatus = ClinicStatus.rejected; break;
        default: clinicStatus = ClinicStatus.pending;
      }
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight,
              colors: [Color(0xFFFFFFFF), Color(0xFFC5DEE8)]),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(context.rs(20), context.rs(14), context.rs(20), context.rs(8)),
                child: Center(
                  child: Text('โปรไฟล์', style: TextStyle(fontFamily: 'Inter',
                      fontSize: context.rs(15), fontWeight: FontWeight.w600, color: AppColors.black)),
                ),
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(context.rs(16), 0, context.rs(16), context.rs(24)),
                        child: Column(
                          children: [
                            _AdminHeaderCard(
                              adminName: admin?.fullName ?? '-',
                              adminEmail: admin?.email ?? '-',
                              clinicName: admin?.clinicName ?? '-',
                              clinicStatus: clinicStatus,
                              totalDoctors: _totalDoctors,
                              totalServices: _totalServices,
                            ),
                            SizedBox(height: context.rs(12)),
                            _InfoCard(
                              title: 'ข้อมูลคลินิก',
                              items: [
                                _InfoRow(icon: Icons.local_hospital_outlined, label: admin?.clinicName ?? '-'),
                                _InfoRow(icon: Icons.phone_outlined, label: admin?.phone ?? '-'),
                              ],
                              trailing: GestureDetector(
                                onTap: widget.onEditClinic,
                                child: Text('แก้ไข', style: TextStyle(fontFamily: 'Inter',
                                    fontSize: context.rs(12), color: AppColors.purple,
                                    fontWeight: FontWeight.w500)),
                              ),
                            ),
                            SizedBox(height: context.rs(12)),
                            _MenuCard(items: [
                              _MenuItem(icon: Icons.lock_outline, label: 'เปลี่ยนรหัสผ่าน',
                                  onTap: widget.onChangePassword),
                              _MenuItem(icon: Icons.help_outline, label: 'ช่วยเหลือ',
                                  onTap: () {}, showDivider: false),
                            ]),
                            SizedBox(height: context.rs(12)),
                            _LogoutButton(onLogout: _handleLogout),
                          ],
                        ),
                      ),
              ),
              _AdminBottomNav(currentIndex: widget.currentNavIndex, onTap: widget.onNavTap ?? (_) {}),
            ],
          ),
        ),
      ),
    );
  }
}

// ---- enums ----
enum ClinicStatus { pending, approved, rejected }

extension ClinicStatusExt on ClinicStatus {
  String get label {
    switch (this) {
      case ClinicStatus.pending:  return 'รออนุมัติ';
      case ClinicStatus.approved: return 'อนุมัติแล้ว';
      case ClinicStatus.rejected: return 'ถูกปฏิเสธ';
    }
  }

  Color get color {
    switch (this) {
      case ClinicStatus.pending:  return const Color(0xFFF59E0B);
      case ClinicStatus.approved: return const Color(0xFF10B981);
      case ClinicStatus.rejected: return const Color(0xFFEF4444);
    }
  }
}

// ============================================================
// _AdminHeaderCard
// ============================================================
class _AdminHeaderCard extends StatelessWidget {
  const _AdminHeaderCard({
    required this.adminName,
    required this.adminEmail,
    required this.clinicName,
    required this.clinicStatus,
    required this.totalDoctors,
    required this.totalServices,
  });

  final String adminName;
  final String adminEmail;
  final String clinicName;
  final ClinicStatus clinicStatus;
  final int totalDoctors;
  final int totalServices;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rs(16)),
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Column(
        children: [
          // avatar
          Container(
            width: context.rs(64),
            height: context.rs(64),
            decoration: BoxDecoration(
              color: AppColors.purpleLight,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.purple.withValues(alpha: 0.3), width: 2),
            ),
            child: Icon(Icons.person, size: context.rs(36), color: AppColors.purple),
          ),

          SizedBox(height: context.rs(10)),

          Text(
            adminName,
            style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(15),
                fontWeight: FontWeight.w700, color: AppColors.black),
          ),
          SizedBox(height: context.rs(2)),
          Text(
            adminEmail,
            style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(11), color: AppColors.textGray),
          ),

          SizedBox(height: context.rs(8)),

          // status badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: context.rs(12), vertical: context.rs(4)),
            decoration: BoxDecoration(
              color: clinicStatus.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(context.rs(20)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: context.rs(6), height: context.rs(6),
                    decoration: BoxDecoration(color: clinicStatus.color, shape: BoxShape.circle)),
                SizedBox(width: context.rs(6)),
                Text(
                  clinicStatus.label,
                  style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(11),
                      fontWeight: FontWeight.w500, color: clinicStatus.color),
                ),
              ],
            ),
          ),

          SizedBox(height: context.rs(14)),
          Divider(color: AppColors.inputBorder, height: 1, thickness: 0.5),
          SizedBox(height: context.rs(12)),

          Row(
            children: [
              Expanded(
                child: _StatItem(count: totalDoctors, label: 'ทันตแพทย์'),
              ),
              Container(width: 1, height: context.rs(32), color: AppColors.inputBorder),
              Expanded(
                child: _StatItem(count: totalServices, label: 'บริการ'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.count, required this.label});
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count',
            style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(20),
                fontWeight: FontWeight.w700, color: AppColors.purple)),
        Text(label,
            style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(11), color: AppColors.textGray)),
      ],
    );
  }
}

// ============================================================
// _InfoCard
// ============================================================
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.items, this.trailing});
  final String title;
  final List<_InfoRow> items;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rs(14)),
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(13),
                      fontWeight: FontWeight.w600, color: AppColors.black)),
              ?trailing,
            ],
          ),
          SizedBox(height: context.rs(10)),
          ...items.map((r) => Padding(
            padding: EdgeInsets.only(bottom: context.rs(8)),
            child: Row(children: [
              Icon(r.icon, size: context.rs(16), color: AppColors.purple),
              SizedBox(width: context.rs(10)),
              Expanded(
                child: Text(r.label,
                    style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(12), color: AppColors.black)),
              ),
            ]),
          )),
        ],
      ),
    );
  }
}

class _InfoRow {
  const _InfoRow({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

// ============================================================
// _MenuCard / _MenuItem
// ============================================================
class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.items});
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.homeBackground,
          borderRadius: BorderRadius.circular(context.rs(16))),
      child: Column(children: items.map((i) => _MenuRow(item: i)).toList()),
    );
  }
}

class _MenuItem {
  const _MenuItem({required this.icon, required this.label, this.onTap, this.showDivider = true});
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
            padding: EdgeInsets.symmetric(horizontal: context.rs(16), vertical: context.rs(14)),
            child: Row(children: [
              Icon(item.icon, size: context.rs(20), color: AppColors.black),
              SizedBox(width: context.rs(12)),
              Expanded(child: Text(item.label,
                  style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(13), color: AppColors.black))),
              Icon(Icons.chevron_right, size: context.rs(18), color: AppColors.textGray),
            ]),
          ),
        ),
        if (item.showDivider)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.rs(16)),
            child: Divider(color: AppColors.inputBorder, height: 1, thickness: 0.5),
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
    return GestureDetector(
      onTap: onLogout,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: context.rs(14)),
        decoration: BoxDecoration(color: AppColors.homeBackground,
            borderRadius: BorderRadius.circular(context.rs(16))),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.logout, size: context.rs(18), color: AppColors.reddentbook),
          SizedBox(width: context.rs(8)),
          Text('ออกจากระบบ',
              style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(14),
                  fontWeight: FontWeight.w500, color: AppColors.reddentbook)),
        ]),
      ),
    );
  }
}

// ============================================================
// _AdminBottomNav
// ============================================================
class _AdminBottomNav extends StatelessWidget {
  const _AdminBottomNav({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'ภาพรวม'),
    _NavItem(icon: Icons.qr_code_scanner,    activeIcon: Icons.qr_code_scanner, label: 'สแกนคิว'),
    _NavItem(icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2, label: 'สต็อก'),
    _NavItem(icon: Icons.person_outline,     activeIcon: Icons.person, label: 'โปรไฟล์'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.white, boxShadow: [
        BoxShadow(color: AppColors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, -3)),
      ]),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: context.rs(6)),
          child: Row(
            children: _items.asMap().entries.map((e) {
              final sel = e.key == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(e.key),
                  behavior: HitTestBehavior.opaque,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(sel ? e.value.activeIcon : e.value.icon,
                        size: context.rs(22),
                        color: sel ? AppColors.purple : AppColors.textGray),
                    SizedBox(height: context.rs(2)),
                    Text(e.value.label,
                        style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(10),
                            fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                            color: sel ? AppColors.purple : AppColors.textGray)),
                  ]),
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
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
