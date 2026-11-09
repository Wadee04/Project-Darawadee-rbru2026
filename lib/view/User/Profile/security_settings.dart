import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          color: AppColors.settingsBackground,
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
                    context.rs(24),
                    context.rs(24),
                    context.rs(24),
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
                            fontSize: context.rs(14),
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                      ),

                      // ---- รายการความปลอดภัย ----
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(context.rs(16)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 22),
                          child: Column(
                            children: [
                              // เปลี่ยนรหัสผ่าน
                              _SecurityRow(
                                iconSvg: 'assets/images/profile/si_lock-duotone.svg',
                                iconColor: AppColors.purple,
                                title: 'เปลี่ยนรหัสผ่าน',
                                subtitle: 'แนะนำให้เปลี่ยนรหัสผ่านอย่างสม่ำเสมอ',
                                onTap: widget.onChangePassword,
                              ),
                          
                              SizedBox(height: context.rs(30)),
                          
                              // อีเมลที่ใช้เข้าสู่ระบบ
                              _SecurityRow(
                                iconSvg: 'assets/images/profile/line-md_email-alt-twotone.svg',
                                iconColor: AppColors.purple,
                                title: 'อีเมลที่ใช้ในการเข้าสู่ระบบ',
                                subtitle: _userEmail.isNotEmpty ? _userEmail : 'แนะนำให้เปลี่ยนรหัสผ่านอย่างสม่ำเสมอ',
                                onTap: widget.onChangeEmail,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: context.rs(13)),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(context.rs(16)),
                        ),
                        child: _PinToggleRow(
                          value: _pinEnabled,
                          onChanged: _handlePinToggle,
                          isSaving: _isSavingPin,
                        )
                      )
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
        context.rs(8),
        0,
        0,
      ),
      decoration: BoxDecoration(
        color: AppColors.blue15,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ---- mascot ----
          Transform.translate(
            offset: Offset(0, context.rs(18)),
            child: Transform.scale(
              scale: 1.45,
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(context.rs(16)),
              ),
              child: Image.asset(
                'assets/images/profile/mascot-secur.png',
                width: context.rs(120),
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
            ),
          ),

          SizedBox(width: context.rs(8)),

          // ---- text ----
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: context.rs(20), right: context.rs(16), left: context.rs(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'รักษาบัญชีของคุณ\nให้ปลอดภัย',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: context.rs(6)),
                  Text(
                    'ตั้งค่าการรักษาความปลอดภัย\nเพื่อปกป้องข้อมูลบัญชีของคุณ',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(10),
                      fontWeight: FontWeight.w500,
                      color: AppColors.purple.withValues(alpha: 0.75),
                      height: 1.55,
                    ),
                  ),
                ],
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
    this.iconSvg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String? iconSvg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

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
            ),
            child: Row(
              children: [
                // ---- icon circle ----
                SvgPicture.asset(
                  iconSvg!,
                  width: context.rs(30),
                  height: context.rs(30),
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
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
                          fontSize: context.rs(14),
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: context.rs(2)),
                      Text(
                        subtitle,
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
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.rs(16),
          vertical: context.rs(12),
        ),
        child: Row(
        children: [
          // ---- icon circle ----
          SvgPicture.asset(
            'assets/images/profile/material-symbols_dialpad.svg',
            width: context.rs(30),
            height: context.rs(30),
            colorFilter: ColorFilter.mode(AppColors.purple, BlendMode.srcIn),
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
                    fontSize: context.rs(14),
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: context.rs(2)),
                Text(
                  'ตั้งรหัส PIN 6 หลักเพื่อเพิ่มความปลอดภัย',
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
          // ---- Switch ----
          Transform.translate(
            offset: Offset(context.rs(12), 0),
            child: Transform.scale(
              scaleX: 0.65,
              scaleY: 0.60,
              child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: AppColors.white,
              activeTrackColor: AppColors.purple,
              inactiveThumbColor: AppColors.white,
              inactiveTrackColor: AppColors.registerButton,
              trackOutlineColor:
                  WidgetStateProperty.all(Colors.transparent),
            ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}

// ============================================================
// _SecurityHeroBanner