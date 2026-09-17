import 'admin_models.dart';

// ============================================================
// AdminMockService — ข้อมูลจำลองสำหรับฝั่ง Admin
// ============================================================
class AdminMockService {
  AdminMockService._();
  static final AdminMockService instance = AdminMockService._();

  // ---- Admin user ----------------------------------------
  AdminUser currentAdmin = const AdminUser(
    id: 'admin-001',
    fullName: 'ดาราวดี อาลัย',
    email: 'admin@dental.com',
    clinicId: 'clinic-003',
    clinicName: 'คลินิกทันตกรรมใจ๋',
    clinicStatus: AdminClinicStatus.approved,
    phone: '039-200-789',
  );

  // ---- Bookings / Queues ---------------------------------
  List<AdminBooking> bookings = [
    AdminBooking(
      id: 'bk-001', bookingCode: 'A-001',
      userId: 'user-001', patientName: 'คุณสมสมาย ใจดี', patientPhone: '081-000-0001',
      clinicId: 'clinic-003', doctorId: 'doctor-005', doctorName: 'ทพญ. ดาราวดี',
      serviceId: 'svc-008', serviceName: 'ขูดหินปูน',
      appointmentDate: DateTime.now(), appointmentTime: '09:00',
      status: AdminQueueStatus.inProgress,
      depositAmount: 200, depositPaid: true, roomNumber: 1, queueNumber: 'A-001',
    ),
    AdminBooking(
      id: 'bk-002', bookingCode: 'A-002',
      userId: 'user-002', patientName: 'คุณหมูอ้วน สุขใจ', patientPhone: '082-000-0002',
      clinicId: 'clinic-003', doctorId: 'doctor-005', doctorName: 'ทพญ. ดาราวดี',
      serviceId: 'svc-009', serviceName: 'รักษารากฟัน',
      appointmentDate: DateTime.now(), appointmentTime: '10:00',
      status: AdminQueueStatus.confirmed,
      depositAmount: 2000, depositPaid: true, roomNumber: 1, queueNumber: 'A-002',
    ),
    AdminBooking(
      id: 'bk-003', bookingCode: 'A-003',
      userId: 'user-003', patientName: 'คุณดาราวดี อาลัย', patientPhone: '083-000-0003',
      clinicId: 'clinic-003', doctorId: 'doctor-005', doctorName: 'ทพญ. ดาราวดี',
      serviceId: 'svc-008', serviceName: 'ขูดหินปูน',
      appointmentDate: DateTime.now(), appointmentTime: '11:00',
      status: AdminQueueStatus.waiting,
      depositAmount: 200, depositPaid: false, roomNumber: 2, queueNumber: 'A-003',
    ),
    AdminBooking(
      id: 'bk-004', bookingCode: 'B-001',
      userId: 'user-004', patientName: 'คุณวิชัย รักดี', patientPhone: '084-000-0004',
      clinicId: 'clinic-003', doctorId: 'doctor-005', doctorName: 'ทพญ. ดาราวดี',
      serviceId: 'svc-008', serviceName: 'ขูดหินปูน',
      appointmentDate: DateTime.now(), appointmentTime: '13:00',
      status: AdminQueueStatus.confirmed,
      depositAmount: 200, depositPaid: true, roomNumber: 2, queueNumber: 'B-001',
    ),
    AdminBooking(
      id: 'bk-005', bookingCode: 'C-001',
      userId: 'user-005', patientName: 'คุณสมหมาย ดีงาม', patientPhone: '085-000-0005',
      clinicId: 'clinic-003', doctorId: 'doctor-005', doctorName: 'ทพญ. ดาราวดี',
      serviceId: 'svc-009', serviceName: 'รักษารากฟัน',
      appointmentDate: DateTime.now(), appointmentTime: '14:00',
      status: AdminQueueStatus.cancelled,
      depositAmount: 2000, depositPaid: false, roomNumber: 3, queueNumber: 'C-001',
    ),
    AdminBooking(
      id: 'bk-006', bookingCode: 'B-002',
      userId: 'user-006', patientName: 'คุณแมวจิ๋ว น่ารัก', patientPhone: '086-000-0006',
      clinicId: 'clinic-003', doctorId: 'doctor-005', doctorName: 'ทพญ. ดาราวดี',
      serviceId: 'svc-008', serviceName: 'ขูดหินปูน',
      appointmentDate: DateTime.now(), appointmentTime: '15:00',
      status: AdminQueueStatus.confirmed,
      depositAmount: 200, depositPaid: true, roomNumber: 2, queueNumber: 'B-002',
    ),
    AdminBooking(
      id: 'bk-007', bookingCode: 'A-004',
      userId: 'user-007', patientName: 'คุณหมีน้อย ใสสะอาด', patientPhone: '087-000-0007',
      clinicId: 'clinic-003', doctorId: 'doctor-005', doctorName: 'ทพญ. ดาราวดี',
      serviceId: 'svc-008', serviceName: 'ขูดหินปูน',
      appointmentDate: DateTime.now(), appointmentTime: '10:30',
      status: AdminQueueStatus.completed,
      depositAmount: 200, depositPaid: true, roomNumber: 3, queueNumber: 'A-004',
    ),
  ];

  // ---- Patients ------------------------------------------
  List<AdminPatient> get patients => [
    AdminPatient(
      id: 'user-001', fullName: 'คุณสมสมาย ใจดี',
      email: 'somsahai@email.com', phone: '081-000-0001',
      totalBookings: 5, lastVisit: DateTime.now().subtract(const Duration(days: 7)),
    ),
    AdminPatient(
      id: 'user-002', fullName: 'คุณหมูอ้วน สุขใจ',
      email: 'moo@email.com', phone: '082-000-0002',
      totalBookings: 2, lastVisit: DateTime.now().subtract(const Duration(days: 30)),
    ),
    AdminPatient(
      id: 'user-003', fullName: 'คุณดาราวดี อาลัย',
      email: '6614631011@rbru.ac.th', phone: '083-000-0003',
      totalBookings: 12, lastVisit: DateTime.now().subtract(const Duration(days: 5)),
    ),
    AdminPatient(
      id: 'user-004', fullName: 'คุณวิชัย รักดี',
      email: 'wichai@email.com', phone: '084-000-0004',
      totalBookings: 3, lastVisit: DateTime.now().subtract(const Duration(days: 14)),
    ),
  ];

  // ---- Stats ---------------------------------------------
  DashboardStats get stats => DashboardStats(
    totalToday: bookings.where((b) =>
        _isToday(b.appointmentDate) &&
        b.status != AdminQueueStatus.cancelled).length,
    waiting: bookings.where((b) =>
        _isToday(b.appointmentDate) &&
        (b.status == AdminQueueStatus.waiting ||
         b.status == AdminQueueStatus.confirmed)).length,
    inProgress: bookings.where((b) =>
        _isToday(b.appointmentDate) &&
        b.status == AdminQueueStatus.inProgress).length,
    completed: bookings.where((b) =>
        _isToday(b.appointmentDate) &&
        b.status == AdminQueueStatus.completed).length,
  );

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }
}
