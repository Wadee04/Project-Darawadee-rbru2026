import 'dart:io';

import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// ClinicDataPage — หน้ากรอกข้อมูลคลินิก
// ============================================================
class ClinicDataPage extends StatefulWidget {
  const ClinicDataPage({
    super.key,
    this.onBack,
    this.onSubmit,
  });

  final VoidCallback? onBack;
  final void Function({
    required String clinicName,
    required String registrationNumber,
    required String operatingHours,
    required String address,
    required String province,
    required String district,
    required String zipCode,
    required List<File> licenseFiles,
    required List<File> addressFiles,
    required List<File> logoFiles,
  })? onSubmit;

  @override
  State<ClinicDataPage> createState() => _ClinicDataPageState();
}

class _ClinicDataPageState extends State<ClinicDataPage> {
  final _clinicNameCtrl = TextEditingController();
  final _regNumberCtrl = TextEditingController();
  final _hoursCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _zipCtrl = TextEditingController();

  String _province = '';
  String _district = '';

  List<File> _licenseFiles = [];
  List<File> _addressFiles = [];
  List<File> _logoFiles = [];

  bool get _canSubmit =>
      _clinicNameCtrl.text.trim().isNotEmpty &&
      _regNumberCtrl.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    for (final c in [_clinicNameCtrl, _regNumberCtrl, _hoursCtrl, _addressCtrl, _zipCtrl]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _clinicNameCtrl.dispose();
    _regNumberCtrl.dispose();
    _hoursCtrl.dispose();
    _addressCtrl.dispose();
    _zipCtrl.dispose();
    super.dispose();
  }

  void _pickFile(List<File> list, void Function(List<File>) onUpdate) {
    // placeholder — ใช้ image_picker ในโปรเจกต์จริง
    _showPickerSheet(onPicked: (file) {
      onUpdate([...list, file]);
    });
  }

  void _showPickerSheet({required void Function(File) onPicked}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.rs(16)),
        ),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          context.rs(24),
          context.rs(20),
          context.rs(24),
          context.rs(32),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: context.rs(36),
              height: context.rs(4),
              margin: EdgeInsets.only(bottom: context.rs(16)),
              decoration: BoxDecoration(
                color: AppColors.inputBorder,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Icon(Icons.upload_file_outlined, size: context.rs(40), color: AppColors.purple),
            SizedBox(height: context.rs(10)),
            Text(
              'กรุณาเพิ่ม package image_picker\nเพื่อใช้งานฟีเจอร์นี้',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(12),
                color: AppColors.textGray,
              ),
            ),
            SizedBox(height: context.rs(16)),
            SizedBox(
              width: double.infinity,
              height: context.rs(40),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.rs(30)),
                  ),
                ),
                child: const Text('ตกลง', style: TextStyle(fontFamily: 'Inter')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (!_canSubmit) return;
    widget.onSubmit?.call(
      clinicName: _clinicNameCtrl.text.trim(),
      registrationNumber: _regNumberCtrl.text.trim(),
      operatingHours: _hoursCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      province: _province,
      district: _district,
      zipCode: _zipCtrl.text.trim(),
      licenseFiles: _licenseFiles,
      addressFiles: _addressFiles,
      logoFiles: _logoFiles,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFFFFFFF), Color(0xFFC5DEE8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- Back button ----
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: widget.onBack ?? () => Navigator.maybePop(context),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.rs(16),
                      MediaQuery.of(context).size.height * 0.01,
                      context.rs(16),
                      0,
                    ),
                    child: Icon(Icons.chevron_left, size: context.rs(28), color: AppColors.black),
                  ),
                ),
              ),

              // ---- Body ----
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.rs(24),
                    context.rs(16),
                    context.rs(24),
                    context.rs(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---- Header ----
                      _ClinicHeader(),

                      SizedBox(height: context.rs(24)),

                      // ---- ชื่อคลินิก ----
                      _FieldLabel(label: 'ชื่อคลินิก'),
                      SizedBox(height: context.rs(8)),
                      _InputField(controller: _clinicNameCtrl, hintText: 'กรอกชื่อคลินิก'),

                      SizedBox(height: context.rs(14)),

                      // ---- เลขทะเบียนคลินิก ----
                      _FieldLabel(label: 'เลขทะเบียนคลินิก'),
                      SizedBox(height: context.rs(8)),
                      _InputField(controller: _regNumberCtrl, hintText: 'กรอกเลขทะเบียนคลินิก'),

                      SizedBox(height: context.rs(14)),

                      // ---- เวลาทำการที่ให้บริการ ----
                      _FieldLabel(label: 'เวลาทำการที่ให้บริการ'),
                      SizedBox(height: context.rs(8)),
                      _InputField(
                        controller: _hoursCtrl,
                        hintText: 'เช่น จันทร์ - ศุกร์ 09:00 - 18:00',
                      ),

                      SizedBox(height: context.rs(14)),

                      // ---- ที่อยู่คลินิก ----
                      _FieldLabel(label: 'ที่อยู่คลินิก'),
                      SizedBox(height: context.rs(8)),
                      _InputField(
                        controller: _addressCtrl,
                        hintText: 'บ้านเลขที่ ถนน ตำบล/แขวง',
                        maxLines: 2,
                      ),

                      SizedBox(height: context.rs(14)),

                      // ---- จังหวัด + เขต/อำเภอ ----
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _FieldLabel(label: 'จังหวัด'),
                                SizedBox(height: context.rs(8)),
                                _DropdownField(
                                  hint: 'จังหวัด',
                                  value: _province.isEmpty ? null : _province,
                                  items: _provinces,
                                  onChanged: (v) => setState(() => _province = v ?? ''),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: context.rs(10)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _FieldLabel(label: 'เขต / อำเภอ'),
                                SizedBox(height: context.rs(8)),
                                _DropdownField(
                                  hint: 'เขต - อำเภอ',
                                  value: _district.isEmpty ? null : _district,
                                  items: _districts,
                                  onChanged: (v) => setState(() => _district = v ?? ''),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: context.rs(14)),

                      // ---- รหัสไปรษณีย์ ----
                      _FieldLabel(label: 'รหัสไปรษณีย์'),
                      SizedBox(height: context.rs(8)),
                      _InputField(
                        controller: _zipCtrl,
                        hintText: 'กรอกรหัสไปรษณีย์',
                        keyboardType: TextInputType.number,
                      ),

                      SizedBox(height: context.rs(20)),

                      // ---- ใบอนุญาตประกอบกิจการ ----
                      _UploadSection(
                        label: 'ใบอนุญาตให้ประกอบกิจการสถานพยาบาลตามกฎหมาย?',
                        files: _licenseFiles,
                        onAdd: () => _pickFile(
                          _licenseFiles,
                          (f) => setState(() => _licenseFiles = f),
                        ),
                        onRemove: (i) => setState(
                          () => _licenseFiles = [..._licenseFiles]..removeAt(i),
                        ),
                      ),

                      SizedBox(height: context.rs(16)),

                      // ---- เอกสารแสดงสถานที่ตั้ง ----
                      _UploadSection(
                        label: 'ใบอนุญาตให้ประกอบกิจการสถานพยาบาลตามกฎหมาย 500',
                        files: _addressFiles,
                        onAdd: () => _pickFile(
                          _addressFiles,
                          (f) => setState(() => _addressFiles = f),
                        ),
                        onRemove: (i) => setState(
                          () => _addressFiles = [..._addressFiles]..removeAt(i),
                        ),
                      ),

                      SizedBox(height: context.rs(16)),

                      // ---- โลโก้คลินิก ----
                      _UploadSection(
                        label: 'โลโก้คลินิก',
                        files: _logoFiles,
                        onAdd: () => _pickFile(
                          _logoFiles,
                          (f) => setState(() => _logoFiles = f),
                        ),
                        onRemove: (i) => setState(
                          () => _logoFiles = [..._logoFiles]..removeAt(i),
                        ),
                      ),

                      SizedBox(height: context.rs(16)),

                      // ---- รูปถ่ายคลินิก ----
                      _UploadSection(
                        label: 'รูปถ่ายคลินิก',
                        files: const [],
                        onAdd: () {},
                        onRemove: (_) {},
                      ),

                      SizedBox(height: context.rs(28)),

                      // ---- ปุ่มถัดไป ----
                      SizedBox(
                        width: double.infinity,
                        height: context.rs(46),
                        child: ElevatedButton(
                          onPressed: _canSubmit ? _handleSubmit : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.purple,
                            foregroundColor: AppColors.white,
                            disabledBackgroundColor: AppColors.registerButton,
                            disabledForegroundColor: AppColors.textGray,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(context.rs(30)),
                            ),
                          ),
                          child: Text(
                            'ถัดไป',
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
            ],
          ),
        ),
      ),
    );
  }

  static const List<String> _provinces = [
    'กรุงเทพมหานคร', 'จันทบุรี', 'ชลบุรี', 'ระยอง', 'ตราด',
    'เชียงใหม่', 'เชียงราย', 'ขอนแก่น', 'นครราชสีมา', 'สงขลา',
  ];

  static const List<String> _districts = [
    'เมือง', 'ขลุง', 'ท่าใหม่', 'โป่งน้ำร้อน', 'มะขาม',
    'แหลมสิงห์', 'สอยดาว', 'แก่งหางแมว', 'นายายอาม', 'เขาคิชฌกูฏ',
  ];
}

// ============================================================
// _ClinicHeader — icon shield + title + subtitle
// ============================================================
class _ClinicHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: context.rs(48),
          height: context.rs(48),
          decoration: BoxDecoration(
            color: AppColors.purpleLight,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.shield_outlined, size: context.rs(26), color: AppColors.purple),
        ),
        SizedBox(width: context.rs(14)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ข้อมูลคลินิก',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(18),
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: context.rs(4)),
              Text(
                'กรุณากรอกข้อมูลคลินิกเพื่อลงทะเบียนระบบ',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(12),
                  fontWeight: FontWeight.w400,
                  color: AppColors.textGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// _FieldLabel
// ============================================================
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: context.rs(13),
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),
    );
  }
}

// ============================================================
// _InputField — ช่องกรอกข้อความ
// ============================================================
class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(14)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.rs(16)),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(13), color: AppColors.black),
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
            contentPadding: EdgeInsets.symmetric(vertical: context.rs(14)),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _DropdownField — dropdown จังหวัด/เขต
// ============================================================
class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(14)),
      ),
      padding: EdgeInsets.symmetric(horizontal: context.rs(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(12),
              color: AppColors.inputHint,
            ),
          ),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, size: context.rs(18), color: AppColors.textGray),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(12),
            color: AppColors.black,
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ============================================================
// _UploadSection — กล่องอัปโหลดไฟล์
// ============================================================
class _UploadSection extends StatelessWidget {
  const _UploadSection({
    required this.label,
    required this.files,
    required this.onAdd,
    required this.onRemove,
  });

  final String label;
  final List<File> files;
  final VoidCallback onAdd;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(12),
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: context.rs(8)),

        // ---- แสดงไฟล์ที่เพิ่มแล้ว ----
        ...files.asMap().entries.map((e) => _FileChip(
              path: e.value.path,
              onRemove: () => onRemove(e.key),
            )),

        // ---- ปุ่มเพิ่มไฟล์ ----
        GestureDetector(
          onTap: onAdd,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: context.rs(14),
              horizontal: context.rs(16),
            ),
            decoration: BoxDecoration(
              color: AppColors.homeBackground,
              borderRadius: BorderRadius.circular(context.rs(12)),
              border: Border.all(
                color: AppColors.inputBorder,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.add, size: context.rs(16), color: AppColors.purple),
                SizedBox(width: context.rs(8)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'อัปโหลด',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(12),
                          fontWeight: FontWeight.w500,
                          color: AppColors.purple,
                        ),
                      ),
                      Text(
                        'รองรับไฟล์ JPG, PNG, PDF (ไม่เกิน 5mb)',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(10),
                          color: AppColors.inputHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// _FileChip — แสดงไฟล์ที่อัปโหลดแล้ว
// ============================================================
class _FileChip extends StatelessWidget {
  const _FileChip({required this.path, required this.onRemove});
  final String path;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final name = path.split('/').last;
    return Container(
      margin: EdgeInsets.only(bottom: context.rs(6)),
      padding: EdgeInsets.symmetric(
        horizontal: context.rs(12),
        vertical: context.rs(8),
      ),
      decoration: BoxDecoration(
        color: AppColors.purpleLight,
        borderRadius: BorderRadius.circular(context.rs(10)),
      ),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file_outlined, size: context.rs(16), color: AppColors.purple),
          SizedBox(width: context.rs(8)),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(12),
                color: AppColors.purple,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: context.rs(14), color: AppColors.purple),
          ),
        ],
      ),
    );
  }
}
