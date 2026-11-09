import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/service_locator.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// PinPage — หน้าสร้างรหัส PIN 6 หลัก
// ============================================================
class PinPage extends StatefulWidget {
  const PinPage({
    super.key,
    this.onBack,
    this.onComplete,
    this.title = 'สร้างรหัสผ่าน',
  });

  final VoidCallback? onBack;
  final void Function(String pin)? onComplete;
  final String title;

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  static const int _pinLength = 6;
  String _pin = '';
  bool _isSaving = false;

  Future<void> _savePin(String pin) async {
    setState(() => _isSaving = true);
    try {
      await ServiceLocator.user.togglePin(enabled: true, pinHash: pin);
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (_) {}
    finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _onKeyTap(String key) {
    if (_pin.length >= _pinLength) return;
    setState(() => _pin += key);
    if (_pin.length == _pinLength) {
      // หน่วงเล็กน้อยให้เห็น dot เต็มก่อน callback
      Future.delayed(const Duration(milliseconds: 150), () async {
        await _savePin(_pin);
        widget.onComplete?.call(_pin);
      });
    }
  }

  void _onBackspace() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
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
                    child: Icon(
                      Icons.chevron_left,
                      size: context.rs(28),
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ---- DentBook logo ----
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(28),
                          fontWeight: FontWeight.w800,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Dent',
                            style: TextStyle(color: AppColors.purple),
                          ),
                          TextSpan(
                            text: 'Book',
                            style: TextStyle(color: AppColors.orange),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: context.rs(8)),

                    // ---- subtitle ----
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: context.rs(14),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textGray,
                      ),
                    ),

                    SizedBox(height: context.rs(24)),

                    // ---- PIN dots ----
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pinLength, (i) {
                        final filled = i < _pin.length;
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.rs(7),
                          ),
                          child: Container(
                            width: context.rs(14),
                            height: context.rs(14),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: filled
                                  ? AppColors.purple
                                  : Colors.transparent,
                              border: Border.all(
                                color: AppColors.inputBorder,
                                width: 1.5,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: context.rs(40)),

                    // ---- Numpad ----
                    _Numpad(
                      onKeyTap: _onKeyTap,
                      onBackspace: _onBackspace,
                    ),
                  ],
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
// _Numpad — keyboard ตัวเลข 1-9, 0, backspace
// ============================================================
class _Numpad extends StatelessWidget {
  const _Numpad({
    required this.onKeyTap,
    required this.onBackspace,
  });

  final void Function(String) onKeyTap;
  final VoidCallback onBackspace;

  static const List<List<String?>> _layout = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    [null, '0', 'del'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _layout.map((row) {
        return Padding(
          padding: EdgeInsets.only(bottom: context.rs(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((key) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: context.rs(14)),
                child: _buildKey(context, key),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKey(BuildContext context, String? key) {
    final double size = context.rs(64);

    // ---- empty cell ----
    if (key == null) {
      return SizedBox(width: size, height: size);
    }

    // ---- backspace ----
    if (key == 'del') {
      return GestureDetector(
        onTap: onBackspace,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Icon(
              Icons.backspace_outlined,
              size: context.rs(22),
              color: AppColors.black,
            ),
          ),
        ),
      );
    }

    // ---- number key ----
    return GestureDetector(
      onTap: () => onKeyTap(key),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(
            color: AppColors.inputBorder,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            key,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(20),
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
