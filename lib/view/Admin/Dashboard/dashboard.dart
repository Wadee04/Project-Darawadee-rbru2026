import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// DashboardPage — หน้าหลัก Admin Dashboard
// ============================================================
class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    this.adminName = 'สวัสดี, ดาราวดี 👋',
    this.clinicName = 'คลินิกทันตกรรมใจ๋',
    this.totalQueue = 24,
    this.pendingQueue = 12,
    this.inProgressQueue = 4,
    this.completedQueue = 10,
    this.onNotification,
    this.onSettings,
  });

  final String adminName;
  final String clinicName;
  final int totalQueue;
  final int pendingQueue;
  final int inProgressQueue;
  final int completedQueue;
  final VoidCallback? onNotification;
  final VoidCallback? onSettings;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentNav = 0;
  int _roomIndex = 0;
  String _selectedClinic = 'คลินิกทันตกรรมใจ๋';

  // mock data คิว
  static final List<_QueueItem> _allQueues = [
    _QueueItem(id: 'A-001', name: 'คุณสมสมาย ใจดี', service: 'ขูดหินปูน', room: 1, status: _QStatus.inProgress),
    _QueueItem(id: 'A-003', name: 'คุณดาราวดี อาลัย', service: 'ขูดหินปูน', room: 1, status: _QStatus.pending),
    _QueueItem(id: 'B-001', name: 'คุณดาราวดี อาสัย', service: 'ขูดหินปูน', room: 1, status: _QStatus.pending),
    _QueueItem(id: 'C-001', name: 'คุณดาราวดี อาสัย', service: 'ขูดหินปูน', room: 2, status: _QStatus.cancelled),
    _QueueItem(id: 'B-002', name: 'คุณดาราวดี อาสัย', service: 'ขูดหินปูน', room: 2, status: _QStatus.pending),
    _QueueItem(id: 'A-004', name: 'คุณดาราวดี อาสัย', service: 'ขูดหินปูน', room: 3, status: _QStatus.pending),
    _QueueItem(id: 'B-003', name: 'คุณดาราวดี อาสัย', service: 'ขูดหินปูน', room: 3, status: _QStatus.pending),
  ];

  static final List<_RoomCard> _rooms = [
    _RoomCard(label: 'ห้อง 01', doctorLabel: 'ทพญ.'),
    _RoomCard(label: 'ห้อง 02', doctorLabel: 'ทพญ.'),
    _RoomCard(label: 'ห้อง 03 +', doctorLabel: 'ทพญ.'),
  ];

  _QueueItem? get _currentQueue =>
      _allQueues.where((q) => q.status == _QStatus.inProgress).firstOrNull;

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
              // ---- Top bar ----
              _TopBar(
                adminName: widget.adminName,
                clinicName: widget.clinicName,
                onNotification: widget.onNotification,
                onSettings: widget.onSettings,
              ),

              // ---- Body ----
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.rs(16),
                    context.rs(8),
                    context.rs(16),
                    context.rs(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---- Stats row ----
                      _StatsRow(
                        total: widget.totalQueue,
                        pending: widget.pendingQueue,
                        inProgress: widget.inProgressQueue,
                        completed: widget.completedQueue,
                      ),

                      SizedBox(height: context.rs(14)),

                      // ---- Clinic dropdown ----
                      _ClinicDropdown(
                        value: _selectedClinic,
                        items: const ['คลินิกทันตกรรมใจ๋', 'สาขา 2'],
                        onChanged: (v) => setState(() => _selectedClinic = v ?? _selectedClinic),
                      ),

                      SizedBox(height: context.rs(14)),

                      // ---- Current queue card ----
                      if (_currentQueue != null)
                        _CurrentQueueCard(queue: _currentQueue!),

                      SizedBox(height: context.rs(14)),

                      // ---- Rooms ----
                      _RoomRow(
                        rooms: _rooms,
                        selectedIndex: _roomIndex,
                        onSelect: (i) => setState(() => _roomIndex = i),
                      ),

                      SizedBox(height: context.rs(14)),

                      // ---- Queue list header ----
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'คิวรอเจ็บ',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: context.rs(13),
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                          Text(
                            'ดูทั้งหมด',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: context.rs(12),
                              color: AppColors.purple,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: context.rs(8)),

                      // ---- Queue list ----
                      ..._allQueues.map((q) => _QueueRow(item: q)),
                    ],
                  ),
                ),
              ),

              // ---- Bottom Nav ----
              _AdminBottomNav(
                currentIndex: _currentNav,
                onTap: (i) => setState(() => _currentNav = i),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _TopBar — greeting + clinic name + icons
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
      padding: EdgeInsets.fromLTRB(
        context.rs(20),
        context.rs(12),
        context.rs(20),
        context.rs(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  adminName,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(13),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: context.rs(2)),
                Text(
                  clinicName,
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
          GestureDetector(
            onTap: onNotification,
            child: Icon(Icons.notifications_outlined, size: context.rs(22), color: AppColors.black),
          ),
          SizedBox(width: context.rs(14)),
          GestureDetector(
            onTap: onSettings,
            child: Icon(Icons.settings_outlined, size: context.rs(22), color: AppColors.black),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _StatsRow — 4 ตัวเลขสถิติคิว
// ============================================================
class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.total,
    required this.pending,
    required this.inProgress,
    required this.completed,
  });
  final int total;
  final int pending;
  final int inProgress;
  final int completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: context.rs(12),
        horizontal: context.rs(8),
      ),
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(14)),
      ),
      child: Row(
        children: [
          _StatCell(label: 'คิวทั้งหมด', value: total, color: AppColors.purple),
          _vDivider(),
          _StatCell(label: 'รอเรียก', value: pending, color: AppColors.orange),
          _vDivider(),
          _StatCell(label: 'กำลังรักษา', value: inProgress, color: AppColors.greendentbook),
          _vDivider(),
          _StatCell(label: 'เสร็จสิ้น', value: completed, color: AppColors.black),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(
        width: 1,
        height: 32,
        color: AppColors.inputBorder,
      );
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.label, required this.value, required this.color});
  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(20),
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(10),
              color: AppColors.textGray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _ClinicDropdown — เลือกคลินิก/สาขา
// ============================================================
class _ClinicDropdown extends StatelessWidget {
  const _ClinicDropdown({required this.value, required this.items, required this.onChanged});
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(30)),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: context.rs(14)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, size: context.rs(18), color: AppColors.textGray),
          style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(13), color: AppColors.black),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ============================================================
// _CurrentQueueCard — การ์ดคิวกำลังรักษา
// ============================================================
class _CurrentQueueCard extends StatelessWidget {
  const _CurrentQueueCard({required this.queue});
  final _QueueItem queue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rs(16)),
      decoration: BoxDecoration(
        color: AppColors.purple,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- header row ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                queue.id,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(22),
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.rs(10),
                  vertical: context.rs(4),
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(context.rs(20)),
                ),
                child: Text(
                  'ห้อง 02',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(11),
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: context.rs(4)),

          Text(
            queue.name,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(15),
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          Text(
            queue.service,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(11),
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ),

          SizedBox(height: context.rs(14)),

          // ---- action buttons ----
          Row(
            children: [
              _ActionBtn(label: 'เรียกใหม่', icon: Icons.refresh, onTap: () {}),
              SizedBox(width: context.rs(8)),
              _ActionBtn(label: 'เรียกแล้ว', icon: Icons.check, onTap: () {}, isPrimary: true),
              SizedBox(width: context.rs(8)),
              _ActionBtn(label: 'ข้ามคิว', icon: Icons.skip_next, onTap: () {}),
            ],
          ),
        ],
      ),
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
            color: isPrimary
                ? AppColors.white
                : AppColors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(context.rs(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: context.rs(13),
                color: isPrimary ? AppColors.purple : AppColors.white,
              ),
              SizedBox(width: context.rs(4)),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(11),
                  fontWeight: FontWeight.w500,
                  color: isPrimary ? AppColors.purple : AppColors.white,
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
// _RoomRow — แถวห้องตรวจ
// ============================================================
class _RoomCard {
  const _RoomCard({required this.label, required this.doctorLabel});
  final String label;
  final String doctorLabel;
}

class _RoomRow extends StatelessWidget {
  const _RoomRow({required this.rooms, required this.selectedIndex, required this.onSelect});
  final List<_RoomCard> rooms;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: rooms.asMap().entries.map((e) {
          final isSelected = e.key == selectedIndex;
          return GestureDetector(
            onTap: () => onSelect(e.key),
            child: Container(
              margin: EdgeInsets.only(right: context.rs(8)),
              padding: EdgeInsets.symmetric(
                horizontal: context.rs(16),
                vertical: context.rs(10),
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.purple : AppColors.homeBackground,
                borderRadius: BorderRadius.circular(context.rs(20)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.door_front_door_outlined,
                    size: context.rs(14),
                    color: isSelected ? AppColors.white : AppColors.textGray,
                  ),
                  SizedBox(width: context.rs(4)),
                  Text(
                    e.value.label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(12),
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppColors.white : AppColors.black,
                    ),
                  ),
                  SizedBox(width: context.rs(4)),
                  Text(
                    e.value.doctorLabel,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(10),
                      color: isSelected ? AppColors.white.withValues(alpha: 0.8) : AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ============================================================
// _QueueItem — data model คิว
// ============================================================
enum _QStatus { inProgress, pending, cancelled }

class _QueueItem {
  const _QueueItem({
    required this.id,
    required this.name,
    required this.service,
    required this.room,
    required this.status,
  });
  final String id;
  final String name;
  final String service;
  final int room;
  final _QStatus status;
}

// ============================================================
// _QueueRow — แถวคิวในรายการ
// ============================================================
class _QueueRow extends StatelessWidget {
  const _QueueRow({required this.item});
  final _QueueItem item;

  @override
  Widget build(BuildContext context) {
    final Color statusColor;
    final String statusLabel;
    switch (item.status) {
      case _QStatus.inProgress:
        statusColor = AppColors.greendentbook;
        statusLabel = 'รักษาอยู่';
        break;
      case _QStatus.pending:
        statusColor = AppColors.orange;
        statusLabel = 'รอเรียก';
        break;
      case _QStatus.cancelled:
        statusColor = AppColors.reddentbook;
        statusLabel = 'ยกเลิก';
        break;
    }

    return Container(
      margin: EdgeInsets.only(bottom: context.rs(8)),
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(14),
        vertical: context.rs(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(12)),
      ),
      child: Row(
        children: [
          // ---- Queue ID ----
          SizedBox(
            width: context.rs(44),
            child: Text(
              item.id,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(13),
                fontWeight: FontWeight.w700,
                color: AppColors.purple,
              ),
            ),
          ),
          SizedBox(width: context.rs(8)),
          // ---- name + service ----
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(12),
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  item.service,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(10),
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
          // ---- room chip ----
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.rs(8),
              vertical: context.rs(3),
            ),
            decoration: BoxDecoration(
              color: AppColors.purpleLight,
              borderRadius: BorderRadius.circular(context.rs(20)),
            ),
            child: Text(
              'ห้อง0${item.room}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(10),
                color: AppColors.purple,
              ),
            ),
          ),
          SizedBox(width: context.rs(6)),
          // ---- status chip ----
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.rs(8),
              vertical: context.rs(3),
            ),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(context.rs(20)),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(10),
                fontWeight: FontWeight.w500,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _AdminBottomNav — bottom navigation bar
// ============================================================
class _AdminBottomNav extends StatelessWidget {
  const _AdminBottomNav({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'ภาพรวม'),
    _NavItem(icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month, label: 'ตารางนัด'),
    _NavItem(icon: Icons.people_outline, activeIcon: Icons.people, label: 'ผู้ป่วย'),
    _NavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'ตั้งค่า'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: context.rs(6)),
          child: Row(
            children: _items.asMap().entries.map((e) {
              final isSelected = e.key == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(e.key),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? e.value.activeIcon : e.value.icon,
                        size: context.rs(22),
                        color: isSelected ? AppColors.purple : AppColors.textGray,
                      ),
                      SizedBox(height: context.rs(2)),
                      Text(
                        e.value.label,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(10),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? AppColors.purple : AppColors.textGray,
                        ),
                      ),
                    ],
                  ),
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
