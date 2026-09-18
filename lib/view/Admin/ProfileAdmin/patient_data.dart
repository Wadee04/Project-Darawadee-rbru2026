import 'package:flutter/material.dart';

import '../../../services/admin/admin_clinic_service.dart';
import '../../../services/admin/admin_models.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// PatientDataPage — ข้อมูลผู้ป่วยของคลินิก (Admin) — Supabase
// ============================================================
class PatientDataPage extends StatefulWidget {
  const PatientDataPage({
    super.key,
    this.onBack,
    this.onPatientTap,
  });

  final VoidCallback? onBack;
  final void Function(PatientItem patient)? onPatientTap;

  @override
  State<PatientDataPage> createState() => _PatientDataPageState();
}

class _PatientDataPageState extends State<PatientDataPage> {
  String _search = '';
  bool _loading = true;
  List<PatientItem> _patients = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({String? search}) async {
    setState(() => _loading = true);
    try {
      final result = await AdminClinicService.instance.getPatients(search: search);
      if (mounted) {
        setState(() {
          _patients = result.map((p) => PatientItem(
            id: p.id,
            name: p.fullName,
            phone: p.phone,
            email: p.email,
            lastVisit: p.lastVisit ?? DateTime.now(),
            totalVisits: p.totalBookings,
            gender: p.gender,
            birthDate: p.birthDate,
          )).toList();
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
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
            colors: [Color(0xFFFFFFFF), Color(0xFFC5DEE8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- AppBar ----
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.rs(8),
                  MediaQuery.of(context).size.height * 0.01,
                  context.rs(20),
                  context.rs(8),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: widget.onBack ?? () => Navigator.maybePop(context),
                        child: Padding(
                          padding: EdgeInsets.all(context.rs(8)),
                          child: Icon(Icons.chevron_left, size: context.rs(28), color: AppColors.black),
                        ),
                      ),
                    ),
                    Text('ข้อมูลผู้ป่วย',
                        style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(15),
                            fontWeight: FontWeight.w600, color: AppColors.black)),
                  ],
                ),
              ),

              // ---- Search ----
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.rs(16), vertical: context.rs(4)),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.homeBackground,
                    borderRadius: BorderRadius.circular(context.rs(30)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.rs(14)),
                    child: Row(children: [
                      Icon(Icons.search, size: context.rs(18), color: AppColors.inputHint),
                      SizedBox(width: context.rs(8)),
                      Expanded(
                        child: TextField(
                          onChanged: (v) {
                            setState(() => _search = v);
                            _load(search: v.isEmpty ? null : v);
                          },
                          style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(13), color: AppColors.black),
                          decoration: InputDecoration(
                            hintText: 'ค้นหาชื่อ / เบอร์โทร / อีเมล',
                            hintStyle: TextStyle(fontFamily: 'Inter', fontSize: context.rs(13), color: AppColors.inputHint),
                            border: InputBorder.none, enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: context.rs(12)),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),

              SizedBox(height: context.rs(4)),

              // ---- Count ----
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.rs(20)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('ทั้งหมด ${_patients.length} คน',
                      style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(12), color: AppColors.textGray)),
                ),
              ),

              SizedBox(height: context.rs(8)),

              // ---- List ----
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _patients.isEmpty
                        ? Center(
                            child: Text('ไม่พบข้อมูลผู้ป่วย',
                                style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(13), color: AppColors.textGray)),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.fromLTRB(context.rs(16), 0, context.rs(16), context.rs(24)),
                            itemCount: _patients.length,
                            separatorBuilder: (_, __) => SizedBox(height: context.rs(8)),
                            itemBuilder: (_, i) => _PatientCard(
                              patient: _patients[i],
                              onTap: () => widget.onPatientTap?.call(_patients[i]),
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

// ---- Model ----
class PatientItem {
  const PatientItem({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.lastVisit,
    required this.totalVisits,
    this.gender,
    this.birthDate,
  });

  final String id;
  final String name;
  final String phone;
  final String email;
  final DateTime lastVisit;
  final int totalVisits;
  final String? gender;
  final DateTime? birthDate;
}

// ---- Patient card ----
class _PatientCard extends StatelessWidget {
  const _PatientCard({required this.patient, required this.onTap});
  final PatientItem patient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.rs(14)),
        decoration: BoxDecoration(
          color: AppColors.homeBackground,
          borderRadius: BorderRadius.circular(context.rs(12)),
        ),
        child: Row(
          children: [
            // avatar
            Container(
              width: context.rs(40),
              height: context.rs(40),
              decoration: BoxDecoration(color: AppColors.purpleLight, shape: BoxShape.circle),
              child: Icon(Icons.person, size: context.rs(22), color: AppColors.purple),
            ),
            SizedBox(width: context.rs(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(patient.name,
                      style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(13),
                          fontWeight: FontWeight.w600, color: AppColors.black)),
                  SizedBox(height: context.rs(2)),
                  Text(patient.phone,
                      style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(11), color: AppColors.textGray)),
                  Text(patient.email,
                      style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(11), color: AppColors.textGray)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: context.rs(8), vertical: context.rs(3)),
                  decoration: BoxDecoration(
                    color: AppColors.purpleLight,
                    borderRadius: BorderRadius.circular(context.rs(20)),
                  ),
                  child: Text('${patient.totalVisits} ครั้ง',
                      style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(10), color: AppColors.purple)),
                ),
                SizedBox(height: context.rs(4)),
                Icon(Icons.chevron_right, size: context.rs(16), color: AppColors.textGray),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
