// ============================================================
// admin_models.dart — models เฉพาะฝั่ง Admin
// ============================================================

// ---- Admin User --------------------------------------------
class AdminUser {
  const AdminUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.clinicId,
    required this.clinicName,
    required this.clinicStatus,
    this.phone,
  });

  final String id;
  final String fullName;
  final String email;
  final String clinicId;
  final String clinicName;
  final AdminClinicStatus clinicStatus;
  final String? phone;
}

// ---- Clinic Status -----------------------------------------
enum AdminClinicStatus { pending, approved, rejected }

extension AdminClinicStatusExt on AdminClinicStatus {
  String get value {
    switch (this) {
      case AdminClinicStatus.pending:  return 'pending';
      case AdminClinicStatus.approved: return 'approved';
      case AdminClinicStatus.rejected: return 'rejected';
    }
  }

  static AdminClinicStatus fromString(String s) {
    switch (s) {
      case 'approved': return AdminClinicStatus.approved;
      case 'rejected': return AdminClinicStatus.rejected;
      default:         return AdminClinicStatus.pending;
    }
  }
}

// ---- Admin Booking (คิว) -----------------------------------
enum AdminQueueStatus { waiting, confirmed, inProgress, completed, cancelled }

extension AdminQueueStatusExt on AdminQueueStatus {
  String get value {
    switch (this) {
      case AdminQueueStatus.waiting:    return 'waiting_payment';
      case AdminQueueStatus.confirmed:  return 'confirmed';
      case AdminQueueStatus.inProgress: return 'in_progress';
      case AdminQueueStatus.completed:  return 'completed';
      case AdminQueueStatus.cancelled:  return 'cancelled';
    }
  }

  static AdminQueueStatus fromString(String s) {
    switch (s) {
      case 'confirmed':      return AdminQueueStatus.confirmed;
      case 'in_progress':    return AdminQueueStatus.inProgress;
      case 'completed':      return AdminQueueStatus.completed;
      case 'cancelled':      return AdminQueueStatus.cancelled;
      default:               return AdminQueueStatus.waiting;
    }
  }
}

class AdminBooking {
  const AdminBooking({
    required this.id,
    required this.bookingCode,
    required this.userId,
    required this.patientName,
    required this.patientPhone,
    required this.clinicId,
    required this.doctorId,
    required this.doctorName,
    required this.serviceId,
    required this.serviceName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    this.depositAmount = 0,
    this.depositPaid = false,
    this.slipUrl,
    this.roomNumber,
    this.queueNumber,
    this.note,
  });

  final String id;
  final String bookingCode;
  final String userId;
  final String patientName;
  final String patientPhone;
  final String clinicId;
  final String doctorId;
  final String doctorName;
  final String serviceId;
  final String serviceName;
  final DateTime appointmentDate;
  final String appointmentTime;
  final AdminQueueStatus status;
  final double depositAmount;
  final bool depositPaid;
  final String? slipUrl;
  final int? roomNumber;
  final String? queueNumber;
  final String? note;

  factory AdminBooking.fromMap(Map<String, dynamic> m) {
    final patient = m['users'] as Map<String, dynamic>?;
    final doctor  = m['doctors'] as Map<String, dynamic>?;
    final service = m['services'] as Map<String, dynamic>?;

    return AdminBooking(
      id:              m['id'] as String,
      bookingCode:     m['booking_code'] as String,
      userId:          m['user_id'] as String,
      patientName:     patient?['full_name'] as String? ?? 'ไม่ทราบชื่อ',
      patientPhone:    patient?['phone'] as String? ?? '-',
      clinicId:        m['clinic_id'] as String,
      doctorId:        m['doctor_id'] as String,
      doctorName:      doctor?['full_name'] as String? ?? '',
      serviceId:       m['service_id'] as String,
      serviceName:     service?['name'] as String? ?? '',
      appointmentDate: DateTime.parse(m['appointment_date'] as String),
      appointmentTime: m['appointment_time'] as String,
      status:          AdminQueueStatusExt.fromString(m['status'] as String),
      depositAmount:   (m['deposit_amount'] as num?)?.toDouble() ?? 0,
      depositPaid:     (m['deposit_paid'] as bool?) ?? false,
      slipUrl:         m['slip_url'] as String?,
      roomNumber:      m['room_number'] as int?,
      queueNumber:     m['queue_number'] as String?,
      note:            m['note'] as String?,
    );
  }
}

// ---- Patient (admin view) ----------------------------------
class AdminPatient {
  const AdminPatient({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.totalBookings,
    required this.lastVisit,
    this.gender,
    this.birthDate,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final int totalBookings;
  final DateTime? lastVisit;
  final String? gender;
  final DateTime? birthDate;

  factory AdminPatient.fromMap(Map<String, dynamic> m, {int totalBookings = 0, DateTime? lastVisit}) {
    return AdminPatient(
      id:            m['id'] as String,
      fullName:      m['full_name'] as String? ?? '',
      email:         m['email'] as String? ?? '',
      phone:         m['phone'] as String? ?? '-',
      totalBookings: totalBookings,
      lastVisit:     lastVisit,
      gender:        m['gender'] as String?,
      birthDate:     m['birth_date'] != null
          ? DateTime.tryParse(m['birth_date'] as String)
          : null,
    );
  }
}

// ---- Dashboard Stats ---------------------------------------
class DashboardStats {
  const DashboardStats({
    required this.totalToday,
    required this.waiting,
    required this.inProgress,
    required this.completed,
  });

  final int totalToday;
  final int waiting;
  final int inProgress;
  final int completed;
}
