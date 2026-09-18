import 'package:flutter/material.dart';

import '../../../services/admin/admin_booking_service.dart';
import '../../../services/admin/admin_models.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

/// หน้า “ข้อมูลผู้ป่วย” ตามดีไซน์ที่แนบ
///
/// รายชื่อและสถานะมาจากรายการจองจริงของคลินิกใน Supabase
class PatientDataTwo extends StatefulWidget {
  const PatientDataTwo({
    super.key,
    this.onBack,
    this.onPatientTap,
  });

  final VoidCallback? onBack;
  final ValueChanged<PatientDataTwoItem>? onPatientTap;

  @override
  State<PatientDataTwo> createState() => _PatientDataTwoState();
}

enum _PatientFilter { all, today, allergy }

class _PatientDataTwoState extends State<PatientDataTwo> {
  bool _loading = true;
  String _search = '';
  _PatientFilter _filter = _PatientFilter.today;
  List<PatientDataTwoItem> _patients = const [];

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    if (mounted) setState(() => _loading = true);
    try {
      final bookings = await AdminBookingService.instance.getAllBookings();
      final byUser = <String, List<AdminBooking>>{};
      for (final booking in bookings) {
        byUser.putIfAbsent(booking.userId, () => <AdminBooking>[]).add(booking);
      }

      final patients = <PatientDataTwoItem>[];
      for (final entry in byUser.entries) {
        final userBookings = entry.value
          ..sort((a, b) {
            final dateResult = b.appointmentDate.compareTo(a.appointmentDate);
            if (dateResult != 0) return dateResult;
            return b.appointmentTime.compareTo(a.appointmentTime);
          });

        final todayBooking = userBookings.cast<AdminBooking?>().firstWhere(
              (booking) => booking != null && _isToday(booking.appointmentDate),
              orElse: () => null,
            );
        final displayBooking = todayBooking ?? userBookings.first;

        patients.add(
          PatientDataTwoItem(
            userId: entry.key,
            hn: _hnFromUserId(entry.key),
            name: displayBooking.patientName,
            phone: displayBooking.patientPhone,
            todayBooking: todayBooking,
            latestBooking: userBookings.first,
            totalBookings: userBookings.length,
            hasDrugAllergy: false,
          ),
        );
      }

      patients.sort((a, b) {
        if (a.todayBooking != null && b.todayBooking == null) return -1;
        if (a.todayBooking == null && b.todayBooking != null) return 1;
        final aDate = a.todayBooking?.appointmentDate ?? a.latestBooking.appointmentDate;
        final bDate = b.todayBooking?.appointmentDate ?? b.latestBooking.appointmentDate;
        final dateResult = bDate.compareTo(aDate);
        if (dateResult != 0) return dateResult;
        return a.name.compareTo(b.name);
      });

      if (!mounted) return;
      setState(() {
        _patients = patients;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('โหลดข้อมูลผู้ป่วยไม่สำเร็จ: $error')),
      );
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _hnFromUserId(String userId) {
    var value = 0;
    for (final code in userId.codeUnits) {
      value = (value * 31 + code) % 100000;
    }
    return 'HN-${value.toString().padLeft(5, '0')}';
  }

  List<PatientDataTwoItem> get _visiblePatients {
    Iterable<PatientDataTwoItem> result = _patients;

    switch (_filter) {
      case _PatientFilter.today:
        result = result.where((patient) => patient.todayBooking != null);
      case _PatientFilter.allergy:
        result = result.where((patient) => patient.hasDrugAllergy);
      case _PatientFilter.all:
        break;
    }

    final query = _search.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((patient) =>
          patient.name.toLowerCase().contains(query) ||
          patient.phone.toLowerCase().contains(query) ||
          patient.hn.toLowerCase().contains(query));
    }

    return result.toList();
  }

  int get _todayCount =>
      _patients.where((patient) => patient.todayBooking != null).length;

  int get _allergyCount =>
      _patients.where((patient) => patient.hasDrugAllergy).length;

  @override
  Widget build(BuildContext context) {
    final visiblePatients = _visiblePatients;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _Header(onBack: widget.onBack),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rs(20)),
              child: _SearchField(
                onChanged: (value) => setState(() => _search = value),
              ),
            ),
            SizedBox(height: context.rs(12)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.rs(20)),
              child: Row(
                children: [
                  Expanded(
                    child: _FilterPill(
                      label: 'ทั้งหมด ${_patients.length}',
                      selected: _filter == _PatientFilter.all,
                      onTap: () => setState(() => _filter = _PatientFilter.all),
                    ),
                  ),
                  SizedBox(width: context.rs(8)),
                  Expanded(
                    child: _FilterPill(
                      label: 'นัดวันนี้ $_todayCount',
                      selected: _filter == _PatientFilter.today,
                      onTap: () => setState(() => _filter = _PatientFilter.today),
                    ),
                  ),
                  SizedBox(width: context.rs(8)),
                  Expanded(
                    child: _FilterPill(
                      label: 'แพ้ยา$_allergyCount',
                      selected: _filter == _PatientFilter.allergy,
                      onTap: () => setState(() => _filter = _PatientFilter.allergy),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.rs(8)),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _loadPatients,
                      child: visiblePatients.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(height: context.rs(170)),
                                Center(
                                  child: Text(
                                    _filter == _PatientFilter.allergy
                                        ? 'ยังไม่มีข้อมูลประวัติแพ้ยา'
                                        : 'ไม่พบข้อมูลผู้ป่วย',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: context.rs(13),
                                      color: AppColors.textGray,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.fromLTRB(
                                context.rs(20),
                                0,
                                context.rs(20),
                                context.rs(28),
                              ),
                              itemCount: visiblePatients.length,
                              separatorBuilder: (_, _) => const Divider(
                                height: 1,
                                thickness: 0.7,
                                color: AppColors.inputBorder,
                              ),
                              itemBuilder: (context, index) {
                                final patient = visiblePatients[index];
                                return _PatientRow(
                                  patient: patient,
                                  onTap: () => widget.onPatientTap?.call(patient),
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientDataTwoItem {
  const PatientDataTwoItem({
    required this.userId,
    required this.hn,
    required this.name,
    required this.phone,
    required this.latestBooking,
    required this.totalBookings,
    required this.hasDrugAllergy,
    this.todayBooking,
  });

  final String userId;
  final String hn;
  final String name;
  final String phone;
  final AdminBooking latestBooking;
  final AdminBooking? todayBooking;
  final int totalBookings;
  final bool hasDrugAllergy;
}

class _Header extends StatelessWidget {
  const _Header({this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.rs(8),
        context.rs(6),
        context.rs(8),
        context.rs(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBack ?? () => Navigator.maybePop(context),
              icon: Icon(
                Icons.chevron_left,
                size: context.rs(28),
                color: AppColors.black,
              ),
            ),
          ),
          Text(
            'ข้อมูลผู้ป่วย',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(15),
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.rs(48),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.rs(26)),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: TextField(
        onChanged: onChanged,
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: context.rs(13),
          color: AppColors.black,
        ),
        decoration: InputDecoration(
          hintText: 'ค้นหาชื่อหรือเบอร์โทรศัพท์',
          hintStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(13),
            color: AppColors.inputHint,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: context.rs(22),
            color: AppColors.textGray,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: context.rs(13)),
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: context.rs(36),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.orange : AppColors.white,
          borderRadius: BorderRadius.circular(context.rs(20)),
          border: selected
              ? null
              : Border.all(color: AppColors.inputBorder, width: 1),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(11),
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}

class _PatientRow extends StatelessWidget {
  const _PatientRow({required this.patient, required this.onTap});

  final PatientDataTwoItem patient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final booking = patient.todayBooking ?? patient.latestBooking;
    final status = _PatientStatus.fromBooking(booking, hasToday: patient.todayBooking != null);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.rs(11)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: context.rs(2)),
                  Text(
                    '${patient.hn} • ${_detailText(patient)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(12),
                      fontWeight: FontWeight.w400,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: context.rs(12)),
            _StatusPill(status: status),
          ],
        ),
      ),
    );
  }

  String _detailText(PatientDataTwoItem patient) {
    final today = patient.todayBooking;
    if (today != null) {
      final time = today.appointmentTime.length >= 5
          ? today.appointmentTime.substring(0, 5)
          : today.appointmentTime;
      return 'นัดวันนี้ $time';
    }

    final date = patient.latestBooking.appointmentDate;
    const months = [
      '', 'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
      'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
    ];
    return 'ครั้งล่าสุด ${date.day} ${months[date.month]} ${(date.year + 543) % 100}';
  }
}

enum _PatientStatusType { examining, waiting, completed, cancelled }

class _PatientStatus {
  const _PatientStatus(this.label, this.type);

  final String label;
  final _PatientStatusType type;

  factory _PatientStatus.fromBooking(
    AdminBooking booking, {
    required bool hasToday,
  }) {
    switch (booking.status) {
      case AdminQueueStatus.inProgress:
        return const _PatientStatus('กำลังตรวจ', _PatientStatusType.examining);
      case AdminQueueStatus.waiting:
      case AdminQueueStatus.confirmed:
        if (hasToday) {
          return const _PatientStatus('รอคิว', _PatientStatusType.waiting);
        }
        return const _PatientStatus('เสร็จแล้ว', _PatientStatusType.completed);
      case AdminQueueStatus.completed:
        return const _PatientStatus('เสร็จแล้ว', _PatientStatusType.completed);
      case AdminQueueStatus.cancelled:
        return const _PatientStatus('ยกเลิก', _PatientStatusType.cancelled);
    }
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final _PatientStatus status;

  @override
  Widget build(BuildContext context) {
    final Color background;
    final Color foreground;

    switch (status.type) {
      case _PatientStatusType.examining:
        background = const Color(0xFFB7D9FF);
        foreground = const Color(0xFF2383E2);
      case _PatientStatusType.waiting:
        background = const Color(0xFFFFD6BA);
        foreground = const Color(0xFFFF7A1A);
      case _PatientStatusType.completed:
        background = const Color(0xFFCAF3D4);
        foreground = const Color(0xFF4DAA69);
      case _PatientStatusType.cancelled:
        background = const Color(0xFFFFCCD1);
        foreground = const Color(0xFFFF4D5B);
    }

    return Container(
      constraints: BoxConstraints(minWidth: context.rs(82)),
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(13),
        vertical: context.rs(6),
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(context.rs(18)),
      ),
      alignment: Alignment.center,
      child: Text(
        status.label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: context.rs(11),
          fontWeight: FontWeight.w500,
          color: foreground,
        ),
      ),
    );
  }
}
