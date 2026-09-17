// ============================================================
// Models — DentBook
// ใช้ร่วมกับ Mock Service และ Supabase จริง
// ============================================================

// ---- Clinic ------------------------------------------------
class ClinicModel {
  const ClinicModel({
    required this.id,
    required this.name,
    this.address,
    this.province,
    this.district,
    this.zipCode,
    this.phone,
    this.email,
    this.mapLink,
    this.imageUrl,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String? address;
  final String? province;
  final String? district;
  final String? zipCode;
  final String? phone;
  final String? email;
  final String? mapLink;
  final String? imageUrl;
  final bool isActive;

  factory ClinicModel.fromMap(Map<String, dynamic> m) => ClinicModel(
        id: m['id'] as String,
        name: m['name'] as String,
        address: m['address'] as String?,
        province: m['province'] as String?,
        district: m['district'] as String?,
        zipCode: m['zip_code'] as String?,
        phone: m['phone'] as String?,
        email: m['email'] as String?,
        mapLink: m['map_link'] as String?,
        imageUrl: m['image_url'] as String?,
        isActive: (m['is_active'] as bool?) ?? true,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'address': address,
        'province': province,
        'district': district,
        'zip_code': zipCode,
        'phone': phone,
        'email': email,
        'map_link': mapLink,
        'image_url': imageUrl,
        'is_active': isActive,
      };
}

// ---- Doctor ------------------------------------------------
class DoctorModel {
  const DoctorModel({
    required this.id,
    required this.clinicId,
    required this.fullName,
    this.specialty,
    this.imageUrl,
    this.available = true,
  });

  final String id;
  final String clinicId;
  final String fullName;
  final String? specialty;
  final String? imageUrl;
  final bool available;

  factory DoctorModel.fromMap(Map<String, dynamic> m) => DoctorModel(
        id: m['id'] as String,
        clinicId: m['clinic_id'] as String,
        fullName: m['full_name'] as String,
        specialty: m['specialty'] as String?,
        imageUrl: m['image_url'] as String?,
        available: (m['available'] as bool?) ?? true,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'clinic_id': clinicId,
        'full_name': fullName,
        'specialty': specialty,
        'image_url': imageUrl,
        'available': available,
      };
}

// ---- Service -----------------------------------------------
class ServiceModel {
  const ServiceModel({
    required this.id,
    required this.clinicId,
    required this.name,
    this.nameEn,
    this.description,
    this.price = 0,
    this.depositAmount = 0,
    this.durationMinutes = 30,
    this.iconName,
    this.isActive = true,
  });

  final String id;
  final String clinicId;
  final String name;
  final String? nameEn;
  final String? description;
  final double price;
  final double depositAmount;
  final int durationMinutes;
  final String? iconName;
  final bool isActive;

  factory ServiceModel.fromMap(Map<String, dynamic> m) => ServiceModel(
        id: m['id'] as String,
        clinicId: m['clinic_id'] as String,
        name: m['name'] as String,
        nameEn: m['name_en'] as String?,
        description: m['description'] as String?,
        price: (m['price'] as num?)?.toDouble() ?? 0,
        depositAmount: (m['deposit_amount'] as num?)?.toDouble() ?? 0,
        durationMinutes: (m['duration_minutes'] as int?) ?? 30,
        iconName: m['icon_name'] as String?,
        isActive: (m['is_active'] as bool?) ?? true,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'clinic_id': clinicId,
        'name': name,
        'name_en': nameEn,
        'description': description,
        'price': price,
        'deposit_amount': depositAmount,
        'duration_minutes': durationMinutes,
        'icon_name': iconName,
        'is_active': isActive,
      };
}

// ---- AvailableSlot -----------------------------------------
class SlotModel {
  const SlotModel({
    required this.id,
    required this.doctorId,
    required this.clinicId,
    required this.slotDate,
    required this.slotTime,
    this.isBooked = false,
  });

  final String id;
  final String doctorId;
  final String clinicId;
  final DateTime slotDate;
  final String slotTime; // "09:00"
  final bool isBooked;

  factory SlotModel.fromMap(Map<String, dynamic> m) => SlotModel(
        id: m['id'] as String,
        doctorId: m['doctor_id'] as String,
        clinicId: m['clinic_id'] as String,
        slotDate: DateTime.parse(m['slot_date'] as String),
        slotTime: m['slot_time'] as String,
        isBooked: (m['is_booked'] as bool?) ?? false,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'doctor_id': doctorId,
        'clinic_id': clinicId,
        'slot_date': slotDate.toIso8601String().substring(0, 10),
        'slot_time': slotTime,
        'is_booked': isBooked,
      };
}

// ---- Booking -----------------------------------------------
enum BookingStatus {
  waitingPayment,
  confirmed,
  inProgress,
  completed,
  cancelled;

  String get label {
    switch (this) {
      case waitingPayment: return 'รอชำระมัดจำ';
      case confirmed:      return 'ยืนยันแล้ว';
      case inProgress:     return 'กำลังรักษา';
      case completed:      return 'เสร็จสิ้น';
      case cancelled:      return 'ยกเลิก';
    }
  }

  static BookingStatus fromString(String s) {
    switch (s) {
      case 'confirmed':       return confirmed;
      case 'in_progress':     return inProgress;
      case 'completed':       return completed;
      case 'cancelled':       return cancelled;
      default:                return waitingPayment;
    }
  }

  String get value {
    switch (this) {
      case waitingPayment: return 'waiting_payment';
      case confirmed:      return 'confirmed';
      case inProgress:     return 'in_progress';
      case completed:      return 'completed';
      case cancelled:      return 'cancelled';
    }
  }
}

class BookingModel {
  const BookingModel({
    required this.id,
    required this.bookingCode,
    required this.userId,
    required this.clinicId,
    required this.clinicName,
    required this.doctorId,
    required this.doctorName,
    required this.serviceId,
    required this.serviceName,
    required this.serviceNameEn,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    this.depositAmount = 0,
    this.depositPaid = false,
    this.slipUrl,
    this.note,
    this.clinicAddress,
  });

  final String id;
  final String bookingCode;
  final String userId;
  final String clinicId;
  final String clinicName;
  final String doctorId;
  final String doctorName;
  final String serviceId;
  final String serviceName;
  final String serviceNameEn;
  final DateTime appointmentDate;
  final String appointmentTime;
  final BookingStatus status;
  final double depositAmount;
  final bool depositPaid;
  final String? slipUrl;
  final String? note;
  final String? clinicAddress;

  factory BookingModel.fromMap(Map<String, dynamic> m) => BookingModel(
        id: m['id'] as String,
        bookingCode: m['booking_code'] as String,
        userId: m['user_id'] as String,
        clinicId: m['clinic_id'] as String,
        clinicName: m['clinic_name'] as String? ?? '',
        doctorId: m['doctor_id'] as String,
        doctorName: m['doctor_name'] as String? ?? '',
        serviceId: m['service_id'] as String,
        serviceName: m['service_name'] as String? ?? '',
        serviceNameEn: m['service_name_en'] as String? ?? '',
        appointmentDate: DateTime.parse(m['appointment_date'] as String),
        appointmentTime: m['appointment_time'] as String,
        status: BookingStatus.fromString(m['status'] as String),
        depositAmount: (m['deposit_amount'] as num?)?.toDouble() ?? 0,
        depositPaid: (m['deposit_paid'] as bool?) ?? false,
        slipUrl: m['slip_url'] as String?,
        note: m['note'] as String?,
        clinicAddress: m['clinic_address'] as String?,
      );
}

// ---- Notification ------------------------------------------
enum NotificationType { appointment, promotion, treatmentTip, feedback }

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    this.body,
    this.isRead = false,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String? body;
  final bool isRead;
  final DateTime createdAt;

  factory NotificationModel.fromMap(Map<String, dynamic> m) {
    NotificationType t;
    switch (m['type'] as String?) {
      case 'promotion':     t = NotificationType.promotion; break;
      case 'treatment_tip': t = NotificationType.treatmentTip; break;
      case 'feedback':      t = NotificationType.feedback; break;
      default:              t = NotificationType.appointment;
    }
    return NotificationModel(
      id: m['id'] as String,
      userId: m['user_id'] as String,
      type: t,
      title: m['title'] as String,
      body: m['body'] as String?,
      isRead: (m['is_read'] as bool?) ?? false,
      createdAt: DateTime.parse(m['created_at'] as String),
    );
  }
}

// ---- ReviewModel -------------------------------------------
class ReviewModel {
  const ReviewModel({
    required this.id,
    required this.userId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final int rating;
  final String? comment;
  final DateTime createdAt;
}

// ---- UserModel ---------------------------------------------
class UserModel {
  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.birthDate,
    this.gender,
    this.profileImageUrl,
    this.pinEnabled = false,
    this.appointmentCount = 0,
    this.treatmentHistoryCount = 0,
  });

  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final DateTime? birthDate;
  final String? gender;
  final String? profileImageUrl;
  final bool pinEnabled;
  final int appointmentCount;
  final int treatmentHistoryCount;

  UserModel copyWith({
    String? fullName,
    String? phone,
    DateTime? birthDate,
    String? gender,
    String? profileImageUrl,
    bool? pinEnabled,
  }) =>
      UserModel(
        id: id,
        fullName: fullName ?? this.fullName,
        email: email,
        phone: phone ?? this.phone,
        birthDate: birthDate ?? this.birthDate,
        gender: gender ?? this.gender,
        profileImageUrl: profileImageUrl ?? this.profileImageUrl,
        pinEnabled: pinEnabled ?? this.pinEnabled,
        appointmentCount: appointmentCount,
        treatmentHistoryCount: treatmentHistoryCount,
      );
}
