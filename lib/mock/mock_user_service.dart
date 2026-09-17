import 'models.dart';
import 'mock_data_store.dart';

// ============================================================
// MockUserService — จำลอง Auth, ข้อมูลโปรไฟล์, รหัสผ่าน, PIN
// ============================================================
class MockUserService {
  MockUserService._();
  static final MockUserService instance = MockUserService._();

  final _store = MockDataStore.instance;
  bool _isLoggedIn = true;

  // ---- Auth ----------------------------------------------

  /// เข้าสู่ระบบ
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    await _delay();
    // Mock: รับทุก email/password ที่มีความยาว >= 6
    if (password.length < 6) return null;
    _isLoggedIn = true;
    return _store.currentUser;
  }

  /// สมัครสมาชิก
  Future<UserModel?> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await _delay();
    if (password.length < 6) return null;
    _store.currentUser = UserModel(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      email: email,
    );
    _isLoggedIn = true;
    return _store.currentUser;
  }

  /// ออกจากระบบ
  Future<void> signOut() async {
    await _delay();
    _isLoggedIn = false;
  }

  /// ตรวจสอบว่า login อยู่ไหม
  Future<bool> isLoggedIn() async {
    await _delay();
    return _isLoggedIn;
  }

  // ---- Profile -------------------------------------------

  /// ดึงข้อมูล user ปัจจุบัน
  Future<UserModel> getCurrentUser() async {
    await _delay();
    return _store.currentUser;
  }

  /// อัปเดตข้อมูลส่วนตัว
  Future<UserModel> updateProfile({
    String? fullName,
    String? phone,
    DateTime? birthDate,
    String? gender,
    String? profileImageUrl,
  }) async {
    await _delay();
    _store.currentUser = _store.currentUser.copyWith(
      fullName: fullName,
      phone: phone,
      birthDate: birthDate,
      gender: gender,
      profileImageUrl: profileImageUrl,
    );
    return _store.currentUser;
  }

  // ---- Security ------------------------------------------

  /// เปลี่ยนรหัสผ่าน — Mock: สำเร็จเสมอ
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _delay();
    return newPassword.length >= 6;
  }

  /// เปลี่ยนอีเมล — Mock: สำเร็จเสมอ
  Future<bool> changeEmail(String newEmail) async {
    await _delay();
    _store.currentUser = UserModel(
      id: _store.currentUser.id,
      fullName: _store.currentUser.fullName,
      email: newEmail,
      phone: _store.currentUser.phone,
      birthDate: _store.currentUser.birthDate,
      gender: _store.currentUser.gender,
      profileImageUrl: _store.currentUser.profileImageUrl,
      pinEnabled: _store.currentUser.pinEnabled,
    );
    return true;
  }

  /// เปิด/ปิด PIN
  Future<bool> togglePin({required bool enabled, String? pinHash}) async {
    await _delay();
    _store.currentUser = _store.currentUser.copyWith(pinEnabled: enabled);
    return true;
  }

  /// ยืนยัน PIN — Mock: pin ที่ถูกต้องคือ "123456"
  Future<bool> verifyPin(String pin) async {
    await _delay();
    return pin == '123456';
  }

  // ---- OTP -----------------------------------------------

  /// ส่ง OTP — Mock: สำเร็จเสมอ
  Future<bool> sendOtp(String email) async {
    await _delay();
    return true;
  }

  /// ยืนยัน OTP — Mock: OTP ที่ถูกต้องคือ "123456"
  Future<bool> verifyOtp({required String email, required String otp}) async {
    await _delay();
    return otp == '123456';
  }
}

Future<void> _delay() => Future.delayed(const Duration(milliseconds: 300));
