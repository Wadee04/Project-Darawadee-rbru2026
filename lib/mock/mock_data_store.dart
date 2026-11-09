import 'models.dart';

// ============================================================
// MockDataStore — ข้อมูลตัวอย่างทั้งหมด (in-memory)
// ============================================================
class MockDataStore {
  MockDataStore._();
  static final MockDataStore instance = MockDataStore._();

  // ---- USER ------------------------------------------------
  UserModel currentUser = const UserModel(
    id: 'user-001',
    fullName: 'ดาราวดี อาลัย',
    email: '6614631011@rbru.ac.th',
    phone: '091-0156190',
    gender: 'female',
    pinEnabled: true,
    appointmentCount: 5,
    treatmentHistoryCount: 12,
  );

  // ---- CLINICS ---------------------------------------------
  final List<ClinicModel> clinics = const [
    ClinicModel(
      id: 'clinic-001',
      name: 'DentBook Clinic สาขาจันทบุรี',
      address: '123/45 ถนนราชดำเนิน ตำบลหน้าเมือง อำเภอเมืองจันทบุรี จังหวัดจันทบุรี',
      province: 'จันทบุรี',
      district: 'เมืองจันทบุรี',
      zipCode: '22000',
      phone: '039-134-456',
      email: 'info@dentbook-chanthaburi.com',
      mapLink: 'https://maps.google.com/?q=DentBook+Chanthaburi',
    ),
    ClinicModel(
      id: 'clinic-002',
      name: 'SmileCare Dental Clinic',
      address: '88/12 ถนนสุขุมวิท ซอย 22 แขวงคลองเตย',
      province: 'กรุงเทพมหานคร',
      district: 'คลองเตย',
      zipCode: '10110',
      phone: '02-123-4567',
      email: 'info@smilecare.co.th',
      mapLink: 'https://maps.google.com/?q=SmileCare+Dental',
    ),
    ClinicModel(
      id: 'clinic-003',
      name: 'คลินิกทันตกรรมใจ๋',
      address: '56/7 ถนนเทศบาล 1 ตำบลท่าช้าง อำเภอเมืองจันทบุรี จังหวัดจันทบุรี',
      province: 'จันทบุรี',
      district: 'เมืองจันทบุรี',
      zipCode: '22000',
      phone: '039-200-789',
      email: 'admin@dental-jai.com',
    ),
  ];

  // ---- DOCTORS ---------------------------------------------
  final List<DoctorModel> doctors = const [
    DoctorModel(
      id: 'doctor-001',
      clinicId: 'clinic-001',
      fullName: 'ทพญ. อรุณี ปธานนท์',
      specialty: 'ทันตกรรมทั่วไป',
      available: true,
    ),
    DoctorModel(
      id: 'doctor-002',
      clinicId: 'clinic-001',
      fullName: 'ทพ. ณัฐพล สุขสวัสดิ์',
      specialty: 'ทันตกรรมจัดฟัน',
      available: true,
    ),
    DoctorModel(
      id: 'doctor-003',
      clinicId: 'clinic-002',
      fullName: 'ทพญ. พิมพ์ชนก วงศ์ทอง',
      specialty: 'ทันตกรรมเด็ก',
      available: true,
    ),
    DoctorModel(
      id: 'doctor-004',
      clinicId: 'clinic-002',
      fullName: 'ทพ. ชัยวัฒน์ รัตนโชติ',
      specialty: 'ทันตกรรมรากฟันเทียม',
      available: true,
    ),
    DoctorModel(
      id: 'doctor-005',
      clinicId: 'clinic-003',
      fullName: 'ทพญ. ดาราวดี อาลัย',
      specialty: 'ทันตกรรมทั่วไป',
      available: true,
    ),
    DoctorModel(
      id: 'doctor-006',
      clinicId: 'clinic-003',
      fullName: 'ทพ. ศุภกิจ มณีรัตน์',
      specialty: 'ทันตกรรมเอ็นโดดอนต์',
      available: false,
    ),
  ];

  // ---- SERVICES --------------------------------------------
  final List<ServiceModel> services = const [
    ServiceModel(
      id: 'svc-001', clinicId: 'clinic-001',
      name: 'ตรวจสุขภาพฟันทั่วไป', nameEn: 'Dental Check-up',
      description: 'ตรวจสภาพฟัน เหงือก และช่องปากโดยทันตแพทย์',
      price: 500, depositAmount: 0, durationMinutes: 30, iconName: 'checkup',
    ),
    ServiceModel(
      id: 'svc-002', clinicId: 'clinic-001',
      name: 'ขูดหินปูน', nameEn: 'Scaling',
      description: 'ขูดหินปูนและทำความสะอาดช่องปาก',
      price: 800, depositAmount: 200, durationMinutes: 45, iconName: 'scaling',
    ),
    ServiceModel(
      id: 'svc-003', clinicId: 'clinic-001',
      name: 'อุดฟัน', nameEn: 'Tooth Filling',
      description: 'อุดฟันด้วยวัสดุคอมโพสิต',
      price: 1200, depositAmount: 300, durationMinutes: 60, iconName: 'filling',
    ),
    ServiceModel(
      id: 'svc-004', clinicId: 'clinic-001',
      name: 'ถอนฟัน', nameEn: 'Tooth Extraction',
      description: 'ถอนฟันโดยทันตแพทย์ผู้เชี่ยวชาญ',
      price: 600, depositAmount: 150, durationMinutes: 30, iconName: 'extraction',
    ),
    ServiceModel(
      id: 'svc-005', clinicId: 'clinic-002',
      name: 'จัดฟันแบบใส', nameEn: 'Clear Aligner',
      description: 'จัดฟันด้วยเครื่องมือใสไม่เจ็บปวด',
      price: 85000, depositAmount: 5000, durationMinutes: 60, iconName: 'braces',
    ),
    ServiceModel(
      id: 'svc-006', clinicId: 'clinic-002',
      name: 'ฟอกสีฟัน', nameEn: 'Teeth Whitening',
      description: 'ฟอกสีฟันให้ขาวสว่างขึ้น',
      price: 3500, depositAmount: 500, durationMinutes: 60, iconName: 'whitening',
    ),
    ServiceModel(
      id: 'svc-007', clinicId: 'clinic-002',
      name: 'รากฟันเทียม', nameEn: 'Dental Implant',
      description: 'ปลูกรากฟันเทียมทดแทนฟันที่หายไป',
      price: 45000, depositAmount: 10000, durationMinutes: 90, iconName: 'implant',
    ),
    ServiceModel(
      id: 'svc-008', clinicId: 'clinic-003',
      name: 'ขูดหินปูนและเคลือบฟลูออไรด์', nameEn: 'Scaling & Fluoride',
      description: 'ขูดหินปูนพร้อมเคลือบฟลูออไรด์ป้องกันฟันผุ',
      price: 1000, depositAmount: 200, durationMinutes: 60, iconName: 'scaling',
    ),
    ServiceModel(
      id: 'svc-009', clinicId: 'clinic-003',
      name: 'รักษารากฟัน', nameEn: 'Root Canal Treatment',
      description: 'รักษาคลองรากฟันสำหรับฟันที่ผุลึก',
      price: 8000, depositAmount: 2000, durationMinutes: 90, iconName: 'root_canal',
    ),
  ];

  // ---- AVAILABLE SLOTS -------------------------------------
  List<SlotModel> _generateSlots() {
    final List<SlotModel> slots = [];
    final today = DateTime.now();
    final times = ['09:00','09:30','10:00','10:30','11:00','11:30',
                   '13:00','13:30','14:00','14:30','15:00','15:30','16:00','16:30'];

    final availDoctors = doctors.where((d) => d.available).toList();
    int counter = 1;

    for (int day = 0; day < 30; day++) {
      final date = today.add(Duration(days: day));
      if (date.weekday == DateTime.sunday) continue;

      for (final doc in availDoctors) {
        for (final time in times) {
          slots.add(SlotModel(
            id: 'slot-${counter.toString().padLeft(5, '0')}',
            doctorId: doc.id,
            clinicId: doc.clinicId,
            slotDate: DateTime(date.year, date.month, date.day),
            slotTime: time,
            isBooked: false,
          ));
          counter++;
        }
      }
    }
    return slots;
  }

  late List<SlotModel> slots = _generateSlots();

  // ---- BOOKINGS --------------------------------------------
  List<BookingModel> bookings = [
    BookingModel(
      id: 'bk-001',
      bookingCode: 'BK260801-0001',
      userId: 'user-001',
      clinicId: 'clinic-001',
      clinicName: 'DentBook Clinic สาขาจันทบุรี',
      doctorId: 'doctor-001',
      doctorName: 'ทพญ. อรุณี ปธานนท์',
      serviceId: 'svc-002',
      serviceName: 'ขูดหินปูน',
      serviceNameEn: 'Scaling',
      appointmentDate: DateTime.now().add(const Duration(days: 7)),
      appointmentTime: '10:00',
      status: BookingStatus.confirmed,
      depositAmount: 200,
      depositPaid: true,
      clinicAddress: '123/45 ถนนราชดำเนิน ตำบลหน้าเมือง อำเภอเมืองจันทบุรี จังหวัดจันทบุรี',
    ),
    BookingModel(
      id: 'bk-002',
      bookingCode: 'BK260801-0002',
      userId: 'user-001',
      clinicId: 'clinic-001',
      clinicName: 'DentBook Clinic สาขาจันทบุรี',
      doctorId: 'doctor-002',
      doctorName: 'ทพ. ณัฐพล สุขสวัสดิ์',
      serviceId: 'svc-001',
      serviceName: 'ตรวจสุขภาพฟันทั่วไป',
      serviceNameEn: 'Dental Check-up',
      appointmentDate: DateTime.now().add(const Duration(days: 14)),
      appointmentTime: '13:00',
      status: BookingStatus.waitingPayment,
      depositAmount: 0,
      depositPaid: false,
      clinicAddress: '123/45 ถนนราชดำเนิน ตำบลหน้าเมือง อำเภอเมืองจันทบุรี จังหวัดจันทบุรี',
    ),
    BookingModel(
      id: 'bk-003',
      bookingCode: 'BK260801-0003',
      userId: 'user-001',
      clinicId: 'clinic-003',
      clinicName: 'คลินิกทันตกรรมใจ๋',
      doctorId: 'doctor-005',
      doctorName: 'ทพญ. ดาราวดี อาลัย',
      serviceId: 'svc-008',
      serviceName: 'ขูดหินปูนและเคลือบฟลูออไรด์',
      serviceNameEn: 'Scaling & Fluoride',
      appointmentDate: DateTime.now().subtract(const Duration(days: 5)),
      appointmentTime: '09:00',
      status: BookingStatus.completed,
      depositAmount: 200,
      depositPaid: true,
      clinicAddress: '56/7 ถนนเทศบาล 1 ตำบลท่าช้าง อำเภอเมืองจันทบุรี จังหวัดจันทบุรี',
    ),
    BookingModel(
      id: 'bk-004',
      bookingCode: 'BK260801-0004',
      userId: 'user-001',
      clinicId: 'clinic-001',
      clinicName: 'DentBook Clinic สาขาจันทบุรี',
      doctorId: 'doctor-001',
      doctorName: 'ทพญ. อรุณี ปธานนท์',
      serviceId: 'svc-003',
      serviceName: 'อุดฟัน',
      serviceNameEn: 'Tooth Filling',
      appointmentDate: DateTime.now().subtract(const Duration(days: 30)),
      appointmentTime: '10:30',
      status: BookingStatus.cancelled,
      depositAmount: 300,
      depositPaid: false,
      note: 'ยกเลิกเนื่องจากติดธุระ',
      clinicAddress: '123/45 ถนนราชดำเนิน ตำบลหน้าเมือง อำเภอเมืองจันทบุรี จังหวัดจันทบุรี',
    ),
    BookingModel(
      id: 'bk-005',
      bookingCode: 'BK260801-0005',
      userId: 'user-001',
      clinicId: 'clinic-002',
      clinicName: 'SmileCare Dental Clinic',
      doctorId: 'doctor-003',
      doctorName: 'ทพญ. พิมพ์ชนก วงศ์ทอง',
      serviceId: 'svc-006',
      serviceName: 'ฟอกสีฟัน',
      serviceNameEn: 'Teeth Whitening',
      appointmentDate: DateTime.now().subtract(const Duration(days: 60)),
      appointmentTime: '14:00',
      status: BookingStatus.completed,
      depositAmount: 500,
      depositPaid: true,
      clinicAddress: '88/12 ถนนสุขุมวิท ซอย 22 แขวงคลองเตย',
    ),
  ];

  // ---- NOTIFICATIONS ---------------------------------------
  List<NotificationModel> notifications = [
    NotificationModel(
      id: 'notif-001',
      userId: 'user-001',
      type: NotificationType.appointment,
      title: 'นัดหมายในอีก 1 วัน',
      body: 'คุณมีนัดกับ ทพญ. อรุณี ปธานนท์ พรุ่งนี้เวลา 10:00 น.',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 'notif-002',
      userId: 'user-001',
      type: NotificationType.appointment,
      title: 'ยืนยันการจองสำเร็จ',
      body: 'การจองหมายเลข BK260801-0001 ได้รับการยืนยันแล้ว',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationModel(
      id: 'notif-003',
      userId: 'user-001',
      type: NotificationType.promotion,
      title: 'โปรโมชั่นพิเศษ! ขูดหินปูนลด 20%',
      body: 'จองภายใน 31 สิงหาคม รับส่วนลดทันที ไม่จำกัดจำนวน',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    NotificationModel(
      id: 'notif-004',
      userId: 'user-001',
      type: NotificationType.treatmentTip,
      title: 'คำแนะนำหลังขูดหินปูน',
      body: 'หลีกเลี่ยงอาหารร้อน เย็น หรือแข็งเป็นเวลา 24 ชั่วโมงหลังการรักษา',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
  ];
}
