import 'package:supabase_flutter/supabase_flutter.dart';

import '../../mock/models.dart';

class AdminRoom {
  const AdminRoom({
    required this.id,
    required this.clinicId,
    required this.name,
    required this.specialty,
    required this.isActive,
    required this.displayOrder,
  });

  final String id;
  final String clinicId;
  final String name;
  final String specialty;
  final bool isActive;
  final int displayOrder;

  factory AdminRoom.fromMap(Map<String, dynamic> map) => AdminRoom(
        id: map['id'] as String,
        clinicId: map['clinic_id'] as String,
        name: map['name'] as String? ?? '',
        specialty: map['specialty'] as String? ?? '',
        isActive: map['is_active'] as bool? ?? true,
        displayOrder: map['display_order'] as int? ?? 0,
      );
}

/// จัดการทันตแพทย์และห้องตรวจของคลินิกที่ admin ปัจจุบันเป็นเจ้าของ
class DentistRoomService {
  DentistRoomService._();
  static final DentistRoomService instance = DentistRoomService._();

  final SupabaseClient _db = Supabase.instance.client;

  Future<String> requireCurrentClinicId() async {
    final userId = _db.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('กรุณาเข้าสู่ระบบด้วยบัญชีแอดมิน');
    }

    // ความสัมพันธ์หลักสำหรับ schema ใหม่
    try {
      final clinic = await _db
          .from('clinics')
          .select('id')
          .eq('admin_id', userId)
          .maybeSingle();
      final clinicId = clinic?['id'] as String?;
      if (clinicId != null && clinicId.isNotEmpty) return clinicId;
    } on PostgrestException {
      // รองรับฐานข้อมูลเก่าที่ยังไม่มี clinics.admin_id
    }

    // fallback สำหรับฐานข้อมูลเก่าที่ใช้ users.clinic_id
    try {
      final user = await _db
          .from('users')
          .select('clinic_id')
          .eq('id', userId)
          .maybeSingle();
      final clinicId = user?['clinic_id'] as String?;
      if (clinicId != null && clinicId.isNotEmpty) return clinicId;
    } on PostgrestException {
      // แสดงข้อความเดียวด้านล่างแทนรายละเอียดโครงสร้างฐานข้อมูล
    }

    throw StateError('ยังไม่ได้เชื่อมบัญชีแอดมินกับคลินิก');
  }

  Future<List<DoctorModel>> getDoctors() async {
    final clinicId = await requireCurrentClinicId();
    final response = await _db
        .from('doctors')
        .select()
        .eq('clinic_id', clinicId)
        .order('created_at');
    return (response as List)
        .map((row) => DoctorModel.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<List<AdminRoom>> getRooms() async {
    final clinicId = await requireCurrentClinicId();
    final response = await _db
        .from('rooms')
        .select()
        .eq('clinic_id', clinicId)
        .order('display_order')
        .order('created_at');
    return (response as List)
        .map((row) => AdminRoom.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<DoctorModel> addDoctor({
    required String fullName,
    required String specialty,
  }) async {
    final clinicId = await requireCurrentClinicId();
    final row = await _db
        .from('doctors')
        .insert({
          'clinic_id': clinicId,
          'full_name': fullName.trim(),
          'specialty': specialty.trim(),
          'available': true,
        })
        .select()
        .single();
    return DoctorModel.fromMap(row);
  }

  Future<DoctorModel> updateDoctor({
    required String doctorId,
    required String fullName,
    required String specialty,
  }) async {
    final clinicId = await requireCurrentClinicId();
    final row = await _db
        .from('doctors')
        .update({
          'full_name': fullName.trim(),
          'specialty': specialty.trim(),
        })
        .eq('id', doctorId)
        .eq('clinic_id', clinicId)
        .select()
        .single();
    return DoctorModel.fromMap(row);
  }

  Future<DoctorModel> setDoctorAvailable({
    required String doctorId,
    required bool available,
  }) async {
    final clinicId = await requireCurrentClinicId();
    final row = await _db
        .from('doctors')
        .update({'available': available})
        .eq('id', doctorId)
        .eq('clinic_id', clinicId)
        .select()
        .single();
    return DoctorModel.fromMap(row);
  }

  Future<AdminRoom> addRoom({
    required String name,
    required String specialty,
  }) async {
    final clinicId = await requireCurrentClinicId();
    final count = await _db
        .from('rooms')
        .select('id')
        .eq('clinic_id', clinicId);
    final row = await _db
        .from('rooms')
        .insert({
          'clinic_id': clinicId,
          'name': name.trim(),
          'specialty': specialty.trim(),
          'is_active': true,
          'display_order': (count as List).length,
        })
        .select()
        .single();
    return AdminRoom.fromMap(row);
  }

  Future<AdminRoom> updateRoom({
    required String roomId,
    required String name,
    required String specialty,
  }) async {
    final clinicId = await requireCurrentClinicId();
    final row = await _db
        .from('rooms')
        .update({
          'name': name.trim(),
          'specialty': specialty.trim(),
        })
        .eq('id', roomId)
        .eq('clinic_id', clinicId)
        .select()
        .single();
    return AdminRoom.fromMap(row);
  }

  Future<AdminRoom> setRoomActive({
    required String roomId,
    required bool isActive,
  }) async {
    final clinicId = await requireCurrentClinicId();
    final row = await _db
        .from('rooms')
        .update({'is_active': isActive})
        .eq('id', roomId)
        .eq('clinic_id', clinicId)
        .select()
        .single();
    return AdminRoom.fromMap(row);
  }
}
