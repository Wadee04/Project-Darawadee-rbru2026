import 'package:flutter/material.dart';

import '../../../services/admin/admin_booking_service.dart';
import '../../../services/admin/admin_clinic_service.dart';
import '../../../services/admin/admin_models.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// DashboardPage — หน้าหลัก Admin Dashboard (ดึงข้อมูลจาก Supabase)
// ============================================================
class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    this.onNotification,
    this.onSettings,
    this.onNavTap,
    this.currentNavIndex = 0,
  });

  final VoidCallback? onNotification;
  final VoidCallback? onSettings;
  final void Function(int)? onNavTap;
  final int currentNavIndex;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _loading = true;

  // ---- data ----
  String _adminName = '';
  String _clinicName = '';
  DashboardStats _stats =
      const DashboardStats(totalToday: 0, waiting: 0, inProgress: 0, completed: 0);
  List<AdminBooking> _bookings = [];
  int _roomIndex = 0;

  // realtime subscription handle
  dynamic _sub;

  @override
  void initState() {
    super.initState();
    _loadAll();
    _sub = AdminBookingService.instance.subscribeToTodayQueue(_onRealtimeChange);
  }

  @override
  void dispose() {
    _sub?.unsubscribe();
    super.dispose();
  }

  void _onRealtimeChange() => _loadAll();

  Future<void> _loadAll() async {
    try {
      final results = await Future.wait([
        AdminClinicService.instance.getAdminUser(),
        AdminClinicService.instance.getDashboardStats(),
        AdminBookingService.instance.getTodayBookings(),
      ]);
      if (!mounted) return;
      final admin = results[0] as AdminUser;
      final stats = results[1] as DashboardStats;
      final bookings = results[2] as List<AdminBooking>;
      setState(() {
        _adminName = 'สวัสดี, ${admin.fullName} 👋';
        _clinicName = admin.clinicName;
        _stats = stats;
        _bookings = bookings;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ---- action helpers ----
  Future<void> _callQueue(String id) async {
    await AdminBookingService.instance.callQueue(id);
    _loadAll();
  }

  Future<void> _completeQueue(String id) async {
    await AdminBookingService.instance.completeQueue(id);
    _loadAll();
  }

  Future<void> _cancelQueue(String id) async {
    await AdminBookingService.instance.cancelQueue(id);
    _loadAll();
  }

  AdminBooking? get _currentQueue =>
      _bookings.where((b) => b.status == AdminQueueStatus.inProgress).firstOrNull;

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
              _TopBar(
                adminName: _adminName,
                clinicName: _clinicName,
                onNotification: widget.onNotification,
                onSettings: widget.onSettings,
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: _loadAll,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(
                            context.rs(16), context.rs(8),
                            context.rs(16), context.rs(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _StatsRow(
                                total: _stats.totalToday,
                                pending: _stats.waiting,
                                inProgress: _stats.inProgress,
                                completed: _stats.completed,
                              ),
                              SizedBox(height: context.rs(14)),

                              // ---- Current queue card ----
                              if (_currentQueue != null)
                                _CurrentQueueCard(
                                  queue: _currentQueue!,
                                  onRefresh: () => _callQueue(_currentQueue!.id),
                                  onComplete: () => _completeQueue(_currentQueue!.id),
                                  onSkip: () => _cancelQueue(_currentQueue!.id),
                                ),

                              SizedBox(height: context.rs(14)),

                              // ---- Room tabs ----
                              _RoomRow(
                                selectedIndex: _roomIndex,
                                onSelect: (i) => setState(() => _roomIndex = i),
                              ),

                              SizedBox(height: context.rs(14)),

                              // ---- Queue list header ----
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('คิวรอเจ็บ',
                                      style: TextStyle(fontFamily: 'Inter',
                                          fontSize: context.rs(13),
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.black)),
                                  Text('ดูทั้งหมด',
                                      style: TextStyle(fontFamily: 'Inter',
                                          fontSize: context.rs(12),
                                          color: AppColors.purple,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              SizedBox(height: context.rs(8)),

                              if (_bookings.isEmpty)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: context.rs(24)),
                                  child: Center(
                                    child: Text('ไม่มีคิววันนี้',
                                        style: TextStyle(fontFamily: 'Inter',
                                            fontSize: context.rs(13),
                                            color: AppColors.textGray)),
                                  ),
                                )
                              else
                                ..._bookings.map((b) => _QueueRow(
                                      item: b,
                                      onCall: () => _callQueue(b.id),
                                      onComplete: () => _completeQueue(b.id),
                                      onCancel: () => _cancelQueue(b.id),
                                    )),
                            ],
                          ),
                        ),
                      ),
              ),
              _AdminBottomNav(
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
// _TopBar
// ============================================================
class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.adminName,
    required this.clinicName,
    this.onNotification,
    this.onSettings,
  });
  final String adminName;
  final String clinicName;
  final VoidCallback? onNotification;
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(context.rs(20), context.rs(12), context.rs(20), context.rs(8)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(adminName.isNotEmpty ? adminName : 'Admin',
                    style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(13),
                        fontWeight: FontWeight.w600, color: AppColors.black)),
                SizedBox(height: context.rs(2)),
                Text(clinicName.isNotEmpty ? clinicName : '...',
                    style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(11),
                        color: AppColors.textGray)),
              ],
            ),
          ),
          GestureDetector(onTap: onNotification,
              child: Icon(Icons.notifications_outlined, size: context.rs(22), color: AppColors.black)),
          SizedBox(width: context.rs(14)),
          GestureDetector(onTap: onSettings,
              child: Icon(Icons.settings_outlined, size: context.rs(22), color: AppColors.black)),
        ],
      ),
    );
  }
}

// ============================================================
// _StatsRow
// ============================================================
class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.total, required this.pending, required this.inProgress, required this.completed});
  final int total, pending, inProgress, completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: context.rs(12), horizontal: context.rs(8)),
      decoration: BoxDecoration(
          color: AppColors.homeBackground,
          borderRadius: BorderRadius.circular(context.rs(14))),
      child: Row(children: [
        _StatCell(label: 'คิวทั้งหมด', value: total, color: AppColors.purple),
        _vDiv(),
        _StatCell(label: 'รอเรียก', value: pending, color: AppColors.orange),
        _vDiv(),
        _StatCell(label: 'กำลังรักษา', value: inProgress, color: AppColors.greendentbook),
        _vDiv(),
        _StatCell(label: 'เสร็จสิ้น', value: completed, color: AppColors.black),
      ]),
    );
  }

  Widget _vDiv() => Container(width: 1, height: 32, color: AppColors.inputBorder);
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.label, required this.value, required this.color});
  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Text('$value', style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(20),
            fontWeight: FontWeight.w700, color: color)),
        Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(10),
            color: AppColors.textGray), textAlign: TextAlign.center),
      ]),
    );
  }
}

// ============================================================
// _CurrentQueueCard — การ์ดคิวกำลังรักษา
// ============================================================
class _CurrentQueueCard extends StatelessWidget {
  const _CurrentQueueCard({
    required this.queue,
    required this.onRefresh,
    required this.onComplete,
    required this.onSkip,
  });
  final AdminBooking queue;
  final VoidCallback onRefresh;
  final VoidCallback onComplete;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rs(16)),
      decoration: BoxDecoration(
          color: AppColors.purple, borderRadius: BorderRadius.circular(context.rs(16))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(queue.bookingCode,
              style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(22),
                  fontWeight: FontWeight.w800, color: AppColors.white)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: context.rs(10), vertical: context.rs(4)),
            decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(context.rs(20))),
            child: Text(queue.appointmentTime,
                style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(11), color: AppColors.white)),
          ),
        ]),
        SizedBox(height: context.rs(4)),
        Text(queue.patientName,
            style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(15),
                fontWeight: FontWeight.w600, color: AppColors.white)),
        Text(queue.serviceName,
            style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(11),
                color: AppColors.white.withValues(alpha: 0.8))),
        SizedBox(height: context.rs(14)),
        Row(children: [
          _ActionBtn(label: 'เรียกใหม่', icon: Icons.refresh, onTap: onRefresh),
          SizedBox(width: context.rs(8)),
          _ActionBtn(label: 'เรียกแล้ว', icon: Icons.check, onTap: onComplete, isPrimary: true),
          SizedBox(width: context.rs(8)),
          _ActionBtn(label: 'ข้ามคิว', icon: Icons.skip_next, onTap: onSkip),
        ]),
      ]),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({required this.label, required this.icon, required this.onTap, this.isPrimary = false});
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: context.rs(8)),
          decoration: BoxDecoration(
              color: isPrimary ? AppColors.white : AppColors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(context.rs(20))),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: context.rs(13), color: isPrimary ? AppColors.purple : AppColors.white),
            SizedBox(width: context.rs(4)),
            Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(11),
                fontWeight: FontWeight.w500,
                color: isPrimary ? AppColors.purple : AppColors.white)),
          ]),
        ),
      ),
    );
  }
}

// ============================================================
// _RoomRow — แถบห้องตรวจ (static 3 ห้อง)
// ============================================================
class _RoomRow extends StatelessWidget {
  const _RoomRow({required this.selectedIndex, required this.onSelect});
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static const _labels = ['ห้อง 01', 'ห้อง 02', 'ห้อง 03'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_labels.length, (i) {
          final sel = i == selectedIndex;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              margin: EdgeInsets.only(right: context.rs(8)),
              padding: EdgeInsets.symmetric(horizontal: context.rs(16), vertical: context.rs(10)),
              decoration: BoxDecoration(
                  color: sel ? AppColors.purple : AppColors.homeBackground,
                  borderRadius: BorderRadius.circular(context.rs(20))),
              child: Row(children: [
                Icon(Icons.door_front_door_outlined, size: context.rs(14),
                    color: sel ? AppColors.white : AppColors.textGray),
                SizedBox(width: context.rs(4)),
                Text(_labels[i], style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(12),
                    fontWeight: FontWeight.w500,
                    color: sel ? AppColors.white : AppColors.black)),
              ]),
            ),
          );
        }),
      ),
    );
  }
}

// ============================================================
// _QueueRow — แถวคิวในรายการ
// ============================================================
class _QueueRow extends StatelessWidget {
  const _QueueRow({required this.item, required this.onCall, required this.onComplete, required this.onCancel});
  final AdminBooking item;
  final VoidCallback onCall;
  final VoidCallback onComplete;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final Color statusColor;
    final String statusLabel;
    switch (item.status) {
      case AdminQueueStatus.inProgress:
        statusColor = AppColors.greendentbook; statusLabel = 'รักษาอยู่'; break;
      case AdminQueueStatus.completed:
        statusColor = AppColors.purple; statusLabel = 'เสร็จแล้ว'; break;
      case AdminQueueStatus.cancelled:
        statusColor = AppColors.reddentbook; statusLabel = 'ยกเลิก'; break;
      default:
        statusColor = AppColors.orange; statusLabel = 'รอเรียก';
    }

    return Container(
      margin: EdgeInsets.only(bottom: context.rs(8)),
      padding: EdgeInsets.symmetric(horizontal: context.rs(14), vertical: context.rs(12)),
      decoration: BoxDecoration(color: AppColors.homeBackground,
          borderRadius: BorderRadius.circular(context.rs(12))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          SizedBox(
            width: context.rs(58),
            child: Text(item.bookingCode,
                style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(12),
                    fontWeight: FontWeight.w700, color: AppColors.purple)),
          ),
          SizedBox(width: context.rs(8)),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.patientName,
                  style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(12),
                      fontWeight: FontWeight.w500, color: AppColors.black)),
              Text(item.serviceName,
                  style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(10), color: AppColors.textGray)),
            ]),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: context.rs(8), vertical: context.rs(3)),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(context.rs(20))),
            child: Text(statusLabel, style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(10),
                fontWeight: FontWeight.w500, color: statusColor)),
          ),
        ]),
        // Action chips สำหรับสถานะ waiting/confirmed
        if (item.status == AdminQueueStatus.waiting || item.status == AdminQueueStatus.confirmed) ...[
          SizedBox(height: context.rs(8)),
          Row(children: [
            _Chip(label: 'เรียกคิว', color: AppColors.purple, onTap: onCall),
            SizedBox(width: context.rs(6)),
            _Chip(label: 'ยกเลิก', color: AppColors.reddentbook, onTap: onCancel),
          ]),
        ],
        if (item.status == AdminQueueStatus.inProgress) ...[
          SizedBox(height: context.rs(8)),
          Row(children: [
            _Chip(label: 'เสร็จสิ้น', color: AppColors.greendentbook, onTap: onComplete),
            SizedBox(width: context.rs(6)),
            _Chip(label: 'ยกเลิก', color: AppColors.reddentbook, onTap: onCancel),
          ]),
        ],
      ]),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color, required this.onTap});
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: context.rs(12), vertical: context.rs(5)),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(context.rs(20))),
        child: Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(11),
            fontWeight: FontWeight.w500, color: color)),
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
    _NavItem(icon: Icons.qr_code_scanner, activeIcon: Icons.qr_code_scanner, label: 'สแกนคิว'),
    _NavItem(icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2, label: 'สต็อก'),
    _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'โปรไฟล์'),
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
                        size: context.rs(22), color: sel ? AppColors.purple : AppColors.textGray),
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
