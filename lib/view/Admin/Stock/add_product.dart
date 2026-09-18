import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/supabase_stock_service.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// AddProductPage — หน้าเพิ่มรายการสต็อกด้วยตนเอง
// ============================================================
class AddProductPage extends StatefulWidget {
  const AddProductPage({
    super.key,
    this.onBack,
    this.onSave,
  });

  final VoidCallback? onBack;
  final void Function({
    required String name,
    required String sku,
    required int qty,
    required String unit,
    required String note,
  })? onSave;

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _nameCtrl = TextEditingController();
  final _skuCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController(text: '0');
  final _noteCtrl = TextEditingController();

  String _unit = 'ชิ้น';
  bool _isSaving = false;

  static const List<String> _units = ['ชิ้น', 'กล่อง', 'แผ่น', 'ขวด', 'หลอด', 'ถุง', 'อัน'];

  bool get _canSave =>
      _nameCtrl.text.trim().isNotEmpty && _skuCtrl.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(() => setState(() {}));
    _skuCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _qtyCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_canSave) return;
    widget.onSave?.call(
      name: _nameCtrl.text.trim(),
      sku: _skuCtrl.text.trim(),
      qty: int.tryParse(_qtyCtrl.text) ?? 0,
      unit: _unit,
      note: _noteCtrl.text.trim(),
    );
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
            colors: [Color(0xFFFFFFFF), Color(0xFFC5DEE8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- AppBar ----
              _AppBar(
                title: 'เพิ่มรายการสต็อกด้วยตนเอง',
                onBack: widget.onBack,
              ),

              // ---- Body ----
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.rs(20),
                    context.rs(20),
                    context.rs(20),
                    context.rs(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---- ชื่อสินค้า ----
                      _FieldLabel(label: 'ชื่อสินค้า'),
                      SizedBox(height: context.rs(8)),
                      _InputField(
                        controller: _nameCtrl,
                        hintText: 'ชื่อสินค้า',
                      ),

                      SizedBox(height: context.rs(16)),

                      // ---- รหัสสินค้า ----
                      _FieldLabel(label: 'รหัสสินค้า'),
                      SizedBox(height: context.rs(8)),
                      _InputField(
                        controller: _skuCtrl,
                        hintText: 'เช่น SKU-10234',
                        keyboardType: TextInputType.text,
                      ),

                      SizedBox(height: context.rs(16)),

                      // ---- จำนวน + หน่วยนับ ----
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // จำนวน
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _FieldLabel(label: 'จำนวน'),
                                SizedBox(height: context.rs(8)),
                                _InputField(
                                  controller: _qtyCtrl,
                                  hintText: '0',
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: context.rs(12)),

                          // หน่วยนับ
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _FieldLabel(label: 'หน่วยนับ'),
                                SizedBox(height: context.rs(8)),
                                _UnitDropdown(
                                  value: _unit,
                                  items: _units,
                                  onChanged: (v) =>
                                      setState(() => _unit = v ?? _unit),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: context.rs(16)),

                      // ---- หมายเหตุ ----
                      _FieldLabel(label: 'หมายเหตุ (ถ้ามี)'),
                      SizedBox(height: context.rs(8)),
                      _NoteField(controller: _noteCtrl),

                      SizedBox(height: context.rs(28)),

                      // ---- ปุ่มบันทึก ----
                      SizedBox(
                        width: double.infinity,
                        height: context.rs(46),
                        child: ElevatedButton.icon(
                          onPressed: _canSave ? _handleSave : null,
                          icon: Icon(Icons.check, size: context.rs(16)),
                          label: Text(
                            'บันทึก',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: context.rs(14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.purple,
                            foregroundColor: AppColors.white,
                            disabledBackgroundColor: AppColors.registerButton,
                            disabledForegroundColor: AppColors.textGray,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(context.rs(30)),
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
}

// ============================================================
// _AppBar — back + title
// ============================================================
class _AppBar extends StatelessWidget {
  const _AppBar({required this.title, this.onBack});
  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.rs(8),
        MediaQuery.of(context).size.height * 0.01,
        context.rs(20),
        context.rs(8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onBack ?? () => Navigator.maybePop(context),
              child: Padding(
                padding: EdgeInsets.all(context.rs(8)),
                child: Icon(
                  Icons.chevron_left,
                  size: context.rs(28),
                  color: AppColors.black,
                ),
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(14),
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ],
      ),
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
// _InputField — ช่องกรอกข้อมูล
// ============================================================
class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(12)),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.rs(14)),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
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
            contentPadding: EdgeInsets.symmetric(vertical: context.rs(13)),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _UnitDropdown — dropdown หน่วยนับ
// ============================================================
class _UnitDropdown extends StatelessWidget {
  const _UnitDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(12)),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: context.rs(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: context.rs(18),
            color: AppColors.textGray,
          ),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(13),
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
// _NoteField — ช่องกรอกหมายเหตุ (multi-line)
// ============================================================
class _NoteField extends StatelessWidget {
  const _NoteField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(12)),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.rs(14)),
        child: TextField(
          controller: controller,
          maxLines: 5,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(13),
            color: AppColors.black,
          ),
          decoration: InputDecoration(
            hintText: 'รายละเอียดเพิ่มเติม',
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
      ),
    );
  }
}
