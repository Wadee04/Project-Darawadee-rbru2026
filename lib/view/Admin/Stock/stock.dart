import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/supabase_stock_service.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// StockPage — หน้านับสต็อก (Supabase)
// ============================================================
class StockPage extends StatefulWidget {
  const StockPage({
    super.key,
    this.onNavTap,
    this.currentNavIndex = 2,
    this.onScanQr,
    this.onAddManual,
  });

  final void Function(int)? onNavTap;
  final int currentNavIndex;
  final VoidCallback? onScanQr;
  final VoidCallback? onAddManual;

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  String _searchQuery = '';
  int _selectedFilterIndex = 0;
  bool _loading = true;
  bool _saving = false;

  List<StockItem> _items = [];

  static const List<String> _filterLabels = ['รายการทั้งหมด', 'ใกล้หมด', 'นับแล้ว'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final rows = await SupabaseStockService.instance.getStock();
      if (mounted) {
        setState(() {
          _items = rows.map((r) {
            final qty = (r['quantity'] as num?)?.toInt() ?? 0;
            return StockItem(
              id: r['sku'] as String? ?? r['id'] as String,
              dbId: r['id'] as String,
              name: r['name'] as String? ?? '',
              qty: qty,
              status: qty <= 3 ? StockStatus.low : StockStatus.normal,
            );
          }).toList();
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _saveAll() async {
    setState(() => _saving = true);
    try {
      // อัปเดตจำนวนทุกรายการที่ isCounted == true
      final counted = _items.where((i) => i.isCounted && i.dbId != null);
      await Future.wait(counted.map((i) =>
          SupabaseStockService.instance.updateQuantity(productId: i.dbId!, quantity: i.qty)));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('บันทึกสต็อกเรียบร้อยแล้ว')));
        _load(); // reload ข้อมูลใหม่
      }
    } on AuthException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  int get _totalCount => _items.length;
  int get _lowCount => _items.where((i) => i.status == StockStatus.low).length;
  int get _countedCount => _items.where((i) => i.isCounted).length;

  List<StockItem> get _filtered {
    List<StockItem> list = _items;
    if (_searchQuery.isNotEmpty) {
      list = list.where((i) => i.name.contains(_searchQuery) || i.id.contains(_searchQuery)).toList();
    }
    switch (_selectedFilterIndex) {
      case 1: list = list.where((i) => i.status == StockStatus.low).toList(); break;
      case 2: list = list.where((i) => i.isCounted).toList(); break;
    }
    return list;
  }

  void _increment(int filteredIndex) {
    final real = _items.indexOf(_filtered[filteredIndex]);
    setState(() {
      _items[real] = _items[real].copyWith(qty: _items[real].qty + 1, isCounted: true);
    });
  }

  void _decrement(int filteredIndex) {
    final real = _items.indexOf(_filtered[filteredIndex]);
    if (_items[real].qty <= 0) return;
    setState(() {
      _items[real] = _items[real].copyWith(qty: _items[real].qty - 1, isCounted: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

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
              // ---- Title ----
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.rs(20),
                  context.rs(14),
                  context.rs(20),
                  context.rs(8),
                ),
                child: Center(
                  child: Text(
                    'นับสต็อก',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(15),
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),

              // ---- Body ----
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.rs(16),
                    0,
                    context.rs(16),
                    context.rs(16),
                  ),
                  child: Column(
                    children: [
                      // ---- Scan QR button ----
                      _OutlineBtn(
                        icon: Icons.qr_code_scanner,
                        label: 'สแกน Qr เพื่อเพิ่มรายการ',
                        onTap: widget.onScanQr,
                      ),

                      SizedBox(height: context.rs(8)),

                      // ---- Add manual button ----
                      _OutlineBtn(
                        icon: Icons.add,
                        label: 'เพิ่มรายการด้วยตอนเอง',
                        onTap: widget.onAddManual,
                      ),

                      SizedBox(height: context.rs(14)),

                      // ---- Search bar ----
                      _SearchBar(
                        onChanged: (v) => setState(() => _searchQuery = v),
                      ),

                      SizedBox(height: context.rs(12)),

                      // ---- Filter tabs ----
                      _FilterTabs(
                        labels: _filterLabels,
                        counts: [_totalCount, _lowCount, _countedCount],
                        selectedIndex: _selectedFilterIndex,
                        onSelect: (i) => setState(() => _selectedFilterIndex = i),
                        total: _totalCount,
                      ),

                      SizedBox(height: context.rs(12)),

                      // ---- Stock list ----
                      if (filtered.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: context.rs(40)),
                          child: Text(
                            'ไม่พบรายการ',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: context.rs(13),
                              color: AppColors.textGray,
                            ),
                          ),
                        )
                      else
                        ...filtered.asMap().entries.map(
                          (e) => _StockRow(
                            item: e.value,
                            onIncrement: () => _increment(e.key),
                            onDecrement: () => _decrement(e.key),
                          ),
                        ),

                      SizedBox(height: context.rs(16)),

                      // ---- Save button ----
                      SizedBox(
                        width: double.infinity,
                        height: context.rs(46),
                        child: ElevatedButton.icon(
                          onPressed: _saving ? null : _saveAll,
                          icon: _saving
                              ? SizedBox(width: context.rs(16), height: context.rs(16),
                                  child: const CircularProgressIndicator(strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.white)))
                              : Icon(Icons.check, size: context.rs(16)),
                          label: Text(_saving ? '' : 'บันทึก',
                              style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(14), fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.purple,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.rs(30))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ---- Bottom Nav ----
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
// _StockItem — data model
// ============================================================
enum StockStatus { normal, low }

class StockItem {
  const StockItem({
    required this.id,
    required this.name,
    required this.qty,
    required this.status,
    this.isCounted = false,
  });

  final String id;
  final String name;
  final int qty;
  final StockStatus status;
  final bool isCounted;

  String get statusLabel => isCounted ? 'นับแล้ว' : (status == StockStatus.low ? 'ใกล้หมด' : 'ยังไม่นับ');

  StockItem copyWith({int? qty, bool? isCounted}) => StockItem(
        id: id,
        name: name,
        qty: qty ?? this.qty,
        status: status,
        isCounted: isCounted ?? this.isCounted,
      );
}

// ============================================================
// _OutlineBtn — ปุ่มขอบเส้นประ
// ============================================================
class _OutlineBtn extends StatelessWidget {
  const _OutlineBtn({required this.icon, required this.label, this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: context.rs(13)),
        decoration: BoxDecoration(
          color: AppColors.homeBackground,
          borderRadius: BorderRadius.circular(context.rs(12)),
          border: Border.all(color: AppColors.inputBorder, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: context.rs(17), color: AppColors.purple),
            SizedBox(width: context.rs(8)),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(13),
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _SearchBar — ช่องค้นหา
// ============================================================
class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(30)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.rs(14)),
        child: Row(
          children: [
            Icon(Icons.search, size: context.rs(18), color: AppColors.inputHint),
            SizedBox(width: context.rs(8)),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(13), color: AppColors.black),
                decoration: InputDecoration(
                  hintText: 'ค้นหาสินค้า หรือ รหัส',
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(13),
                    color: AppColors.inputHint,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: context.rs(12)),
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
// _FilterTabs — แถบ filter 3 ตัวเลือก
// ============================================================
class _FilterTabs extends StatelessWidget {
  const _FilterTabs({
    required this.labels,
    required this.counts,
    required this.selectedIndex,
    required this.onSelect,
    required this.total,
  });

  final List<String> labels;
  final List<int> counts;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (i) {
        final isSelected = i == selectedIndex;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: context.rs(3)),
              padding: EdgeInsets.symmetric(
                horizontal: context.rs(8),
                vertical: context.rs(10),
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.purple : AppColors.homeBackground,
                borderRadius: BorderRadius.circular(context.rs(12)),
                border: Border.all(
                  color: isSelected ? AppColors.purple : AppColors.inputBorder,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    labels[i] == 'นับแล้ว' ? '${counts[i]}/$total' : '${counts[i]}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(16),
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppColors.white : AppColors.black,
                    ),
                  ),
                  SizedBox(height: context.rs(2)),
                  Text(
                    labels[i],
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(10),
                      color: isSelected
                          ? AppColors.white.withValues(alpha: 0.85)
                          : AppColors.textGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ============================================================
// _StockRow — แถวรายการสต็อก
// ============================================================
class _StockRow extends StatelessWidget {
  const _StockRow({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  final StockItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final Color statusColor;
    switch (item.status) {
      case StockStatus.low:
        statusColor = AppColors.orange;
        break;
      default:
        statusColor = AppColors.greendentbook;
    }
    final bool showBadge = item.status == StockStatus.low && !item.isCounted;
    final String badgeLabel = item.isCounted ? 'นับแล้ว' : 'ใกล้หมด';
    final Color badgeColor = item.isCounted ? AppColors.greendentbook : AppColors.orange;

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
          // ---- name + id ----
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(13),
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    if (showBadge || item.isCounted)
                      Container(
                        margin: EdgeInsets.only(left: context.rs(6)),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.rs(8),
                          vertical: context.rs(2),
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(context.rs(20)),
                        ),
                        child: Text(
                          badgeLabel,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(10),
                            fontWeight: FontWeight.w500,
                            color: badgeColor,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: context.rs(3)),
                Text(
                  '${item.id} • ${item.isCounted ? "นับแล้ว" : "ยังไม่นับ"}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(11),
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: context.rs(12)),

          // ---- qty counter ----
          Row(
            children: [
              // ลด
              GestureDetector(
                onTap: onDecrement,
                child: Container(
                  width: context.rs(28),
                  height: context.rs(28),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.inputBorder, width: 1),
                  ),
                  child: Icon(Icons.remove, size: context.rs(14), color: AppColors.textGray),
                ),
              ),

              SizedBox(width: context.rs(10)),

              Text(
                '${item.qty}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(15),
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),

              SizedBox(width: context.rs(10)),

              // เพิ่ม
              GestureDetector(
                onTap: onIncrement,
                child: Container(
                  width: context.rs(28),
                  height: context.rs(28),
                  decoration: BoxDecoration(
                    color: AppColors.purple,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, size: context.rs(14), color: AppColors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _AdminBottomNav — bottom navigation bar Admin
// ============================================================
class _AdminBottomNav extends StatelessWidget {
  const _AdminBottomNav({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'ภาพรวม'),
    _NavItem(icon: Icons.qr_code_scanner, activeIcon: Icons.qr_code_scanner, label: 'สแกนคิว'),
    _NavItem(icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2, label: 'สต็อก'),
    _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'โปรไฟล์'),
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
