import 'models.dart';
import 'mock_data_store.dart';

// ============================================================
// MockBookingService — จำลองการจอง, ดูคิว, ยกเลิก, ชำระมัดจำ
// ============================================================
class MockBookingService {
  MockBookingService._();
  static final MockBookingService instance = MockBookingService._();

  final _store = MockDataStore.instance;
  int _codeCounter = 6;

  // ---- Read ----------------------------------------------

  /// ดึงการจองทั้งหมดของ user
  Future<List<BookingModel>> getMyBookings() async {
    await _delay();
    return List.unmodifiable(_store.bookings);
  }

  /// ดึงการจองแยกตามสถานะ
  Future<List<BookingModel>> getBookingsByStatus(BookingStatus status) async {
    await _delay();
    return _store.bookings.where((b) => b.status == status).toList();
  }

  /// ดึงการจองที่กำลังจะมาถึง (confirmed + waitingPayment)
  Future<List<BookingModel>> getUpcomingBookings() async {
    await _delay();
    return _store.bookings
        .where((b) =>
            b.status == BookingStatus.confirmed ||
            b.status == BookingStatus.waitingPayment)
        .toList()
      ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
  }

  /// ดึงประวัติการรักษา (completed + cancelled)
  Future<List<BookingModel>> getBookingHistory() async {
    await _delay();
    return _store.bookings
        .where((b) =>
            b.status == BookingStatus.completed ||
            b.status == BookingStatus.cancelled)
        .toList()
      ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
  }

  /// ดึงการจองตาม id
  Future<BookingModel?> getBookingById(String id) async {
    await _delay();
    try {
      return _store.bookings.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  // ---- Create --------------------------------------------

  /// สร้างการจองใหม่
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
    await _delay();

    // mark slot เป็น booked
    final slotIndex = _store.slots.indexWhere((s) => s.id == slotId);
    if (slotIndex != -1) {
      final old = _store.slots[slotIndex];
      _store.slots[slotIndex] = SlotModel(
        id: old.id,
        doctorId: old.doctorId,
        clinicId: old.clinicId,
        slotDate: old.slotDate,
        slotTime: old.slotTime,
        isBooked: true,
      );
    }

    final now = DateTime.now();
    final code =
        'BK${now.year.toString().substring(2)}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-'
        '${_codeCounter.toString().padLeft(4, '0')}';
    _codeCounter++;

    final booking = BookingModel(
      id: 'bk-${_store.bookings.length + 1}',
      bookingCode: code,
      userId: _store.currentUser.id,
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

    _store.bookings.add(booking);
    return booking;
  }

  // ---- Update --------------------------------------------

  /// ยกเลิกการจอง
  Future<bool> cancelBooking(String bookingId) async {
    await _delay();
    final index = _store.bookings.indexWhere((b) => b.id == bookingId);
    if (index == -1) { return false; }

    final old = _store.bookings[index];
    if (old.status == BookingStatus.completed ||
        old.status == BookingStatus.cancelled) { return false; }

    _store.bookings[index] = BookingModel(
      id: old.id,
      bookingCode: old.bookingCode,
      userId: old.userId,
      clinicId: old.clinicId,
      clinicName: old.clinicName,
      clinicAddress: old.clinicAddress,
      doctorId: old.doctorId,
      doctorName: old.doctorName,
      serviceId: old.serviceId,
      serviceName: old.serviceName,
      serviceNameEn: old.serviceNameEn,
      appointmentDate: old.appointmentDate,
      appointmentTime: old.appointmentTime,
      status: BookingStatus.cancelled,
      depositAmount: old.depositAmount,
      depositPaid: old.depositPaid,
      note: old.note,
    );
    return true;
  }

  /// ยืนยันชำระมัดจำ (พร้อม slip url)
  Future<bool> confirmDeposit({
    required String bookingId,
    required String slipUrl,
  }) async {
    await _delay();
    final index = _store.bookings.indexWhere((b) => b.id == bookingId);
    if (index == -1) { return false; }

    final old = _store.bookings[index];
    _store.bookings[index] = BookingModel(
      id: old.id,
      bookingCode: old.bookingCode,
      userId: old.userId,
      clinicId: old.clinicId,
      clinicName: old.clinicName,
      clinicAddress: old.clinicAddress,
      doctorId: old.doctorId,
      doctorName: old.doctorName,
      serviceId: old.serviceId,
      serviceName: old.serviceName,
      serviceNameEn: old.serviceNameEn,
      appointmentDate: old.appointmentDate,
      appointmentTime: old.appointmentTime,
      status: BookingStatus.confirmed,
      depositAmount: old.depositAmount,
      depositPaid: true,
      slipUrl: slipUrl,
      note: old.note,
    );
    return true;
  }

  // ---- Stats ---------------------------------------------

  /// จำนวนการนัดหมายแยกตามสถานะ
  Future<Map<BookingStatus, int>> getBookingStats() async {
    await _delay();
    final map = <BookingStatus, int>{};
    for (final status in BookingStatus.values) {
      map[status] = _store.bookings.where((b) => b.status == status).length;
    }
    return map;
  }
}

Future<void> _delay() => Future.delayed(const Duration(milliseconds: 300));
