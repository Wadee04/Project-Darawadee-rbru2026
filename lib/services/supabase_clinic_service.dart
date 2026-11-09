import 'package:supabase_flutter/supabase_flutter.dart';
import '../mock/models.dart';

// ============================================================
// SupabaseClinicService — ดึงข้อมูลคลินิก, หมอ, บริการ, slot
// จาก Supabase จริง
// ============================================================
class SupabaseClinicService {
  SupabaseClinicService._();
  static final SupabaseClinicService instance = SupabaseClinicService._();

  final _db = Supabase.instance.client;

  // ---- Clinics -------------------------------------------

  Future<List<ClinicModel>> getClinics() async {
    final res = await _db
        .from('clinics')
        .select()
        .eq('is_active', true)
        .order('name');
    return (res as List).map((m) => ClinicModel.fromMap(m)).toList();
  }

  Future<ClinicModel?> getClinicById(String id) async {
    final res = await _db
        .from('clinics')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (res == null) return null;
    return ClinicModel.fromMap(res);
  }

  Future<List<ClinicModel>> searchClinics(String query) async {
    final res = await _db
        .from('clinics')
        .select()
        .eq('is_active', true)
        .or('name.ilike.%$query%,province.ilike.%$query%')
        .order('name');
    return (res as List).map((m) => ClinicModel.fromMap(m)).toList();
  }

  // ---- Doctors -------------------------------------------

  Future<List<DoctorModel>> getDoctorsByClinic(String clinicId) async {
    final res = await _db
        .from('doctors')
        .select()
        .eq('clinic_id', clinicId)
        .order('full_name');
    return (res as List).map((m) => DoctorModel.fromMap(m)).toList();
  }

  Future<List<DoctorModel>> getAvailableDoctors(String clinicId) async {
    final res = await _db
        .from('doctors')
        .select()
        .eq('clinic_id', clinicId)
        .eq('available', true)
        .order('full_name');
    return (res as List).map((m) => DoctorModel.fromMap(m)).toList();
  }

  Future<DoctorModel?> getDoctorById(String id) async {
    final res = await _db
        .from('doctors')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (res == null) return null;
    return DoctorModel.fromMap(res);
  }

  // ---- Services ------------------------------------------

  Future<List<ServiceModel>> getServicesByClinic(String clinicId) async {
    final res = await _db
        .from('services')
        .select()
        .eq('clinic_id', clinicId)
        .eq('is_active', true)
        .order('name');
    return (res as List).map((m) => ServiceModel.fromMap(m)).toList();
  }

  Future<ServiceModel?> getServiceById(String id) async {
    final res = await _db
        .from('services')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (res == null) return null;
    return ServiceModel.fromMap(res);
  }

  // ---- Available Slots -----------------------------------

  Future<List<SlotModel>> getAvailableSlots({
    required String doctorId,
    required DateTime date,
  }) async {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}'
        '-${date.day.toString().padLeft(2, '0')}';
    final res = await _db
        .from('available_slots')
        .select()
        .eq('doctor_id', doctorId)
        .eq('slot_date', dateStr)
        .eq('is_booked', false)
        .order('slot_time');
    return (res as List).map((m) => SlotModel.fromMap(m)).toList();
  }

  Future<List<DateTime>> getAvailableDates(String doctorId) async {
    final res = await _db
        .from('available_slots')
        .select('slot_date')
        .eq('doctor_id', doctorId)
        .eq('is_booked', false)
        .gte('slot_date', DateTime.now().toIso8601String().substring(0, 10))
        .order('slot_date');

    final dates = <DateTime>{};
    for (final row in res as List) {
      dates.add(DateTime.parse(row['slot_date'] as String));
    }
    return dates.toList()..sort();
  }
}
