import 'package:flutter/material.dart';

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
  static void goSignUp(BuildContext ctx) => _push(ctx, _AdminSignUpScreen());
  static void goClinicData(BuildContext ctx, AdminSignUpData data) =>
      _push(ctx, _ClinicDataScreen(data: data));
  static void goRegSummary(BuildContext ctx, AdminSignUpData data) =>
      _push(ctx, _RegSummaryScreen(data: data));
  static void goRegStatus(BuildContext ctx, RegStatus status) => _push(
    ctx,
    RegistrationStatusPage(
      status: status,
      onGoHome: () => goDashboard(ctx),
      onContact: () {},
    ),
  );

  static void goDashboard(BuildContext ctx) => _pushAndRemoveAll(
    ctx,
    DashboardPage(
      currentNavIndex: 0,
      onSettings: () => goProfile(ctx),
      onNavTap: (i) => _onAdminNav(ctx, i),
    ),
  );
  static void goScanQueue(BuildContext ctx) => _push(
    ctx,
    ScanQueuePage(
      onAddWalkIn: () => goQueueManagement(ctx),
      onNavTap: (i) => _onAdminNav(ctx, i),
      currentNavIndex: 1,
    ),
  );
  static void goStock(BuildContext ctx) => _push(
    ctx,
    StockPage(
      currentNavIndex: 2,
      onNavTap: (i) => _onAdminNav(ctx, i),
      onScanQr: () => goScanStock(ctx),
      onAddManual: () => goAddProduct(ctx),
    ),
  );
  static void goProfile(BuildContext ctx) => _push(
    ctx,
    ProfileAdminPage(
      currentNavIndex: 3,
      onNavTap: (i) => _onAdminNav(ctx, i),
      onChangePassword: () {},
    ),
  );
  static void goQueueManagement(BuildContext ctx) =>
      _push(ctx, QueueManagementPage(onBack: () => Navigator.maybePop(ctx)));
  static void goPatientData(BuildContext ctx) =>
      _push(ctx, PatientDataPage(onBack: () => Navigator.maybePop(ctx)));
  static void goScanStock(BuildContext ctx) =>
      _push(ctx, ScanStockPage(onBack: () => Navigator.maybePop(ctx)));
  static void goAddProduct(BuildContext ctx) =>
      _push(ctx, AddProductPage(onBack: () => Navigator.maybePop(ctx)));

  // ---- bottom nav handler --------------------------------
  static void _onAdminNav(BuildContext ctx, int index) {
    switch (index) {
      case 0:
        goDashboard(ctx);
        break;
      case 1:
        goScanQueue(ctx);
        break;
      case 2:
        goStock(ctx);
        break;
      case 3:
        goProfile(ctx);
        break;
    }
  }

  // ---- helpers -------------------------------------------
  static void _push(BuildContext ctx, Widget page) =>
      Navigator.push(ctx, MaterialPageRoute(builder: (_) => page));

  static void _pushAndRemoveAll(BuildContext ctx, Widget page) =>
      Navigator.pushAndRemoveUntil(
        ctx,
        MaterialPageRoute(builder: (_) => page),
        (r) => false,
      );
}

// ============================================================
// _AdminSignUpData — state ที่ส่งผ่าน signup flow
// ============================================================
class AdminSignUpData {
  const AdminSignUpData({
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.phone = '',
    this.clinicName = '',
    this.registrationNumber = '',
    this.operatingHours = '',
    this.address = '',
    this.province = '',
    this.district = '',
    this.zipCode = '',
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
    String? fullName,
    String? email,
    String? password,
    String? phone,
    String? clinicName,
    String? registrationNumber,
    String? operatingHours,
    String? address,
    String? province,
    String? district,
    String? zipCode,
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
      onNext:
          ({
            required fullName,
            required email,
            required phone,
            required password,
          }) {
            final data = AdminSignUpData(
              fullName: fullName,
              email: email,
              password: password,
              phone: phone,
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
      onSubmit:
          ({
            required clinicName,
            required registrationNumber,
            required operatingHours,
            required address,
            required province,
            required district,
            required zipCode,
            required licenseFiles,
            required addressFiles,
            required logoFiles,
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
      registrationNumber: data.registrationNumber,
      operatingHours: data.operatingHours,
      onConfirm: () => AdminRouter.goRegStatus(context, RegStatus.pending),
    );
  }
}
