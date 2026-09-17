import 'package:supabase_flutter/supabase_flutter.dart';
import '../mock/models.dart';

// ============================================================
// SupabaseUserService — Auth, โปรไฟล์, รหัสผ่าน, PIN, OTP
// ============================================================
class SupabaseUserService {
  SupabaseUserService._();
  static final SupabaseUserService instance = SupabaseUserService._();

  final _db = Supabase.instance.client;

  // ---- Auth ----------------------------------------------

  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    final res = await _db.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (res.user == null) return null;
    return getCurrentUser();
  }

  Future<UserModel?> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final res = await _db.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
    if (res.user == null) return null;
    // trigger handle_new_user จะ insert row ใน public.users อัตโนมัติ
    return UserModel(
      id: res.user!.id,
      fullName: fullName,
      email: email,
    );
  }

  Future<void> signOut() async {
    await _db.auth.signOut();
  }

  Future<bool> isLoggedIn() async {
    return _db.auth.currentUser != null;
  }

  // ---- Profile -------------------------------------------

  Future<UserModel> getCurrentUser() async {
    final uid = _db.auth.currentUser!.id;
    final res = await _db
        .from('users')
        .select()
        .eq('id', uid)
        .single();

    return UserModel(
      id: uid,
      fullName: res['full_name'] as String? ?? '',
      email: res['email'] as String? ?? '',
      phone: res['phone'] as String?,
      birthDate: res['birth_date'] != null
          ? DateTime.tryParse(res['birth_date'] as String)
          : null,
      gender: res['gender'] as String?,
      profileImageUrl: res['profile_image_url'] as String?,
      pinEnabled: (res['pin_enabled'] as bool?) ?? false,
    );
  }

  Future<UserModel> updateProfile({
    String? fullName,
    String? phone,
    DateTime? birthDate,
    String? gender,
    String? profileImageUrl,
  }) async {
    final uid = _db.auth.currentUser!.id;
    final data = <String, dynamic>{};
    if (fullName != null) data['full_name'] = fullName;
    if (phone != null) data['phone'] = phone;
    if (birthDate != null) {
      data['birth_date'] =
          '${birthDate.year}-${birthDate.month.toString().padLeft(2, '0')}'
          '-${birthDate.day.toString().padLeft(2, '0')}';
    }
    if (gender != null) data['gender'] = gender;
    if (profileImageUrl != null) data['profile_image_url'] = profileImageUrl;

    await _db.from('users').update(data).eq('id', uid);
    return getCurrentUser();
  }

  // ---- Security ------------------------------------------

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    // Supabase ไม่ต้องยืนยัน currentPassword ทาง client
    await _db.auth.updateUser(UserAttributes(password: newPassword));
    return true;
  }

  Future<bool> changeEmail(String newEmail) async {
    await _db.auth.updateUser(UserAttributes(email: newEmail));
    // อัปเดตใน public.users ด้วย
    await _db
        .from('users')
        .update({'email': newEmail})
        .eq('id', _db.auth.currentUser!.id);
    return true;
  }

  Future<bool> togglePin({required bool enabled, String? pinHash}) async {
    final uid = _db.auth.currentUser!.id;
    final data = <String, dynamic>{'pin_enabled': enabled};
    if (pinHash != null) data['pin_hash'] = pinHash;
    await _db.from('users').update(data).eq('id', uid);
    return true;
  }

  Future<bool> verifyPin(String pin) async {
    // ในโปรเจกต์จริงควรเข้ารหัสก่อนเปรียบเทียบ
    final uid = _db.auth.currentUser!.id;
    final res = await _db
        .from('users')
        .select('pin_hash')
        .eq('id', uid)
        .single();
    return res['pin_hash'] == pin;
  }

  // ---- OTP (Email) ---------------------------------------

  Future<bool> sendOtp(String email) async {
    await _db.auth.signInWithOtp(email: email);
    return true;
  }

  Future<bool> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final res = await _db.auth.verifyOTP(
      type: OtpType.email,
      email: email,
      token: otp,
    );
    return res.user != null;
  }
}
