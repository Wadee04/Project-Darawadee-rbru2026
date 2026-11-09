import 'package:supabase_flutter/supabase_flutter.dart';
import 'admin_models.dart';
import 'admin_mock_service.dart';

// ============================================================
// AdminClinicService — จัดการข้อมูลคลินิก, หมอ, บริการ ฝั่ง Admin
// เปลี่ยน useMock → false เพื่อใช้ Supabase จริง
// ============================================================

const bool _useMock = false;

class AdminClinicService {
  AdminClinicService._();
  static final AdminClinicService instance = AdminClinicService._();

  final _db = Supabase.instance.client;
  final _mock = AdminMockService.instance;

  // ---- Admin user ----------------------------------------

  Future<AdminUser> getAdminUser() async {
    if (_useMock) {
      await _delay();
      return _mock.currentAdmin;
    }
    final uid = _db.auth.currentUser!.id;
    final res = await _db
        .from('users')
        .select('*, clinics(name, status)')
        .eq('id', uid)
        .single();
    final clinic = res['clinics'] as Map<String, dynamic>?;
    return AdminUser(
      id: uid,
      fullName: res['full_name'] as String? ?? '',
      email: res['email'] as String? ?? '',
      clinicId: res['clinic_id'] as String? ?? '',
      clinicName: clinic?['name'] as String? ?? '',
      clinicStatus: AdminClinicStatusExt.fromString(
          clinic?['status'] as String? ?? 'pending'),
      phone: res['phone'] as String?,
    );
  }

  // ---- Clinic Stats --------------------------------------

  Future<DashboardStats> getDashboardStats() async {
    if (_useMock) {
      await _delay();
      return _mock.stats;
    }
    // ดึง clinicId จริงจาก Supabase ตาม user ที่ login อยู่
    final uid = _db.auth.currentUser!.id;
    final userRow = await _db
        .from('users')
        .select('clinic_id')
        .eq('id', uid)
        .maybeSingle();
    final clinicId = userRow?['clinic_id'] as String? ?? '';
    if (clinicId.isEmpty) {
      return const DashboardStats(totalToday: 0, waiting: 0, inProgress: 0, completed: 0);
    }
    final today = DateTime.now();
    final dateStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final res = await _db
        .from('bookings')
        .select('status')
        .eq('clinic_id', clinicId)
        .eq('appointment_date', dateStr)
        .neq('status', 'cancelled');

    int waiting = 0, inProgress = 0, completed = 0;
    for (final row in res as List) {
      switch (row['status'] as String) {
        case 'waiting_payment':
        case 'confirmed':
          waiting++;
          break;
        case 'in_progress':
          inProgress++;
          break;
        case 'completed':
          completed++;
          break;
      }
    }
    return DashboardStats(
      totalToday: res.length,
      waiting: waiting,
      inProgress: inProgress,
      completed: completed,
    );
  }

  // ---- Patients ------------------------------------------

  Future<List<AdminPatient>> getPatients({String? search}) async {
    if (_useMock) {
      await _delay();
      if (search == null || search.isEmpty) return _mock.patients;
      return _mock.patients
          .where((p) =>
              p.fullName.contains(search) ||
              p.phone.contains(search) ||
              p.email.contains(search))
          .toList();
    }
    var query = _db
        .from('users')
        .select()
        .order('full_name');
    if (search != null && search.isNotEmpty) {
      query = _db
          .from('users')
          .select()
          .or('full_name.ilike.%$search%,phone.ilike.%$search%,email.ilike.%$search%')
          .order('full_name');
    }
    final res = await query;
    return (res as List)
        .map((m) => AdminPatient.fromMap(m))
        .toList();
  }
}

// ============================================================

Future<void> _delay() => Future.delayed(const Duration(milliseconds: 300));
