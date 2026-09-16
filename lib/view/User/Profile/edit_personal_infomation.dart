import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _firstNameCtrl =
        TextEditingController(text: widget.initialFirstName);
    _lastNameCtrl =
        TextEditingController(text: widget.initialLastName);
    _gender = widget.initialGender;
    _birthDate = widget.initialBirthDate;
    _phone = widget.initialPhone;
    _email = widget.initialEmail;
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  void _handleSave() {
    widget.onSave?.call(
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      gender: _gender,
      birthDate: _birthDate,
      phone: _phone,
      email: _email,
    );
    Navigator.maybePop(context);
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
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFC5DEE8),
            ],
          ),
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
        padding: EdgeInsets.symmetric(horizontal: context.rs(0)),
        child: const Divider(
          color: AppColors.inputBorder,
          height: 1,
          thickness: 0.5,
        ),
      );

  // ---- picker helpers ----
  void _showGenderPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.rs(16)),
        ),
      ),
      builder: (_) => _GenderPickerSheet(
        selected: _gender,
        onSelected: (v) {
          setState(() => _gender = v);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('th', 'TH'),
    ).then((date) {
      if (date != null) {
        setState(() {
          _birthDate =
              '${date.day}/${date.month}/${date.year + 543}';
        });
      }
    });
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
                color: AppColors.homeBackground,
                borderRadius: BorderRadius.circular(context.rs(20)),
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
          Text(
            'แก้ไขข้อมูลส่วนตัว',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(14),
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),

          // ---- บันทึก ----
          GestureDetector(
            onTap: onSave,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.rs(14),
                vertical: context.rs(6),
              ),
              decoration: BoxDecoration(
                color: AppColors.homeBackground,
                borderRadius: BorderRadius.circular(context.rs(20)),
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
        color: AppColors.homeBackground,
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
        vertical: context.rs(4),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(13),
                      fontWeight: FontWeight.w400,
                      color: value.isEmpty
                          ? AppColors.inputHint
                          : AppColors.black,
                    ),
                  ),
                  if (value.isNotEmpty) ...[
                    SizedBox(height: context.rs(2)),
                    Text(
                      value,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(12),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ],
              ),
            ),
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
// _GenderPickerSheet — bottom sheet เลือกเพศ
// ============================================================
class _GenderPickerSheet extends StatelessWidget {
  const _GenderPickerSheet({
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final void Function(String) onSelected;

  static const List<String> _options = ['ชาย', 'หญิง', 'ไม่ระบุ'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.rs(24),
        context.rs(20),
        context.rs(24),
        context.rs(32),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: context.rs(36),
            height: context.rs(4),
            margin: EdgeInsets.only(bottom: context.rs(16)),
            decoration: BoxDecoration(
              color: AppColors.inputBorder,
              borderRadius: BorderRadius.circular(context.rs(99)),
            ),
          ),
          Text(
            'เลือกเพศ',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(14),
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: context.rs(16)),
          ..._options.map(
            (opt) => ListTile(
              title: Text(
                opt,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(14),
                  color: AppColors.black,
                ),
              ),
              trailing: selected == opt
                  ? Icon(Icons.check, color: AppColors.purple, size: context.rs(18))
                  : null,
              onTap: () => onSelected(opt),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.rs(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
