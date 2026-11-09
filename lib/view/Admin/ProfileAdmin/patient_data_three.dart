import 'package:flutter/material.dart';

import '../../../services/admin/admin_booking_service.dart';
import '../../../services/admin/admin_models.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

/// หน้าแสดงผู้ป่วยที่มีประวัติแพ้ยา ตามดีไซน์ที่แนบ
///
/// รูปแบบข้อมูลแพ้ยาใน bookings.note:
/// `แพ้ยา: เพนิซิลิน|รุนแรง, ลาเท็กซ์|ปานกลาง`
class PatientDataThree extends StatefulWidget {
  const PatientDataThree({
    super.key,
    this.onBack,
    this.onPatientTap,
  });

  final VoidCallback? onBack;
  final ValueChanged<PatientAllergyItem>? onPatientTap;

  @override
  State<PatientDataThree> createState() => _PatientDataThreeState();
}

enum _PatientFilter { all, today, allergy }

enum AllergySeverity { severe, moderate, mild }

class _PatientDataThreeState extends State<PatientDataThree> {
  bool _loading = true;
  String _search = '';
  _PatientFilter _filter = _PatientFilter.allergy;
  List<PatientAllergyItem> _patients = const [];

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

      final patients = <PatientAllergyItem>[];
      for (final entry in byUser.entries) {
        final userBookings = entry.value
          ..sort((a, b) {
            final result = b.appointmentDate.compareTo(a.appointmentDate);
            if (result != 0) return result;
            return b.appointmentTime.compareTo(a.appointmentTime);
          });

        final allergiesByName = <String, PatientAllergy>{};
        for (final booking in userBookings) {
          for (final allergy in _parseAllergies(booking.note)) {
            allergiesByName[allergy.name] = allergy;
          }
        }

        final todayBooking = userBookings.cast<AdminBooking?>().firstWhere(
              (booking) => booking != null && _isToday(booking.appointmentDate),
              orElse: () => null,
            );
        final displayBooking = todayBooking ?? userBookings.first;

        patients.add(
          PatientAllergyItem(
            userId: entry.key,
            hn: _hnFromUserId(entry.key),
            name: displayBooking.patientName,
            phone: displayBooking.patientPhone,
            latestBooking: userBookings.first,
            todayBooking: todayBooking,
            allergies: allergiesByName.values.toList(),
          ),
        );
      }

      patients.sort((a, b) {
        if (a.todayBooking != null && b.todayBooking == null) return -1;
        if (a.todayBooking == null && b.todayBooking != null) return 1;
        final aDate = a.todayBooking?.appointmentDate ?? a.latestBooking.appointmentDate;
        final bDate = b.todayBooking?.appointmentDate ?? b.latestBooking.appointmentDate;
        final result = bDate.compareTo(aDate);
        return result != 0 ? result : a.name.compareTo(b.name);
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

  List<PatientAllergy> _parseAllergies(String? note) {
    if (note == null || note.trim().isEmpty) return const [];

    final match = RegExp(
      r'(?:แพ้ยา|allerg(?:y|ies))\s*[:：]\s*([^;\n]+)',
      caseSensitive: false,
    ).firstMatch(note);
    if (match == null) return const [];

    return match.group(1)!
        .split(RegExp(r'[,，]'))
        .map((raw) => raw.trim())
        .where((raw) => raw.isNotEmpty)
        .map((raw) {
          final parts = raw.split(RegExp(r'\s*[|•]\s*'));
          final name = parts.first.trim();
          final severityText = parts.length > 1 ? parts[1].trim() : 'ปานกลาง';
          return PatientAllergy(
            name: name,
            severity: _parseSeverity(severityText),
          );
        })
        .where((allergy) => allergy.name.isNotEmpty)
        .toList();
  }

  AllergySeverity _parseSeverity(String value) {
    final normalized = value.toLowerCase();
    if (normalized.contains('รุนแรง') ||
        normalized.contains('severe') ||
        normalized.contains('high')) {
      return AllergySeverity.severe;
    }
    if (normalized.contains('เล็กน้อย') ||
        normalized.contains('mild') ||
        normalized.contains('low')) {
      return AllergySeverity.mild;
    }
    return AllergySeverity.moderate;
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

  List<PatientAllergyItem> get _visiblePatients {
    Iterable<PatientAllergyItem> result = _patients;
    switch (_filter) {
      case _PatientFilter.all:
        break;
      case _PatientFilter.today:
        result = result.where((patient) => patient.todayBooking != null);
      case _PatientFilter.allergy:
        result = result.where((patient) => patient.allergies.isNotEmpty);
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
      _patients.where((patient) => patient.allergies.isNotEmpty).length;

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
                                    'ยังไม่มีข้อมูลประวัติแพ้ยา',
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
                                return _AllergyPatientRow(
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

class PatientAllergyItem {
  const PatientAllergyItem({
    required this.userId,
    required this.hn,
    required this.name,
    required this.phone,
    required this.latestBooking,
    required this.allergies,
    this.todayBooking,
  });

  final String userId;
  final String hn;
  final String name;
  final String phone;
  final AdminBooking latestBooking;
  final AdminBooking? todayBooking;
  final List<PatientAllergy> allergies;
}

class PatientAllergy {
  const PatientAllergy({required this.name, required this.severity});

  final String name;
  final AllergySeverity severity;

  String get severityLabel {
    switch (severity) {
      case AllergySeverity.severe:
        return 'รุนแรง';
      case AllergySeverity.moderate:
        return 'ปานกลาง';
      case AllergySeverity.mild:
        return 'เล็กน้อย';
    }
  }
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

class _AllergyPatientRow extends StatelessWidget {
  const _AllergyPatientRow({required this.patient, required this.onTap});

  final PatientAllergyItem patient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.rs(11)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      color: AppColors.textGray,
                    ),
                  ),
                  if (patient.allergies.isNotEmpty) ...[
                    SizedBox(height: context.rs(8)),
                    Wrap(
                      spacing: context.rs(8),
                      runSpacing: context.rs(6),
                      children: patient.allergies
                          .map((allergy) => _AllergyChip(allergy: allergy))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: context.rs(8)),
            Icon(
              Icons.chevron_right,
              size: context.rs(22),
              color: AppColors.textGray,
            ),
          ],
        ),
      ),
    );
  }

  String _detailText(PatientAllergyItem patient) {
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

class _AllergyChip extends StatelessWidget {
  const _AllergyChip({required this.allergy});

  final PatientAllergy allergy;

  @override
  Widget build(BuildContext context) {
    final isSevere = allergy.severity == AllergySeverity.severe;
    final background = isSevere
        ? const Color(0xFFFFC8CD)
        : const Color(0xFFFFDEA1);
    final foreground = isSevere
        ? const Color(0xFFFF313F)
        : const Color(0xFFE69A00);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(13),
        vertical: context.rs(5),
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(context.rs(18)),
      ),
      child: Text(
        '${allergy.name} • ${allergy.severityLabel}',
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
