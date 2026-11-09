import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../components/shared_widgets.dart';
import '../../../services/service_locator.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// EditPersonalInformation — หน้าแก้ไขข้อมูลส่วนตัว
// ============================================================
class EditPersonalInformation extends StatefulWidget {
  const EditPersonalInformation({
    super.key,
    this.onCancel,
    this.onSave,
    this.initialFirstName = '',
    this.initialLastName = '',
    this.initialGender = '',
    this.initialBirthDate = '',
    this.initialPhone = '',
    this.initialEmail = '',
  });

  final VoidCallback? onCancel;
  final void Function({
    required String firstName,
    required String lastName,
    required String gender,
    required String birthDate,
    required String phone,
    required String email,
  })? onSave;

  final String initialFirstName;
  final String initialLastName;
  final String initialGender;
  final String initialBirthDate;
  final String initialPhone;
  final String initialEmail;

  @override
  State<EditPersonalInformation> createState() =>
      _EditPersonalInformationState();
}

class _EditPersonalInformationState extends State<EditPersonalInformation> {
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late String _gender;
  late String _birthDate;
  late String _phone;
  late String _email;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController();
    _lastNameCtrl = TextEditingController();
    _gender = '';
    _birthDate = widget.initialBirthDate;
    _phone = '';
    _email = '';
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  void _handleSave() async {
    setState(() => _isSaving = true);
    try {
      final firstName = _firstNameCtrl.text.trim();
      final lastName = _lastNameCtrl.text.trim();
      final fullName =
          [firstName, lastName].where((s) => s.isNotEmpty).join(' ');

      // แปลง birthDate string dd/mm/yyyy (BE) → DateTime
      DateTime? birthDate;
      if (_birthDate.isNotEmpty) {
        final parts = _birthDate.split('/');
        if (parts.length == 3) {
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final yearBE = int.tryParse(parts[2]);
          if (day != null && month != null && yearBE != null) {
            birthDate = DateTime(yearBE - 543, month, day);
          }
        }
      }

      // แปลงเพศ TH → EN enum
      String? genderEn;
      switch (_gender) {
        case 'ชาย':
          genderEn = 'male';
          break;
        case 'หญิง':
          genderEn = 'female';
          break;
       case 'อื่นๆ':
         genderEn = 'other';
         break;
      }

      await ServiceLocator.user.updateProfile(
        fullName: fullName.isNotEmpty ? fullName : null,
        phone: _phone.isNotEmpty ? _phone : null,
        birthDate: birthDate,
        gender: genderEn,
      );

      // อัปเดตอีเมลแยก (Supabase auth + users table)
      if (_email.isNotEmpty) {
        await ServiceLocator.user.changeEmail(_email);
      }

      widget.onSave?.call(
        firstName: firstName,
        lastName: lastName,
        gender: _gender,
        birthDate: _birthDate,
        phone: _phone,
        email: _email,
      );
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
        return;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
        );
        return;
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
    if (mounted) Navigator.maybePop(context);
  }

  void _handleCancel() {
    widget.onCancel?.call();
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.settingsBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- AppBar: ยกเลิก / title / บันทึก ----
              _EditAppBar(
                onCancel: _handleCancel,
                onSave: _handleSave,
              ),

              // ---- Body ----
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.rs(16),
                    context.rs(16),
                    context.rs(16),
                    context.rs(32),
                  ),
                  child: Column(
                    children: [
                      // ---- ชื่อ + นามสกุล ----
                      _InputCard(
                        children: [
                          _TextFieldRow(
                            controller: _firstNameCtrl,
                            hintText: 'ชื่อจริง',
                          ),
                          _fieldDivider(context),
                          _TextFieldRow(
                            controller: _lastNameCtrl,
                            hintText: 'นามสกุล',
                          ),
                        ],
                      ),

                      SizedBox(height: context.rs(12)),

                      // ---- เพศ + วันเกิด ----
                      _InputCard(
                        children: [
                          _SelectRow(
                            label: 'เพศ',
                            value: _gender,
                            onTap: () => _showGenderPicker(context),
                          ),
                          _fieldDivider(context),
                          _SelectRow(
                            label: 'วันเกิด',
                            value: _birthDate,
                            onTap: () => _showDatePicker(context),
                          ),
                        ],
                      ),

                      SizedBox(height: context.rs(12)),

                      // ---- โทรศัพท์ + อีเมล ----
                      _InputCard(
                        children: [
                          _SelectRow(
                            label: 'โทรศัพท์',
                            value: _phone,
                            onTap: () => _showPhoneEditor(context),
                          ),
                          _fieldDivider(context),
                          _SelectRow(
                            label: 'อีเมล',
                            value: _email,
                            onTap: () => _showEmailEditor(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldDivider(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: context.rs(16)),
        child: const Divider(
          color: AppColors.inputBorder,
          height: 1,
          thickness: 1,
        ),
      );

  // ---- picker helpers ----
  void _showGenderPicker(BuildContext context) {
    Gender? initial;
    switch (_gender) {
      case 'หญิง':
        initial = Gender.female;
        break;
      case 'ชาย':
        initial = Gender.male;
        break;
      case 'อื่นๆ':
        initial = Gender.other;
        break;
    }
    showGenderBottomSheet(context, initial: initial).then((g) {
      if (g != null) {
        setState(() {
          switch (g) {
            case Gender.female:
              _gender = 'หญิง';
              break;
            case Gender.male:
              _gender = 'ชาย';
              break;
            case Gender.other:
              _gender = 'อื่นๆ';
              break;
          }
        });
      }
    });
  }

  void _showDatePicker(BuildContext context) async {
    DateTime? initial;
    final parts = _birthDate.split('/');
    if (parts.length == 3) {
      final d = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      final y = int.tryParse(parts[2]);
      if (d != null && m != null && y != null) {
        initial = DateTime(y - 543, m, d);
      }
    }
    final date = await showDateBottomSheet(
      context,
      initial: initial,
      maximumDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _birthDate = '${date.day}/${date.month}/${date.year + 543}';
      });
    }
  }

  void _showPhoneEditor(BuildContext context) {
    _showTextEditor(
      context: context,
      title: 'โทรศัพท์',
      initialValue: _phone,
      keyboardType: TextInputType.phone,
      onSave: (v) => setState(() => _phone = v),
    );
  }

  void _showEmailEditor(BuildContext context) {
    _showTextEditor(
      context: context,
      title: 'อีเมล',
      initialValue: _email,
      keyboardType: TextInputType.emailAddress,
      onSave: (v) => setState(() => _email = v),
    );
  }

  void _showTextEditor({
    required BuildContext context,
    required String title,
    required String initialValue,
    required TextInputType keyboardType,
    required void Function(String) onSave,
  }) {
    final ctrl = TextEditingController(text: initialValue);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.rs(16)),
        ),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.rs(24),
            context.rs(20),
            context.rs(24),
            context.rs(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: context.rs(12)),
              TextField(
                controller: ctrl,
                autofocus: true,
                keyboardType: keyboardType,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(13),
                  color: AppColors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.homeBackground,
                  hintText: title,
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(13),
                    color: AppColors.inputHint,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(context.rs(10)),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: context.rs(14),
                    vertical: context.rs(12),
                  ),
                ),
              ),
              SizedBox(height: context.rs(16)),
              SizedBox(
                width: double.infinity,
                height: context.rs(42),
                child: ElevatedButton(
                  onPressed: () {
                    onSave(ctrl.text.trim());
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.rs(30)),
                    ),
                  ),
                  child: Text(
                    'บันทึก',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _EditAppBar — ยกเลิก | แก้ไขข้อมูลส่วนตัว | บันทึก
// ============================================================
class _EditAppBar extends StatelessWidget {
  const _EditAppBar({required this.onCancel, required this.onSave});
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.rs(16),
        MediaQuery.of(context).size.height * 0.01,
        context.rs(16),
        context.rs(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ---- ยกเลิก ----
          GestureDetector(
            onTap: onCancel,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.rs(14),
                vertical: context.rs(6),
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(context.rs(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    offset: const Offset(0, 1),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Text(
                'ยกเลิก',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(13),
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
          ),

          // ---- title ----
          AppBarBack(title: 'แก้ไขข้อมูลส่วนตัว', showBack: false),

          // ---- บันทึก ----
          GestureDetector(
            onTap: onSave,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.rs(14),
                vertical: context.rs(6),
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(context.rs(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    offset: const Offset(0, 1),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Text(
                'บันทึก',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(13),
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _InputCard — กล่องกลุ่ม input มีขอบโค้ง
// ============================================================
class _InputCard extends StatelessWidget {
  const _InputCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

// ============================================================
// _TextFieldRow — ช่องกรอกข้อความ
// ============================================================
class _TextFieldRow extends StatelessWidget {
  const _TextFieldRow({
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(16),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: context.rs(13),
          color: AppColors.black,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(13),
            color: AppColors.inputHint,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: context.rs(12)),
        ),
      ),
    );
  }
}

// ============================================================
// _SelectRow — แถวที่กด > เพื่อเปิด picker
// ============================================================
class _SelectRow extends StatelessWidget {
  const _SelectRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.rs(16)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.rs(16),
          vertical: context.rs(14),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(13),
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
            SizedBox(width: context.rs(12)),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(12),
                  fontWeight: FontWeight.w400,
                  color: AppColors.textGray,
                ),
              ),
            ),
            SizedBox(width: context.rs(4)),
            Icon(
              Icons.chevron_right,
              size: context.rs(18),
              color: AppColors.textGray,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Gender picker (design)
// ============================================================
enum Gender { female, male, other }

Future<Gender?> showGenderBottomSheet(
  BuildContext context, {
  Gender? initial,
}) {
  return showModalBottomSheet<Gender>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => GenderBottomSheet(initial: initial),
  );
}

class GenderBottomSheet extends StatefulWidget {
  const GenderBottomSheet({super.key, this.initial});

  final Gender? initial;

  @override
  State<GenderBottomSheet> createState() => _GenderBottomSheetState();
}

class _GenderBottomSheetState extends State<GenderBottomSheet> {
  Gender? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
  }

  void _select(Gender g) {
    setState(() => _selected = g);
    Navigator.of(context).pop(g);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 368,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.registerButton,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(height: 42),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _GenderOption(
                  label: 'หญิง',
                  iconAsset: 'assets/images/profile/material-symbols_female-rounded.svg',
                  iconColor: const Color(0xFFE8617B),
                  circleColor: const Color(0xFFF8D3E3),
                  selected: _selected == Gender.female,
                  onTap: () => _select(Gender.female),
                ),
                const SizedBox(height: 13),
                _GenderOption(
                  label: 'ชาย',
                  iconAsset: 'assets/images/profile/material-symbols_male-rounded.svg',
                  iconColor: const Color(0xFF408AA6),
                  circleColor: const Color(0xFFCFE4EB),
                  selected: _selected == Gender.male,
                  onTap: () => _select(Gender.male),
                ),
                const SizedBox(height: 13),
                _GenderOption(
                  label: 'อื่นๆ',
                  iconAsset: 'assets/images/profile/streamline-plump_intersex-symbol-remix.svg', 
                  iconColor: const Color(0xFF504B8D),
                  circleColor: const Color(0xFFD6D3F4),
                  selected: _selected == Gender.other,
                  onTap: () => _select(Gender.other),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.label,
    this.iconAsset,
    required this.iconColor,
    required this.circleColor,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String? iconAsset;
  final Color iconColor;
  final Color circleColor;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.registerButton, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: circleColor,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(iconAsset!, width: 24, height: 24),
                ),
                const SizedBox(width: 15),
                Text(
                  label,
                  style: GoogleFonts.secularOne(
                    fontSize: 14,
                    height: 20 / 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Container(
              width: 19,
              height: 19,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.registerButton, width: 1),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          color: AppColors.purple,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}


// ============================================================
// Date picker (design)
// ============================================================
const _thaiMonths = [
  'มกราคม',
  'กุมภาพันธ์',
  'มีนาคม',
  'เมษายน',
  'พฤษภาคม',
  'มิถุนายน',
  'กรกฎาคม',
  'สิงหาคม',
  'กันยายน',
  'ตุลาคม',
  'พฤศจิกายน',
  'ธันวาคม',
];

Future<DateTime?> showDateBottomSheet(
  BuildContext context, {
  DateTime? initial,
  DateTime? minimumDate,
  DateTime? maximumDate,
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => DateBottomSheet(
      initial: initial,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
    ),
  );
}

class DateBottomSheet extends StatefulWidget {
  const DateBottomSheet({
    super.key,
    this.initial,
    this.minimumDate,
    this.maximumDate,
  });

  final DateTime? initial;
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  @override
  State<DateBottomSheet> createState() => _DateBottomSheetState();
}

class _DateBottomSheetState extends State<DateBottomSheet> {
  static const double _itemExtent = 35;
  static const Color _pillColor = Color(0xFFEAEAEA);
  static const Color _mutedText = Color(0xFFBDBDBD);

  late final int _firstYear;
  late final int _lastYear;
  late int _day;
  late int _month;
  late int _year;

  late final FixedExtentScrollController _dayC;
  late final FixedExtentScrollController _monthC;
  late final FixedExtentScrollController _yearC;

  int get _daysInMonth => DateUtils.getDaysInMonth(_year, _month);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _firstYear = widget.minimumDate?.year ?? 1900;
    _lastYear = widget.maximumDate?.year ?? now.year;

    final init = widget.initial ?? now;
    _year = init.year.clamp(_firstYear, _lastYear);
    _month = init.month;
    _day = init.day.clamp(1, DateUtils.getDaysInMonth(_year, _month));

    _dayC = FixedExtentScrollController(initialItem: _day - 1);
    _monthC = FixedExtentScrollController(initialItem: _month - 1);
    _yearC = FixedExtentScrollController(initialItem: _year - _firstYear);
  }

  @override
  void dispose() {
    _dayC.dispose();
    _monthC.dispose();
    _yearC.dispose();
    super.dispose();
  }

  void _clampDay() {
    final maxDays = _daysInMonth;
    if (_day > maxDays) {
      _day = maxDays;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_dayC.hasClients) _dayC.jumpToItem(_day - 1);
      });
    }
  }

  void _confirm() {
    var result = DateTime(_year, _month, _day);
    final min = widget.minimumDate;
    final max = widget.maximumDate;
    if (min != null && result.isBefore(min)) result = min;
    if (max != null && result.isAfter(max)) result = max;
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final yearCount = _lastYear - _firstYear + 1;

    return Container(
      width: double.infinity,
      height: 268,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 52,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 24),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _confirm,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'ตกลง',
                      style: GoogleFonts.prompt(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: _itemExtent * 5,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: 36,
                    margin: const EdgeInsets.symmetric(horizontal: 36),
                    decoration: BoxDecoration(
                      color: _pillColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: Row(
                    children: [
                      Expanded(
                        child: _wheel(
                          controller: _dayC,
                          count: _daysInMonth,
                          label: (i) => '${i + 1}',
                          selected: _day - 1,
                          onChanged: (i) => setState(() => _day = i + 1),
                        ),
                      ),
                      Expanded(
                        child: _wheel(
                          controller: _monthC,
                          count: 12,
                          label: (i) => _thaiMonths[i],
                          selected: _month - 1,
                          onChanged: (i) => setState(() {
                            _month = i + 1;
                            _clampDay();
                          }),
                        ),
                      ),
                      Expanded(
                        child: _wheel(
                          controller: _yearC,
                          count: yearCount,
                          label: (i) => '${_firstYear + i + 543}',
                          selected: _year - _firstYear,
                          onChanged: (i) => setState(() {
                            _year = _firstYear + i;
                            _clampDay();
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _wheel({
    required FixedExtentScrollController controller,
    required int count,
    required String Function(int) label,
    required int selected,
    required ValueChanged<int> onChanged,
  }) {
    return CupertinoPicker.builder(
      scrollController: controller,
      itemExtent: _itemExtent,
      diameterRatio: 100,
      squeeze: 1.0,
      useMagnifier: false,
      backgroundColor: Colors.transparent,
      selectionOverlay: const SizedBox.shrink(),
      onSelectedItemChanged: onChanged,
      childCount: count,
      itemBuilder: (context, i) {
        final isSelected = i == selected;
        return Center(
          child: Text(
            label(i),
            style: GoogleFonts.prompt(
              fontSize: 14,
              color: isSelected ? Colors.black : _mutedText,
            ),
          ),
        );
      },
    );
  }
}
