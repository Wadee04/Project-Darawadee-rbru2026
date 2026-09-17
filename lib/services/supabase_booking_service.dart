import 'package:supabase_flutter/supabase_flutter.dart';
import '../mock/models.dart';

// ============================================================
// SupabaseBookingService — จอง, ยกเลิก, ชำระมัดจำ, ดูคิว
// ============================================================
class SupabaseBookingService {
  SupabaseBookingService._();
  static final SupabaseBookingService instance = SupabaseBookingService._();

  final _db = Supabase.instance.client;

  String get _userId => _db.auth.currentUser!.id;

  // ---- Read ----------------------------------------------

  Future<List<BookingModel>> getMyBookings() async {
    final res = await _db
        .from('bookings')
        .select('''
          *,
          clinics ( name, address ),
          doctors ( full_name ),
          services ( name, name_en )
        ''')
        .eq('user_id', _userId)
        .order('created_at', ascending: false);
    return (res as List).map((m) => _fromJoin(m)).toList();
  }

  Future<List<BookingModel>> getBookingsByStatus(BookingStatus status) async {
    final res = await _db
        .from('bookings')
        .select('''
          *,
          clinics ( name, address ),
          doctors ( full_name ),
          services ( name, name_en )
        ''')
        .eq('user_id', _userId)
        .eq('status', status.value)
        .order('appointment_date');
    return (res as List).map((m) => _fromJoin(m)).toList();
  }

  Future<List<BookingModel>> getUpcomingBookings() async {
    final res = await _db
        .from('bookings')
        .select('''
          *,
          clinics ( name, address ),
          doctors ( full_name ),
          services ( name, name_en )
        ''')
        .eq('user_id', _userId)
        .inFilter('status', ['confirmed', 'waiting_payment'])
        .order('appointment_date');
    return (res as List).map((m) => _fromJoin(m)).toList();
  }

  Future<List<BookingModel>> getBookingHistory() async {
    final res = await _db
        .from('bookings')
        .select('''
          *,
          clinics ( name, address ),
          doctors ( full_name ),
          services ( name, name_en )
        ''')
        .eq('user_id', _userId)
        .inFilter('status', ['completed', 'cancelled'])
        .order('appointment_date', ascending: false);
    return (res as List).map((m) => _fromJoin(m)).toList();
  }

  Future<BookingModel?> getBookingById(String id) async {
    final res = await _db
        .from('bookings')
        .select('''
          *,
          clinics ( name, address ),
          doctors ( full_name ),
          services ( name, name_en )
        ''')
        .eq('id', id)
        .eq('user_id', _userId)
        .maybeSingle();
    if (res == null) return null;
    return _fromJoin(res);
  }

  // ---- Create --------------------------------------------

  Future<BookingModel> createBooking({
    required String clinicId,
    required String clinicName,
    required String clinicAddress,
    required String doctorId,
    required String doctorName,
    required String serviceId,
    required String serviceName,
    required String serviceNameEn,
    required String slotId,
    required DateTime appointmentDate,
    required String appointmentTime,
    required double depositAmount,
    String? note,
  }) async {
    final dateStr =
        '${appointmentDate.year}-${appointmentDate.month.toString().padLeft(2, '0')}'
        '-${appointmentDate.day.toString().padLeft(2, '0')}';

    final res = await _db
        .from('bookings')
        .insert({
          'user_id': _userId,
          'clinic_id': clinicId,
          'doctor_id': doctorId,
          'service_id': serviceId,
          'slot_id': slotId,
          'appointment_date': dateStr,
          'appointment_time': appointmentTime,
          'status': depositAmount > 0 ? 'waiting_payment' : 'confirmed',
          'deposit_amount': depositAmount,
          'deposit_paid': false,
          'note': note,
        })
        .select()
        .single();

    return BookingModel(
      id: res['id'] as String,
      bookingCode: res['booking_code'] as String,
      userId: _userId,
      clinicId: clinicId,
      clinicName: clinicName,
      clinicAddress: clinicAddress,
      doctorId: doctorId,
      doctorName: doctorName,
      serviceId: serviceId,
      serviceName: serviceName,
      serviceNameEn: serviceNameEn,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      status: depositAmount > 0
          ? BookingStatus.waitingPayment
          : BookingStatus.confirmed,
      depositAmount: depositAmount,
      depositPaid: false,
      note: note,
    );
  }

  // ---- Update --------------------------------------------

  Future<bool> cancelBooking(String bookingId) async {
    await _db
        .from('bookings')
        .update({'status': 'cancelled'})
        .eq('id', bookingId)
        .eq('user_id', _userId);
    return true;
  }

  Future<bool> confirmDeposit({
    required String bookingId,
    required String slipUrl,
  }) async {
    await _db
        .from('bookings')
        .update({
          'status': 'confirmed',
          'deposit_paid': true,
          'slip_url': slipUrl,
        })
        .eq('id', bookingId)
        .eq('user_id', _userId);
    return true;
  }

  // ---- Stats ---------------------------------------------

  Future<Map<BookingStatus, int>> getBookingStats() async {
    final res = await _db
        .from('bookings')
        .select('status')
        .eq('user_id', _userId);

    final map = <BookingStatus, int>{for (final s in BookingStatus.values) s: 0};
    for (final row in res as List) {
      final status = BookingStatus.fromString(row['status'] as String);
      map[status] = (map[status] ?? 0) + 1;
    }
    return map;
  }

  // ---- Helper --------------------------------------------

  BookingModel _fromJoin(Map<String, dynamic> m) {
    final clinic = m['clinics'] as Map<String, dynamic>?;
    final doctor = m['doctors'] as Map<String, dynamic>?;
    final service = m['services'] as Map<String, dynamic>?;

    return BookingModel(
      id: m['id'] as String,
      bookingCode: m['booking_code'] as String,
      userId: m['user_id'] as String,
      clinicId: m['clinic_id'] as String,
      clinicName: clinic?['name'] as String? ?? '',
      clinicAddress: clinic?['address'] as String?,
      doctorId: m['doctor_id'] as String,
      doctorName: doctor?['full_name'] as String? ?? '',
      serviceId: m['service_id'] as String,
      serviceName: service?['name'] as String? ?? '',
      serviceNameEn: service?['name_en'] as String? ?? '',
      appointmentDate: DateTime.parse(m['appointment_date'] as String),
      appointmentTime: m['appointment_time'] as String,
      status: BookingStatus.fromString(m['status'] as String),
      depositAmount: (m['deposit_amount'] as num?)?.toDouble() ?? 0,
      depositPaid: (m['deposit_paid'] as bool?) ?? false,
      slipUrl: m['slip_url'] as String?,
      note: m['note'] as String?,
    );
  }
}
