// ============================================================
// service_locator.dart — switch Mock ↔ Supabase ในที่เดียว
//
// วิธีใช้:
//   1. useMock = true  → ใช้ Mock (ระหว่าง dev / ไม่มี internet)
//   2. useMock = false → ใช้ Supabase จริง (production)
//
// ในหน้า Flutter import แค่ไฟล์นี้:
//   import 'package:wadee/services/service_locator.dart';
//
//   final clinics = await ServiceLocator.clinic.getClinics();
// ============================================================

import '../mock/mock_clinic_service.dart';
import '../mock/mock_booking_service.dart';
import '../mock/mock_user_service.dart';
import '../mock/mock_notification_service.dart';
import '../mock/mock_review_service.dart';

import 'supabase_clinic_service.dart';
import 'supabase_booking_service.dart';
import 'supabase_user_service.dart';
import 'supabase_notification_service.dart';
import 'supabase_review_service.dart';

// re-export models และ NotificationSettings ให้ใช้ผ่าน locator ได้เลย
export '../mock/models.dart';
export '../mock/mock_notification_service.dart' show NotificationSettings;

// ============================================================
// *** เปลี่ยนบรรทัดนี้เพื่อ switch Mock ↔ Supabase ***
// ============================================================
const bool useMock = false; // false = Supabase จริง
// ============================================================

class ServiceLocator {
  ServiceLocator._();

  // ---- Clinic --------------------------------------------
  static MockClinicService get _mockClinic => MockClinicService.instance;
  static SupabaseClinicService get _realClinic => SupabaseClinicService.instance;

  static dynamic get clinic => useMock ? _mockClinic : _realClinic;

  // ---- Booking -------------------------------------------
  static MockBookingService get _mockBooking => MockBookingService.instance;
  static SupabaseBookingService get _realBooking => SupabaseBookingService.instance;

  static dynamic get booking => useMock ? _mockBooking : _realBooking;

  // ---- User ----------------------------------------------
  static MockUserService get _mockUser => MockUserService.instance;
  static SupabaseUserService get _realUser => SupabaseUserService.instance;

  static dynamic get user => useMock ? _mockUser : _realUser;

  // ---- Notification --------------------------------------
  static MockNotificationService get _mockNotif => MockNotificationService.instance;
  static SupabaseNotificationService get _realNotif => SupabaseNotificationService.instance;

  static dynamic get notification => useMock ? _mockNotif : _realNotif;

  // ---- Review --------------------------------------------
  static MockReviewService get _mockReview => MockReviewService.instance;
  static SupabaseReviewService get _realReview => SupabaseReviewService.instance;

  static dynamic get review => useMock ? _mockReview : _realReview;
}
