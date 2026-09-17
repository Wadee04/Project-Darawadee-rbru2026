import 'models.dart';
import 'mock_data_store.dart';

// ============================================================
// MockClinicService — จำลองการดึงข้อมูลคลินิก, หมอ, บริการ, slot
// ============================================================
class MockClinicService {
  MockClinicService._();
  static final MockClinicService instance = MockClinicService._();

  final _store = MockDataStore.instance;

  // ---- Clinics -------------------------------------------

  /// ดึงคลินิกทั้งหมด
  Future<List<ClinicModel>> getClinics() async {
    await _delay();
    return _store.clinics.where((c) => c.isActive).toList();
  }

  /// ดึงคลินิกตาม id
  Future<ClinicModel?> getClinicById(String id) async {
    await _delay();
    try {
      return _store.clinics.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// ค้นหาคลินิกตามชื่อ
  Future<List<ClinicModel>> searchClinics(String query) async {
    await _delay();
    final q = query.toLowerCase();
    return _store.clinics
        .where((c) =>
            c.isActive &&
            (c.name.toLowerCase().contains(q) ||
                (c.province?.toLowerCase().contains(q) ?? false)))
        .toList();
  }

  // ---- Doctors -------------------------------------------

  /// ดึงหมอทั้งหมดของคลินิก
  Future<List<DoctorModel>> getDoctorsByClinic(String clinicId) async {
    await _delay();
    return _store.doctors
        .where((d) => d.clinicId == clinicId)
        .toList();
  }

  /// ดึงหมอที่ available ของคลินิก
  Future<List<DoctorModel>> getAvailableDoctors(String clinicId) async {
    await _delay();
    return _store.doctors
        .where((d) => d.clinicId == clinicId && d.available)
        .toList();
  }

  /// ดึงหมอตาม id
  Future<DoctorModel?> getDoctorById(String id) async {
    await _delay();
    try {
      return _store.doctors.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  // ---- Services ------------------------------------------

  /// ดึงบริการทั้งหมดของคลินิก
  Future<List<ServiceModel>> getServicesByClinic(String clinicId) async {
    await _delay();
    return _store.services
        .where((s) => s.clinicId == clinicId && s.isActive)
        .toList();
  }

  /// ดึงบริการตาม id
  Future<ServiceModel?> getServiceById(String id) async {
    await _delay();
    try {
      return _store.services.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  // ---- Available Slots ------------------------------------

  /// ดึง slot ที่ว่างของหมอในวันที่กำหนด
  Future<List<SlotModel>> getAvailableSlots({
    required String doctorId,
    required DateTime date,
  }) async {
    await _delay();
    return _store.slots
        .where((s) =>
            s.doctorId == doctorId &&
            s.slotDate.year == date.year &&
            s.slotDate.month == date.month &&
            s.slotDate.day == date.day &&
            !s.isBooked)
        .toList();
  }

  /// ดึงวันที่ยังมี slot ว่างของหมอ (30 วันข้างหน้า)
  Future<List<DateTime>> getAvailableDates(String doctorId) async {
    await _delay();
    final dates = <DateTime>{};
    for (final s in _store.slots) {
      if (s.doctorId == doctorId && !s.isBooked) {
        dates.add(DateTime(s.slotDate.year, s.slotDate.month, s.slotDate.day));
      }
    }
    final sorted = dates.toList()..sort();
    return sorted;
  }
}

Future<void> _delay() => Future.delayed(const Duration(milliseconds: 300));
