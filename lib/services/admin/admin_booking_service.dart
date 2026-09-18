import 'package:supabase_flutter/supabase_flutter.dart';
import 'admin_models.dart';
import 'admin_mock_service.dart';

const bool _useMock = false;

// ============================================================
// AdminBookingService — จัดการคิว, approve slip ฝั่ง Admin
// ============================================================
class AdminBookingService {
  AdminBookingService._();
  static final AdminBookingService instance = AdminBookingService._();

  final _db = Supabase.instance.client;
  final _mock = AdminMockService.instance;

  // ---- Read ----------------------------------------------

  Future<List<AdminBooking>> getTodayBookings() async {
    if (_useMock) {
      await _delay();
      final today = DateTime.now();
      return _mock.bookings
          .where((b) =>
              b.appointmentDate.year == today.year &&
              b.appointmentDate.month == today.month &&
              b.appointmentDate.day == today.day)
          .toList();
    }
    final clinicId = await _getClinicId();
    if (clinicId.isEmpty) return [];
    final res = await _db
        .from('bookings')
        .select('''
          *,
          users ( full_name, phone ),
          doctors ( full_name ),
          services ( name )
        ''')
        .eq('clinic_id', clinicId)
        .eq('appointment_date', _todayStr())
        .order('appointment_time');
    return (res as List).map((m) => AdminBooking.fromMap(m)).toList();
  }

  Future<List<AdminBooking>> getAllBookings({DateTime? date}) async {
    if (_useMock) {
      await _delay();
      if (date == null) return _mock.bookings;
      return _mock.bookings
          .where((b) =>
              b.appointmentDate.year == date.year &&
              b.appointmentDate.month == date.month &&
              b.appointmentDate.day == date.day)
          .toList();
    }
    final clinicId = await _getClinicId();
    if (clinicId.isEmpty) return [];
    final res = await _db
        .from('bookings')
        .select('''
          *,
          users ( full_name, phone ),
          doctors ( full_name ),
          services ( name )
        ''')
        .eq('clinic_id', clinicId)
        .order('appointment_date', ascending: false);
    return (res as List).map((m) => AdminBooking.fromMap(m)).toList();
  }

  // ---- Update status ------------------------------------

  Future<bool> updateBookingStatus(
      String bookingId, AdminQueueStatus status) async {
    if (_useMock) {
      await _delay();
      final idx = _mock.bookings.indexWhere((b) => b.id == bookingId);
      if (idx == -1) { return false; }
      final old = _mock.bookings[idx];
      _mock.bookings[idx] = AdminBooking(
        id: old.id, bookingCode: old.bookingCode,
        userId: old.userId, patientName: old.patientName,
        patientPhone: old.patientPhone, clinicId: old.clinicId,
        doctorId: old.doctorId, doctorName: old.doctorName,
        serviceId: old.serviceId, serviceName: old.serviceName,
        appointmentDate: old.appointmentDate,
        appointmentTime: old.appointmentTime,
        status: status,
        depositAmount: old.depositAmount, depositPaid: old.depositPaid,
        slipUrl: old.slipUrl, roomNumber: old.roomNumber,
        queueNumber: old.queueNumber,
      );
      return true;
    }
    await _db
        .from('bookings')
        .update({'status': status.value})
        .eq('id', bookingId);
    return true;
  }

  Future<bool> callQueue(String id) =>
      updateBookingStatus(id, AdminQueueStatus.inProgress);

  Future<bool> completeQueue(String id) =>
      updateBookingStatus(id, AdminQueueStatus.completed);

  Future<bool> cancelQueue(String id) =>
      updateBookingStatus(id, AdminQueueStatus.cancelled);

  // ---- Approve deposit slip -----------------------------

  Future<bool> approveSlip(String bookingId) async {
    if (_useMock) {
      await _delay();
      final idx = _mock.bookings.indexWhere((b) => b.id == bookingId);
      if (idx == -1) { return false; }
      final old = _mock.bookings[idx];
      _mock.bookings[idx] = AdminBooking(
        id: old.id, bookingCode: old.bookingCode,
        userId: old.userId, patientName: old.patientName,
        patientPhone: old.patientPhone, clinicId: old.clinicId,
        doctorId: old.doctorId, doctorName: old.doctorName,
        serviceId: old.serviceId, serviceName: old.serviceName,
        appointmentDate: old.appointmentDate,
        appointmentTime: old.appointmentTime,
        status: AdminQueueStatus.confirmed,
        depositAmount: old.depositAmount, depositPaid: true,
        slipUrl: old.slipUrl, roomNumber: old.roomNumber,
        queueNumber: old.queueNumber,
      );
      return true;
    }
    await _db
        .from('bookings')
        .update({'deposit_paid': true, 'status': 'confirmed'})
        .eq('id', bookingId);
    return true;
  }

  // ---- Realtime -----------------------------------------

  dynamic subscribeToTodayQueue(void Function() onChanged) {
    if (_useMock) { return null; }
    final clinicId = _mock.currentAdmin.clinicId;
    return _db
        .channel('bookings:$clinicId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'bookings',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'clinic_id',
            value: clinicId,
          ),
          callback: (_) => onChanged(),
        )
        .subscribe();
  }

  String _todayStr() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}'
        '-${now.day.toString().padLeft(2, '0')}';
  }
}

Future<void> _delay() => Future.delayed(const Duration(milliseconds: 300));
