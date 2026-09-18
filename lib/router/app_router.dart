import 'package:flutter/material.dart';

import '../services/service_locator.dart';
import '../view/User/Onboarding/select_account_type.dart';
import '../view/User/Signin/signin_one.dart';
import '../view/User/Signup/signup.dart';
import '../view/User/HomeScreen/home_page_one.dart';
import '../view/User/Book_an_appointment/book_an_appointment_one.dart';
import '../view/User/My_queue/my_queue_one.dart';
import '../view/User/Profile/profile.dart';
import '../view/User/Profile/edit_personal_infomation.dart';
import '../view/User/Profile/security_settings.dart';
import '../view/User/Profile/change_password.dart';
import '../view/User/Profile/change_email.dart';
import '../view/User/Profile/warn.dart';
import '../view/User/Profile/rate_your_experience.dart';
import '../view/User/Profile/help.dart';
import '../view/User/Profile/call_me.dart';
import '../view/User/Profile/switch_account.dart';
import '../view/User/Create_pin/pin.dart';

// ============================================================
// AppRouter — navigation helper ใช้ MaterialPageRoute
// ทุก push ผ่าน router นี้เพื่อให้ service wiring อยู่ที่เดียว
// ============================================================
class AppRouter {
  AppRouter._();

  // ============================================================
  // AUTH
  // ============================================================
  static void goSelectAccountType(BuildContext ctx) =>
      _push(ctx, const SelectAccountType());

  static void goSignIn(BuildContext ctx) => _push(ctx, _SignInScreen());

  static void goSignUp(BuildContext ctx) => _push(ctx, _SignUpScreen());

  // ============================================================
  // HOME
  // ============================================================
  static void goHome(BuildContext ctx) => _pushAndRemoveAll(ctx, _HomeScreen());

  // ============================================================
  // BOOK
  // ============================================================
  static void goBooking(BuildContext ctx) =>
      _push(ctx, const BookAnAppointmentOne());

  // ============================================================
  // MY QUEUE
  // ============================================================
  static void goMyQueue(BuildContext ctx) => _push(ctx, _MyQueueScreen());

  // ============================================================
  // PROFILE
  // ============================================================
  static void goProfile(BuildContext ctx) => _push(ctx, _ProfileScreen());

  static void goEditProfile(BuildContext ctx) =>
      _push(ctx, _EditProfileScreen());

  static void goSecurity(BuildContext ctx) => _push(ctx, _SecurityScreen());

  static void goChangePassword(BuildContext ctx) =>
      _push(ctx, _ChangePasswordScreen());

  static void goChangeEmail(BuildContext ctx) =>
      _push(ctx, _ChangeEmailScreen());

  static void goNotificationSettings(BuildContext ctx) =>
      _push(ctx, _NotificationSettingsScreen());

  static void goRateApp(BuildContext ctx) => _push(ctx, _RateAppScreen());

  static void goHelp(BuildContext ctx) =>
      _push(ctx, HelpPage(onBack: () => Navigator.maybePop(ctx)));

  static void goContact(BuildContext ctx) =>
      _push(ctx, CallMePage(onBack: () => Navigator.maybePop(ctx)));

  static void goSwitchAccount(BuildContext ctx) =>
      _push(ctx, const SwitchAccountPage());

  static void goCreatePin(BuildContext ctx) => _push(ctx, _CreatePinScreen());

  // ============================================================
  // Helpers
  // ============================================================
  static void _push(BuildContext ctx, Widget page) =>
      Navigator.push(ctx, MaterialPageRoute(builder: (_) => page));

  static void _pushAndRemoveAll(BuildContext ctx, Widget page) =>
      Navigator.pushAndRemoveUntil(
        ctx,
        MaterialPageRoute(builder: (_) => page),
        (route) => false,
      );
}

// ============================================================
// _SignInScreen — wire SignInOne
// ============================================================
class _SignInScreen extends StatefulWidget {
  @override
  State<_SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<_SignInScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _handleSignIn(String email, String password) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final user = await ServiceLocator.user.signIn(
        email: email,
        password: password,
      );
      if (!mounted) return;
      if (user != null) {
        AppRouter.goHome(context);
      } else {
        setState(() => _error = 'อีเมลหรือรหัสผ่านไม่ถูกต้อง');
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SignInOne(
          onSignIn: _handleSignIn,
          onRegister: () => AppRouter.goSignUp(context),
        ),
        if (_loading)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x44000000),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        if (_error != null)
          Positioned(
            bottom: 80,
            left: 24,
            right: 24,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ============================================================
// _SignUpScreen — wire SignUp flow (signup → otp → phone → birthday → gender)
// ============================================================
class _SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignUp(
      onBack: () => Navigator.maybePop(context),
      onSignIn: () => AppRouter.goSignIn(context),
    );
  }
}

// ============================================================
// _HomeScreen — โหลด user แล้วส่งให้ HomePageOne
// ============================================================
class _HomeScreen extends StatefulWidget {
  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      await ServiceLocator.user.getCurrentUser();
      if (mounted) {
        setState(() => _loading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return HomePageOne(
      onProfile: () => AppRouter.goProfile(context),
      onBooking: () => AppRouter.goBooking(context),
      onMyQueue: () => AppRouter.goMyQueue(context),
    );
  }
}

// ============================================================
// _MyQueueScreen — โหลดคิวจาก BookingService
// ============================================================
class _MyQueueScreen extends StatefulWidget {
  @override
  State<_MyQueueScreen> createState() => _MyQueueScreenState();
}

class _MyQueueScreenState extends State<_MyQueueScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // pre-warm service เพื่อให้ data store โหลดก่อนที่ MyQueueOne จะ render
    try {
      await ServiceLocator.booking.getMyBookings();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return MyQueueOne(
      onHome: () => AppRouter.goHome(context),
      onBooking: () => AppRouter.goBooking(context),
      onProfile: () => AppRouter.goProfile(context),
    );
  }
}

// ============================================================
// _ProfileScreen — โหลด user แล้วส่งให้ ProfilePage
// ============================================================
class _ProfileScreen extends StatefulWidget {
  @override
  State<_ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<_ProfileScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      await ServiceLocator.user.getCurrentUser();
      await ServiceLocator.booking.getBookingStats();
      if (!mounted) return;
      setState(() => _loading = false);
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _handleLogout() {
    if (!mounted) return;
    AppRouter._pushAndRemoveAll(context, _SignInScreen());
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return ProfilePage(
      onPersonalInfo: () => AppRouter.goEditProfile(context),
      onPrivacy: () => AppRouter.goSecurity(context),
      onNotification: () => AppRouter.goNotificationSettings(context),
      onHelp: () => AppRouter.goHelp(context),
      onContact: () => AppRouter.goContact(context),
      onSwitchAccount: () => AppRouter.goSwitchAccount(context),
      onRateApp: () => AppRouter.goRateApp(context),
      onLogout: _handleLogout,
    );
  }
}

// ============================================================
// _EditProfileScreen — โหลดข้อมูล แล้ว save กลับ
// ============================================================
class _EditProfileScreen extends StatefulWidget {
  @override
  State<_EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<_EditProfileScreen> {
  UserModel? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final user = await ServiceLocator.user.getCurrentUser();
      if (mounted) {
        setState(() {
          _user = user;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleSave({
    required String firstName,
    required String lastName,
    required String gender,
    required String birthDate,
    required String phone,
    required String email,
  }) async {
    await ServiceLocator.user.updateProfile(
      fullName: '$firstName $lastName'.trim(),
      phone: phone,
      gender: gender,
    );
    if (mounted) Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final nameParts = (_user?.fullName ?? '').split(' ');
    return EditPersonalInformation(
      onCancel: () => Navigator.maybePop(context),
      onSave: _handleSave,
      initialFirstName: nameParts.isNotEmpty ? nameParts.first : '',
      initialLastName: nameParts.length > 1 ? nameParts.last : '',
      initialPhone: _user?.phone ?? '',
      initialGender: _user?.gender ?? '',
      initialEmail: _user?.email ?? '',
    );
  }
}

// ============================================================
// _SecurityScreen — wire SecuritySettingsPage
// ============================================================
class _SecurityScreen extends StatefulWidget {
  @override
  State<_SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<_SecurityScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      await ServiceLocator.user.getCurrentUser();
      if (mounted) {
        setState(() => _loading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return SecuritySettingsPage(
      onBack: () => Navigator.maybePop(context),
      onChangePassword: () => AppRouter.goChangePassword(context),
      onChangeEmail: () => AppRouter.goChangeEmail(context),
    );
  }
}

// ============================================================
// _ChangePasswordScreen
// ============================================================
class _ChangePasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangePasswordPage(
      onBack: () => Navigator.maybePop(context),
      onNext:
          ({
            required String currentPassword,
            required String newPassword,
          }) async {
            final ok = await ServiceLocator.user.changePassword(
              currentPassword: currentPassword,
              newPassword: newPassword,
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    ok ? 'เปลี่ยนรหัสผ่านสำเร็จ' : 'เปลี่ยนรหัสผ่านไม่สำเร็จ',
                  ),
                ),
              );
              if (ok) Navigator.maybePop(context);
            }
          },
    );
  }
}

// ============================================================
// _ChangeEmailScreen
// ============================================================
class _ChangeEmailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeEmailPage(
      onBack: () => Navigator.maybePop(context),
      onNext: (newEmail) async {
        final ok = await ServiceLocator.user.changeEmail(newEmail);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ok
                    ? 'เปลี่ยนอีเมลสำเร็จ กรุณายืนยันทางอีเมลใหม่'
                    : 'เปลี่ยนอีเมลไม่สำเร็จ',
              ),
            ),
          );
          if (ok) Navigator.maybePop(context);
        }
      },
    );
  }
}

// ============================================================
// _NotificationSettingsScreen — โหลด + save ตั้งค่า
// ============================================================
class _NotificationSettingsScreen extends StatefulWidget {
  @override
  State<_NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<_NotificationSettingsScreen> {
  NotificationSettings? _settings;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final s = await ServiceLocator.notification.getSettings();
      if (mounted) {
        setState(() {
          _settings = s;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return WarnPage(
      onBack: () => Navigator.maybePop(context),
      initialAllNotifications: _settings?.allEnabled ?? true,
      initialAppointment: _settings?.appointment ?? true,
      initialPromotion: _settings?.promotion ?? true,
      initialTreatmentTip: _settings?.treatmentTip ?? true,
      initialFeedback: _settings?.feedback ?? true,
    );
  }
}

// ============================================================
// _RateAppScreen — submit review
// ============================================================
class _RateAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RateYourExperiencePage(
      onBack: () => Navigator.maybePop(context),
      onSkip: () => Navigator.maybePop(context),
      onSubmit: (rating, comment) async {
        await ServiceLocator.review.submitReview(
          rating: rating,
          comment: comment.isNotEmpty ? comment : null,
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ขอบคุณสำหรับคะแนนของคุณ!')),
          );
          Navigator.maybePop(context);
        }
      },
    );
  }
}

// ============================================================
// _CreatePinScreen — save pin
// ============================================================
class _CreatePinScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PinPage(
      onBack: () => Navigator.maybePop(context),
      onComplete: (pin) async {
        await ServiceLocator.user.togglePin(enabled: true, pinHash: pin);
        if (context.mounted) Navigator.maybePop(context);
      },
    );
  }
}
