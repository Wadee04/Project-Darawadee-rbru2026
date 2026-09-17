import 'package:flutter/material.dart';

import '../services/admin/admin_clinic_service.dart';
import '../services/admin/admin_booking_service.dart';
import '../services/admin/admin_models.dart';
import '../view/Admin/Dashboard/dashboard.dart';
import '../view/Admin/Scanqueue/scan_queue.dart';
import '../view/Admin/Stock/stock.dart';
import '../view/Admin/Stock/scanstock.dart';
import '../view/Admin/Stock/add_product.dart';
import '../view/Admin/ProfileAdmin/profile_admin.dart';
import '../view/Admin/ProfileAdmin/queue_management.dart';
import '../view/Admin/ProfileAdmin/patient_data.dart';
import '../view/Admin/SignUpAdmin/sign_up_admin.dart';
import '../view/Admin/SignUpAdmin/clinic_data.dart';
import '../view/Admin/SignUpAdmin/registration_summary.dart';
import '../view/Admin/SignUpAdmin/registration_status.dart';

// ============================================================
// AdminRouter — navigation hub ฝั่ง Admin
// ============================================================
class AdminRouter {
  AdminRouter._();

  // ---- entry points --------------------------------------
  static void goSignUp(BuildContext ctx)        => _push(ctx, _AdminSignUpScreen());
  static void goClinicData(BuildContext ctx, AdminSignUpData data) =>
      _push(ctx, _ClinicDataScreen(data: data));
  static void goRegSummary(BuildContext ctx, AdminSignUpData data) =>
      _push(ctx, _RegSummaryScreen(data: data));
  static void goRegStatus(BuildContext ctx,     RegStatus status) =>
      _push(ctx, RegistrationStatusPage(
        status: status,
        onGoHome: () => goDashboard(ctx),
        onContact: () {},
      ));

  static void goDashboard(BuildContext ctx) =>
      _pushAndRemoveAll(ctx, _DashboardScreen());
  static void goScanQueue(BuildContext ctx) =>
      _push(ctx, ScanQueuePage(
        onAddWalkIn: () => goQueueManagement(ctx),
        onNavTap: (i) => _onAdminNav(ctx, i),
        currentNavIndex: 1,
      ));
  static void goStock(BuildContext ctx)    => _push(ctx, _StockScreen());
  static void goProfile(BuildContext ctx)  => _push(ctx, _ProfileAdminScreen());
  static void goQueueManagement(BuildContext ctx) => _push(ctx, _QueueManagementScreen());
  static void goPatientData(BuildContext ctx)     => _push(ctx, _PatientDataScreen());
  static void goScanStock(BuildContext ctx) => _push(ctx, ScanStockPage(onBack: () => Navigator.maybePop(ctx)));
  static void goAddProduct(BuildContext ctx) =>
      _push(ctx, AddProductPage(onBack: () => Navigator.maybePop(ctx)));

  // ---- bottom nav handler --------------------------------
  static void _onAdminNav(BuildContext ctx, int index) {
    switch (index) {
      case 0: goDashboard(ctx); break;
      case 1: goScanQueue(ctx); break;
      case 2: goStock(ctx); break;
      case 3: goProfile(ctx); break;
    }
  }

  // ---- helpers -------------------------------------------
  static void _push(BuildContext ctx, Widget page) =>
      Navigator.push(ctx, MaterialPageRoute(builder: (_) => page));

  static void _pushAndRemoveAll(BuildContext ctx, Widget page) =>
      Navigator.pushAndRemoveUntil(
        ctx, MaterialPageRoute(builder: (_) => page), (r) => false);
}

// ============================================================
// _AdminSignUpData — state ที่ส่งผ่าน signup flow
// ============================================================
class AdminSignUpData {
  const AdminSignUpData({
    this.fullName = '', this.email = '', this.password = '', this.phone = '',
    this.clinicName = '', this.registrationNumber = '', this.operatingHours = '',
    this.address = '', this.province = '', this.district = '', this.zipCode = '',
  });

  final String fullName;
  final String email;
  final String password;
  final String phone;
  final String clinicName;
  final String registrationNumber;
  final String operatingHours;
  final String address;
  final String province;
  final String district;
  final String zipCode;

  AdminSignUpData copyWith({
    String? fullName, String? email, String? password, String? phone,
    String? clinicName, String? registrationNumber, String? operatingHours,
    String? address, String? province, String? district, String? zipCode,
  }) => AdminSignUpData(
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    password: password ?? this.password,
    phone: phone ?? this.phone,
    clinicName: clinicName ?? this.clinicName,
    registrationNumber: registrationNumber ?? this.registrationNumber,
    operatingHours: operatingHours ?? this.operatingHours,
    address: address ?? this.address,
    province: province ?? this.province,
    district: district ?? this.district,
    zipCode: zipCode ?? this.zipCode,
  );
}

// ============================================================
// _AdminSignUpScreen
// ============================================================
class _AdminSignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignUpAdminPage(
      onBack: () => Navigator.maybePop(context),
      onNext: ({required fullName, required email, required phone, required password}) {
        final data = AdminSignUpData(
          fullName: fullName, email: email, password: password, phone: phone,
        );
        AdminRouter.goClinicData(context, data);
      },
    );
  }
}

// ============================================================
// _ClinicDataScreen
// ============================================================
class _ClinicDataScreen extends StatelessWidget {
  const _ClinicDataScreen({required this.data});
  final AdminSignUpData data;

  @override
  Widget build(BuildContext context) {
    return ClinicDataPage(
      onBack: () => Navigator.maybePop(context),
      onSubmit: ({
        required clinicName, required registrationNumber, required operatingHours,
        required address, required province, required district, required zipCode,
        required licenseFiles, required addressFiles, required logoFiles,
      }) {
        final updated = data.copyWith(
          clinicName: clinicName,
          registrationNumber: registrationNumber,
          operatingHours: operatingHours,
          address: address,
          province: province,
          district: district,
          zipCode: zipCode,
        );
        AdminRouter.goRegSummary(context, updated);
      },
    );
  }
}

// ============================================================
// _RegSummaryScreen
// ============================================================
class _RegSummaryScreen extends StatelessWidget {
  const _RegSummaryScreen({required this.data});
  final AdminSignUpData data;

  @override
  Widget build(BuildContext context) {
    return RegistrationSummaryPage(
      onBack: () => Navigator.maybePop(context),
      fullName: data.fullName,
      email: data.email,
      phone: data.phone,
      clinicName: data.clinicName,
      clinicAddress: data.address,
      province: data.province,
      district: data.district,
      zipCode: data.zipCode,
      onConfirm: () => AdminRouter.goRegStatus(context, RegStatus.pending),
    );
  }
}

// ============================================================
// _DashboardScreen — โหลด stats แล้วส่งให้ DashboardPage
// ============================================================
class _DashboardScreen extends StatefulWidget {
  @override
  State<_DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<_DashboardScreen> {
  AdminUser? _admin;
  DashboardStats? _stats;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final admin  = await AdminClinicService.instance.getAdminUser();
      final stats  = await AdminClinicService.instance.getDashboardStats();
      await AdminBookingService.instance.getTodayBookings();
      if (mounted) {
        setState(() {
          _admin = admin;
          _stats = stats;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) { setState(() => _loading = false); }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return DashboardPage(
      adminName: 'สวัสดี, ${_admin?.fullName ?? 'แอดมิน'} 👋',
      clinicName: _admin?.clinicName ?? '',
      totalQueue: _stats?.totalToday ?? 0,
      pendingQueue: _stats?.waiting ?? 0,
      inProgressQueue: _stats?.inProgress ?? 0,
      completedQueue: _stats?.completed ?? 0,
      onSettings: () => AdminRouter.goProfile(context),
    );
  }
}

// ============================================================
// _StockScreen — wire StockPage
// ============================================================
class _StockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StockPage(
      currentNavIndex: 2,
      onNavTap: (i) => _onAdminNav(context, i),
      onScanQr: () => AdminRouter.goScanStock(context),
      onAddManual: () => AdminRouter.goAddProduct(context),
    );
  }

  void _onAdminNav(BuildContext ctx, int i) {
    switch (i) {
      case 0: AdminRouter.goDashboard(ctx); break;
      case 1: AdminRouter.goScanQueue(ctx); break;
      case 3: AdminRouter.goProfile(ctx); break;
    }
  }
}

// ============================================================
// _ProfileAdminScreen — โหลด admin user แล้วส่งให้ ProfileAdminPage
// ============================================================
class _ProfileAdminScreen extends StatefulWidget {
  @override
  State<_ProfileAdminScreen> createState() => _ProfileAdminScreenState();
}

class _ProfileAdminScreenState extends State<_ProfileAdminScreen> {
  AdminUser? _admin;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final a = await AdminClinicService.instance.getAdminUser();
      if (mounted) { setState(() { _admin = a; _loading = false; }); }
    } catch (_) {
      if (mounted) { setState(() => _loading = false); }
    }
  }

  ClinicStatus _mapStatus(AdminClinicStatus s) {
    switch (s) {
      case AdminClinicStatus.approved: return ClinicStatus.approved;
      case AdminClinicStatus.rejected: return ClinicStatus.rejected;
      default:                         return ClinicStatus.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return ProfileAdminPage(
      currentNavIndex: 3,
      onNavTap: (i) {
        switch (i) {
          case 0: AdminRouter.goDashboard(context); break;
          case 1: AdminRouter.goScanQueue(context); break;
          case 2: AdminRouter.goStock(context); break;
        }
      },
      adminName: _admin?.fullName ?? '',
      adminEmail: _admin?.email ?? '',
      clinicName: _admin?.clinicName ?? '',
      clinicPhone: _admin?.phone ?? '',
      clinicStatus: _mapStatus(_admin?.clinicStatus ?? AdminClinicStatus.pending),
      onChangePassword: () {},
    );
  }
}

// ============================================================
// _QueueManagementScreen — โหลดคิว แล้วส่งให้ QueueManagementPage
// ============================================================
class _QueueManagementScreen extends StatefulWidget {
  @override
  State<_QueueManagementScreen> createState() => _QueueManagementScreenState();
}

class _QueueManagementScreenState extends State<_QueueManagementScreen> {
  List<AdminQueueItem> _queues = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final bookings = await AdminBookingService.instance.getTodayBookings();
      if (mounted) {
        setState(() {
          _queues = bookings.map(_toQueueItem).toList();
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) { setState(() => _loading = false); }
    }
  }

  AdminQueueItem _toQueueItem(AdminBooking b) {
    QueueCardStatus status;
    switch (b.status) {
      case AdminQueueStatus.inProgress: status = QueueCardStatus.inProgress; break;
      case AdminQueueStatus.completed:  status = QueueCardStatus.completed; break;
      case AdminQueueStatus.cancelled:  status = QueueCardStatus.cancelled; break;
      default:                          status = QueueCardStatus.waiting;
    }
    return AdminQueueItem(
      bookingId: b.id,
      queueNumber: b.queueNumber ?? b.bookingCode,
      patientName: b.patientName,
      serviceName: b.serviceName,
      appointmentTime: b.appointmentTime,
      roomNumber: b.roomNumber ?? 1,
      status: status,
    );
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return QueueManagementPage(
      onBack: () => Navigator.maybePop(context),
      queues: _queues,
      onCallQueue: (id) async {
        await AdminBookingService.instance.callQueue(id);
        await _refresh();
      },
      onSkipQueue: (id) async {
        await AdminBookingService.instance.updateBookingStatus(id, AdminQueueStatus.confirmed);
        await _refresh();
      },
      onCompleteQueue: (id) async {
        await AdminBookingService.instance.completeQueue(id);
        await _refresh();
      },
      onCancelQueue: (id) async {
        await AdminBookingService.instance.cancelQueue(id);
        await _refresh();
      },
    );
  }
}

// ============================================================
// _PatientDataScreen — โหลดผู้ป่วย แล้วส่งให้ PatientDataPage
// ============================================================
class _PatientDataScreen extends StatefulWidget {
  @override
  State<_PatientDataScreen> createState() => _PatientDataScreenState();
}

class _PatientDataScreenState extends State<_PatientDataScreen> {
  List<PatientItem> _patients = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await AdminClinicService.instance.getPatients();
      if (mounted) {
        setState(() {
          _patients = list.map((p) => PatientItem(
            id: p.id,
            name: p.fullName,
            phone: p.phone,
            email: p.email,
            lastVisit: p.lastVisit ?? DateTime.now(),
            totalVisits: p.totalBookings,
            gender: p.gender,
            birthDate: p.birthDate,
          )).toList();
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) { setState(() => _loading = false); }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return PatientDataPage(
      onBack: () => Navigator.maybePop(context),
      patients: _patients,
    );
  }
}
