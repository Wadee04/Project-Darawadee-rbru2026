import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// RegistrationStatusPage — หน้าสถานะรอตรวจสอบการลงทะเบียน
// ============================================================
class RegistrationStatusPage extends StatelessWidget {
  const RegistrationStatusPage({
    super.key,
    this.onGoHome,
    this.onContact,
    this.status = RegStatus.pending,
    this.clinicName = 'คลินิกทันตกรรมใจ๋',
    this.submittedAt,
    this.rejectedReason,
  });

  final VoidCallback? onGoHome;
  final VoidCallback? onContact;
  final RegStatus status;
  final String clinicName;
  final DateTime? submittedAt;
  final String? rejectedReason;

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
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              context.rs(24),
              context.rs(40),
              context.rs(24),
              context.rs(40),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ---- Status icon ----
                      _StatusIcon(status: status),

                      SizedBox(height: context.rs(24)),

                      // ---- Title ----
                      Text(
                        status.title,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(20),
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: context.rs(10)),

                      Text(
                        status.subtitle,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(13),
                          color: AppColors.textGray,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      if (rejectedReason != null && status == RegStatus.rejected) ...[
                        SizedBox(height: context.rs(16)),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(context.rs(14)),
                          decoration: BoxDecoration(
                            color: AppColors.reddentbook.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(context.rs(12)),
                            border: Border.all(color: AppColors.reddentbook.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('เหตุผล',
                                  style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(12),
                                      fontWeight: FontWeight.w600, color: AppColors.reddentbook)),
                              SizedBox(height: context.rs(4)),
                              Text(rejectedReason!,
                                  style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(12),
                                      color: AppColors.black, height: 1.5)),
                            ],
                          ),
                        ),
                      ],

                      SizedBox(height: context.rs(24)),

                      // ---- Info card ----
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(context.rs(14)),
                        decoration: BoxDecoration(
                          color: AppColors.homeBackground,
                          borderRadius: BorderRadius.circular(context.rs(16)),
                        ),
                        child: Column(
                          children: [
                            _InfoRow(icon: Icons.local_hospital_outlined, label: 'คลินิก', value: clinicName),
                            if (submittedAt != null) ...[
                              Divider(color: AppColors.inputBorder, height: 1, thickness: 0.5),
                              _InfoRow(
                                icon: Icons.access_time_outlined,
                                label: 'ส่งเมื่อ',
                                value: _formatDate(submittedAt!),
                              ),
                            ],
                            if (status == RegStatus.pending) ...[
                              Divider(color: AppColors.inputBorder, height: 1, thickness: 0.5),
                              _InfoRow(
                                icon: Icons.hourglass_top_outlined,
                                label: 'ระยะเวลา',
                                value: 'ประมาณ 3-7 วันทำการ',
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ---- Buttons ----
                if (status == RegStatus.approved)
                  SizedBox(
                    width: double.infinity,
                    height: context.rs(46),
                    child: ElevatedButton(
                      onPressed: onGoHome,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.rs(30))),
                      ),
                      child: Text('เข้าสู่ระบบ Dashboard',
                          style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(14), fontWeight: FontWeight.w600)),
                    ),
                  ),

                if (status == RegStatus.pending || status == RegStatus.rejected) ...[
                  SizedBox(
                    width: double.infinity,
                    height: context.rs(46),
                    child: ElevatedButton(
                      onPressed: onContact,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.rs(30))),
                      ),
                      child: Text('ติดต่อทีมงาน',
                          style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(14), fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(height: context.rs(10)),
                  GestureDetector(
                    onTap: onGoHome,
                    child: Text('กลับหน้าหลัก',
                        style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(13),
                            color: AppColors.textGray, fontWeight: FontWeight.w500)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day}/${d.month}/${d.year + 543}';
}

// ---- enum ----
enum RegStatus { pending, approved, rejected }

extension RegStatusExt on RegStatus {
  String get title {
    switch (this) {
      case RegStatus.pending:  return 'อยู่ระหว่างการตรวจสอบ';
      case RegStatus.approved: return 'ลงทะเบียนสำเร็จ!';
      case RegStatus.rejected: return 'การลงทะเบียนไม่ผ่าน';
    }
  }

  String get subtitle {
    switch (this) {
      case RegStatus.pending:
        return 'ทีมงานกำลังตรวจสอบข้อมูลของคุณ\nกรุณารอผลทางอีเมลที่ลงทะเบียนไว้';
      case RegStatus.approved:
        return 'คลินิกของคุณผ่านการตรวจสอบแล้ว\nสามารถเริ่มใช้งาน Dashboard ได้ทันที';
      case RegStatus.rejected:
        return 'ข้อมูลคลินิกของคุณไม่ผ่านการตรวจสอบ\nกรุณาติดต่อทีมงานเพื่อดำเนินการต่อ';
    }
  }
}

// ---- Status icon ----
class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});
  final RegStatus status;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final IconData icon;
    final Color iconColor;

    switch (status) {
      case RegStatus.pending:
        bg = const Color(0xFFFFF3CD); icon = Icons.access_time_rounded; iconColor = const Color(0xFFF59E0B);
        break;
      case RegStatus.approved:
        bg = AppColors.greendentbook.withValues(alpha: 0.15); icon = Icons.check_circle_outline; iconColor = AppColors.greendentbook;
        break;
      case RegStatus.rejected:
        bg = AppColors.reddentbook.withValues(alpha: 0.12); icon = Icons.cancel_outlined; iconColor = AppColors.reddentbook;
        break;
    }

    return Container(
      width: context.rs(80),
      height: context.rs(80),
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, size: context.rs(44), color: iconColor),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.rs(10)),
      child: Row(children: [
        Icon(icon, size: context.rs(16), color: AppColors.purple),
        SizedBox(width: context.rs(10)),
        Text('$label: ',
            style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(12), color: AppColors.textGray)),
        Expanded(
          child: Text(value,
              style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(12),
                  fontWeight: FontWeight.w500, color: AppColors.black)),
        ),
      ]),
    );
  }
}
