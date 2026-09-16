import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/shared_widgets.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// WarnPage — หน้าตั้งค่าการแจ้งเตือน
// ============================================================
class WarnPage extends StatefulWidget {
  const WarnPage({
    super.key,
    this.onBack,
    this.initialAllNotifications = true,
    this.initialAppointment = true,
    this.initialPromotion = true,
    this.initialTreatmentTip = true,
    this.initialFeedback = true,
  });

  final VoidCallback? onBack;
  final bool initialAllNotifications;
  final bool initialAppointment;
  final bool initialPromotion;
  final bool initialTreatmentTip;
  final bool initialFeedback;

  @override
  State<WarnPage> createState() => _WarnPageState();
}

class _WarnPageState extends State<WarnPage> {
  late bool _allNotifications;
  late bool _appointment;
  late bool _promotion;
  late bool _treatmentTip;
  late bool _feedback;

  @override
  void initState() {
    super.initState();
    _allNotifications = widget.initialAllNotifications;
    _appointment = widget.initialAppointment;
    _promotion = widget.initialPromotion;
    _treatmentTip = widget.initialTreatmentTip;
    _feedback = widget.initialFeedback;
  }

  // เมื่อ toggle ทั้งหมด — sync ทุกรายการ
  void _toggleAll(bool val) {
    setState(() {
      _allNotifications = val;
      _appointment = val;
      _promotion = val;
      _treatmentTip = val;
      _feedback = val;
    });
  }

  // เมื่อ toggle รายการย่อย — คำนวณ allNotifications
  void _toggleItem(String key, bool val) {
    setState(() {
      switch (key) {
        case 'appointment':
          _appointment = val;
          break;
        case 'promotion':
          _promotion = val;
          break;
        case 'treatmentTip':
          _treatmentTip = val;
          break;
        case 'feedback':
          _feedback = val;
          break;
      }
      _allNotifications =
          _appointment && _promotion && _treatmentTip && _feedback;
    });
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
                title: 'การตั้งค่าแจ้งเตือน',
                onBack: widget.onBack,
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
                      // ---- การแจ้งเตือนทั้งหมด ----
                      _ToggleCard(
                        children: [
                          _ToggleRow(
                            icon: Icons.notifications_outlined,
                            iconColor: AppColors.purple,
                            label: 'การแจ้งเตือนทั้งหมด',
                            value: _allNotifications,
                            onChanged: _toggleAll,
                          ),
                        ],
                      ),

                      SizedBox(height: context.rs(16)),

                      // ---- section label ----
                      Padding(
                        padding: EdgeInsets.only(
                          left: context.rs(4),
                          bottom: context.rs(8),
                        ),
                        child: Text(
                          'ประเภทการแจ้งเตือน',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(13),
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ),

                      // ---- รายการย่อย ----
                      _ToggleCard(
                        children: [
                          _ToggleRow(
                            svgAsset:
                                'assets/images/Book_an_appointment/uim_calender.svg',
                            iconColor: AppColors.purple,
                            label: 'การนัดหมาย',
                            value: _appointment,
                            onChanged: (v) => _toggleItem('appointment', v),
                          ),
                          _divider(context),
                          _ToggleRow(
                            svgAsset:
                                'assets/images/Book_an_appointment/icons/checkup.svg',
                            iconColor: AppColors.purple,
                            label: 'โปรโมชั่นและข่าวสาร',
                            value: _promotion,
                            onChanged: (v) => _toggleItem('promotion', v),
                          ),
                          _divider(context),
                          _ToggleRow(
                            svgAsset:
                                'assets/images/Book_an_appointment/healthicons_doctor-male.svg',
                            iconColor: AppColors.purple,
                            label: 'คำแนะนำหลังการรักษา',
                            value: _treatmentTip,
                            onChanged: (v) => _toggleItem('treatmentTip', v),
                          ),
                          _divider(context),
                          _ToggleRow(
                            icon: Icons.chat_bubble_outline,
                            iconColor: AppColors.purple,
                            label: 'ข้อความตอบกลับจากคลินิก',
                            value: _feedback,
                            onChanged: (v) => _toggleItem('feedback', v),
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

  Widget _divider(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: context.rs(0)),
        child: const Divider(
          color: AppColors.inputBorder,
          height: 1,
          thickness: 0.5,
        ),
      );
}

// ============================================================
// _ToggleCard — กล่องกลุ่ม toggle มีขอบโค้ง
// ============================================================
class _ToggleCard extends StatelessWidget {
  const _ToggleCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Column(children: children),
    );
  }
}

// ============================================================
// _ToggleRow — แถว icon + label + Switch
// ============================================================
class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    this.icon,
    this.svgAsset,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : assert(icon != null || svgAsset != null);

  final IconData? icon;
  final String? svgAsset;
  final Color iconColor;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(16),
        vertical: context.rs(12),
      ),
      child: Row(
        children: [
          // ---- icon ----
          if (svgAsset != null)
            SvgPicture.asset(
              svgAsset!,
              width: context.rs(20),
              height: context.rs(20),
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            )
          else
            Icon(icon, size: context.rs(20), color: iconColor),

          SizedBox(width: context.rs(12)),

          // ---- label ----
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(13),
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
          ),

          // ---- Switch ----
          Transform.scale(
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
