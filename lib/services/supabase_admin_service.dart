import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

// ============================================================
// SupabaseAdminService — ลงทะเบียนแอดมิน + คลินิก
// ============================================================
class SupabaseAdminService {
  SupabaseAdminService._();
  static final SupabaseAdminService instance = SupabaseAdminService._();

  final _db = Supabase.instance.client;

  // ---- สมัครแอดมินใหม่ -----------------------------------------------
  // 1. สร้าง user ใน Supabase Auth
  // 2. upsert ข้อมูลลง public.users (trigger handle_new_user ทำให้อัตโนมัติ)
  // 3. upsert คลินิก + ผูก admin_id
  // --------------------------------------------------------------------
  Future<Map<String, dynamic>> registerAdmin({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String clinicName,
    String? registrationNumber,
    String? operatingHours,
    String? address,
    String? province,
    String? district,
    String? zipCode,
    List<File>? licenseFiles,
    List<File>? logoFiles,
  }) async {
    // 1. สร้าง auth user
    final res = await _db.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'role': 'admin',
      },
    );

    if (res.user == null) {
      throw Exception('สมัครบัญชีแอดมินไม่สำเร็จ');
    }

    final uid = res.user!.id;

    // 2. อัปเดต public.users เพิ่ม phone
    await _db.from('users').upsert({
      'id': uid,
      'email': email,
      'full_name': fullName,
      'phone': phone,
    });

    // 3. อัปโหลดโลโก้คลินิก (ถ้ามี)
    String? logoUrl;
    if (logoFiles != null && logoFiles.isNotEmpty) {
      try {
        final logoFile = logoFiles.first;
        final ext = logoFile.path.split('.').last;
        final logoPath = 'clinic-images/${uid}_logo_${DateTime.now().millisecondsSinceEpoch}.$ext';
        await _db.storage
            .from('clinic-images')
            .uploadBinary(logoPath, await logoFile.readAsBytes(),
                fileOptions: FileOptions(upsert: true));
        logoUrl = _db.storage.from('clinic-images').getPublicUrl(logoPath);
      } catch (_) {
        // ไม่บล็อก registration ถ้าอัปโหลดรูปไม่สำเร็จ
      }
    }

    // 4. insert คลินิก
    final clinicRes = await _db
        .from('clinics')
        .insert({
          'admin_id': uid,
          'name': clinicName,
          'registration_number': registrationNumber,
          'operating_hours': operatingHours,
          'address': address,
          'province': province,
          'district': district,
          'zip_code': zipCode,
          'logo_url': logoUrl,
          'status': 'pending', // รอการอนุมัติ
        })
        .select()
        .single();

    return {
      'userId': uid,
      'clinicId': clinicRes['id'] as String,
    };
  }
}
