import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../components/shared_widgets.dart';
import '../../../services/service_locator.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// SecuritySettingsPage — หน้าความปลอดภัยและรหัสผ่าน
// ============================================================
class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({
    super.key,
    this.onBack,
    this.onChangePassword,
    this.onChangeEmail,
  });

  final VoidCallback? onBack;
  final VoidCallback? onChangePassword;
  final VoidCallback? onChangeEmail;

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  late bool _pinEnabled;
  bool _isSavingPin = false;
  String _userEmail = '';
  bool _loadingUser = true;

  @override
  void initState() {
    super.initState();
    _pinEnabled = false;
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await ServiceLocator.user.getCurrentUser();
      if (mounted) {
        setState(() {
          _userEmail = user.email;
          _pinEnabled = user.pinEnabled;
          _loadingUser = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingUser = false);
    }
  }

  Future<void> _handlePinToggle(bool v) async {
    setState(() => _isSavingPin = true);
    try {
      await ServiceLocator.user.togglePin(enabled: v);
      setState(() => _pinEnabled = v);
    } on AuthException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    } finally {
      if (mounted) setState(() => _isSavingPin = false);
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
                title: 'ความปลอดภัยและรหัสผ่าน',
                onBack: widget.onBack,
              ),

              // ---- Body ----
              Expanded(
                child: _loadingUser
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
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
                      _SecurityHeroBanner(),

                      SizedBox(height: context.rs(20)),

                      // ---- section label ----
                      Padding(
                        padding: EdgeInsets.only(
                          left: context.rs(4),
                          bottom: context.rs(10),
                        ),
                        child: Text(
                          'ความปลอดภัยของบัญชี',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(13),
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ),

                      // ---- รายการความปลอดภัย ----
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.homeBackground,
                          borderRadius: BorderRadius.circular(context.rs(16)),
                        ),
                        child: Column(
                          children: [
                            // เปลี่ยนรหัสผ่าน
                            _SecurityRow(
                              icon: Icons.lock_outline,
                              iconColor: AppColors.purple,
                              title: 'เปลี่ยนรหัสผ่าน',
                              subtitle: 'แนะนำให้เปลี่ยนรหัสผ่านอย่างน้อย 1 ครั้ง',
                              onTap: widget.onChangePassword,
                              showDivider: true,
                            ),

                            // อีเมลที่ใช้เข้าสู่ระบบ
                            _SecurityRow(
                              icon: Icons.email_outlined,
                              iconColor: AppColors.purple,
                              title: 'อีเมลที่ใช้ในการเข้าสู่ระบบ',
                              subtitle: _userEmail.isNotEmpty ? _userEmail : '-',
                              onTap: widget.onChangeEmail,
                              showDivider: true,
                            ),

                            // ตั้งรหัส PIN
                            _PinToggleRow(
                              value: _pinEnabled,
                              isSaving: _isSavingPin,
                              onChanged: _handlePinToggle,
                            ),
                          ],
                        ),
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
// _SecurityHeroBanner — banner พร้อม mascot
// ============================================================
class _SecurityHeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        context.rs(20),
        context.rs(20),
        0,
        0,
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
                    'รักษาบัญชีของคุณ\nให้ปลอดภัย',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(14),
                      fontWeight: FontWeight.w700,
                      color: AppColors.purple,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: context.rs(6)),
                  Text(
                    'ตั้งค่าการรักษาความปลอดภัย\nเพื่อปกป้องข้อมูลบัญชีของคุณ',
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

          SizedBox(width: context.rs(8)),

          // ---- mascot ----
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
                  Icons.shield_outlined,
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
// _SecurityRow — แถวรายการความปลอดภัย + chevron
// ============================================================
class _SecurityRow extends StatelessWidget {
  const _SecurityRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.showDivider = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
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
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: context.rs(18), color: iconColor),
                ),
                SizedBox(width: context.rs(12)),
                // ---- text ----
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(13),
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: context.rs(2)),
                      Text(
                        subtitle,
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
        if (showDivider)
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
// _PinToggleRow — แถวตั้งรหัส PIN พร้อม Switch
// ============================================================
class _PinToggleRow extends StatelessWidget {
  const _PinToggleRow({
    required this.value,
    required this.onChanged,
    this.isSaving = false,
  });

  final bool value;
  final Future<void> Function(bool) onChanged;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(16),
        vertical: context.rs(12),
      ),
      child: Row(
        children: [
          // ---- icon circle ----
          Container(
            width: context.rs(36),
            height: context.rs(36),
            decoration: BoxDecoration(
              color: AppColors.purple.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.grid_view_rounded,
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
                  'ตั้งรหัส PIN',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(13),
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: context.rs(2)),
                Text(
                  'ตั้งรหัส PIN 6 หลักเพื่อเพิ่มความปลอดภัย',
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
          // ---- Switch ----
          isSaving
              ? SizedBox(
                  width: context.rs(20), height: context.rs(20),
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: AppColors.white,
              activeTrackColor: AppColors.purple,
              inactiveThumbColor: AppColors.white,
              inactiveTrackColor: AppColors.inputBorder,
              trackOutlineColor:
                  WidgetStateProperty.all(Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _SecurityHeroBanner