import 'package:flutter/material.dart';

import '../../../mock/models.dart';
import '../../../services/admin/dentist_room_service.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

/// หน้าจัดการทันตแพทย์และห้องตรวจตามดีไซน์ที่แนบ
class DentistRoomPage extends StatefulWidget {
  const DentistRoomPage({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  State<DentistRoomPage> createState() => _DentistRoomPageState();
}

class _DentistRoomPageState extends State<DentistRoomPage> {
  final DentistRoomService _service = DentistRoomService.instance;

  bool _loading = true;
  String? _error;
  final Set<String> _busyIds = <String>{};
  List<DoctorModel> _doctors = const [];
  List<AdminRoom> _rooms = const [];

  static const List<Color> _avatarColors = [
    Color(0xFFC1F1CE),
    Color(0xFFC5E4F8),
    Color(0xFFF4C7D9),
  ];

  static const List<Color> _avatarTextColors = [
    Color(0xFF347F4A),
    Color(0xFF38688B),
    Color(0xFF8B3F63),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait<dynamic>([
        _service.getDoctors(),
        _service.getRooms(),
      ]);
      if (!mounted) return;
      setState(() {
        _doctors = results[0] as List<DoctorModel>;
        _rooms = results[1] as List<AdminRoom>;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = _friendlyError(error);
      });
    }
  }

  String _friendlyError(Object error) {
    final text = error.toString();
    if (text.contains('rooms') || text.contains('admin_id')) {
      return 'กรุณารันไฟล์ supabase_dentist_room.sql ใน Supabase ก่อนใช้งาน';
    }
    return text.replaceFirst('Bad state: ', '');
  }

  Future<void> _toggleDoctor(DoctorModel doctor, bool value) async {
    setState(() => _busyIds.add(doctor.id));
    try {
      final updated = await _service.setDoctorAvailable(
        doctorId: doctor.id,
        available: value,
      );
      if (!mounted) return;
      setState(() {
        final index = _doctors.indexWhere((item) => item.id == doctor.id);
        if (index >= 0) {
          _doctors = [..._doctors]..[index] = updated;
        }
      });
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => _busyIds.remove(doctor.id));
    }
  }

  Future<void> _toggleRoom(AdminRoom room, bool value) async {
    setState(() => _busyIds.add(room.id));
    try {
      final updated = await _service.setRoomActive(
        roomId: room.id,
        isActive: value,
      );
      if (!mounted) return;
      setState(() {
        final index = _rooms.indexWhere((item) => item.id == room.id);
        if (index >= 0) {
          _rooms = [..._rooms]..[index] = updated;
        }
      });
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => _busyIds.remove(room.id));
    }
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('บันทึกไม่สำเร็จ: $error')),
    );
  }

  Future<void> _showDoctorForm({DoctorModel? doctor}) async {
    final nameController = TextEditingController(text: doctor?.fullName ?? '');
    final specialtyController =
        TextEditingController(text: doctor?.specialty ?? '');

    final data = await showDialog<_FormData>(
      context: context,
      builder: (dialogContext) => _ResourceDialog(
        title: doctor == null ? 'เพิ่มทันตแพทย์' : 'แก้ไขทันตแพทย์',
        nameLabel: 'ชื่อทันตแพทย์',
        nameHint: 'เช่น ทพ.กมล เชี่ยวชาญ',
        specialtyLabel: 'ความเชี่ยวชาญ',
        specialtyHint: 'เช่น ทันตกรรมทั่วไป',
        nameController: nameController,
        specialtyController: specialtyController,
        onSubmit: () {
          final name = nameController.text.trim();
          final specialty = specialtyController.text.trim();
          if (name.isEmpty || specialty.isEmpty) return;
          Navigator.pop(
            dialogContext,
            _FormData(name: name, specialty: specialty),
          );
        },
      ),
    );
    nameController.dispose();
    specialtyController.dispose();
    if (data == null || !mounted) return;

    try {
      if (doctor == null) {
        final added = await _service.addDoctor(
          fullName: data.name,
          specialty: data.specialty,
        );
        if (mounted) setState(() => _doctors = [..._doctors, added]);
      } else {
        final updated = await _service.updateDoctor(
          doctorId: doctor.id,
          fullName: data.name,
          specialty: data.specialty,
        );
        if (mounted) {
          setState(() {
            final index = _doctors.indexWhere((item) => item.id == doctor.id);
            if (index >= 0) _doctors = [..._doctors]..[index] = updated;
          });
        }
      }
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _showRoomForm({AdminRoom? room}) async {
    final nameController = TextEditingController(text: room?.name ?? '');
    final specialtyController =
        TextEditingController(text: room?.specialty ?? '');

    final data = await showDialog<_FormData>(
      context: context,
      builder: (dialogContext) => _ResourceDialog(
        title: room == null ? 'เพิ่มห้องตรวจ' : 'แก้ไขห้องตรวจ',
        nameLabel: 'ชื่อห้องตรวจ',
        nameHint: 'เช่น ห้อง 1',
        specialtyLabel: 'ประเภทการรักษา',
        specialtyHint: 'เช่น ทันตกรรมทั่วไป',
        nameController: nameController,
        specialtyController: specialtyController,
        onSubmit: () {
          final name = nameController.text.trim();
          final specialty = specialtyController.text.trim();
          if (name.isEmpty || specialty.isEmpty) return;
          Navigator.pop(
            dialogContext,
            _FormData(name: name, specialty: specialty),
          );
        },
      ),
    );
    nameController.dispose();
    specialtyController.dispose();
    if (data == null || !mounted) return;

    try {
      if (room == null) {
        final added = await _service.addRoom(
          name: data.name,
          specialty: data.specialty,
        );
        if (mounted) setState(() => _rooms = [..._rooms, added]);
      } else {
        final updated = await _service.updateRoom(
          roomId: room.id,
          name: data.name,
          specialty: data.specialty,
        );
        if (mounted) {
          setState(() {
            final index = _rooms.indexWhere((item) => item.id == room.id);
            if (index >= 0) _rooms = [..._rooms]..[index] = updated;
          });
        }
      }
    } catch (error) {
      _showError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _Header(onBack: widget.onBack),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? _ErrorState(message: _error!, onRetry: _load)
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.fromLTRB(
                              context.rs(20),
                              context.rs(4),
                              context.rs(20),
                              context.rs(30),
                            ),
                            children: [
                              _SectionHeader(
                                title: 'ทันตแพทย์ • ${_doctors.length} คน',
                                onAdd: () => _showDoctorForm(),
                              ),
                              SizedBox(height: context.rs(8)),
                              if (_doctors.isEmpty)
                                const _EmptyRow(label: 'ยังไม่มีทันตแพทย์')
                              else
                                ..._doctors.asMap().entries.map(
                                      (entry) => Padding(
                                        padding: EdgeInsets.only(
                                            bottom: context.rs(10)),
                                        child: _ResourceCard(
                                          avatarLabel:
                                              _initials(entry.value.fullName),
                                          avatarColor: _avatarColors[
                                              entry.key % _avatarColors.length],
                                          avatarTextColor: _avatarTextColors[
                                              entry.key % _avatarTextColors.length],
                                          title: entry.value.fullName,
                                          subtitle: entry.value.specialty ?? '-',
                                          enabled: entry.value.available,
                                          busy: _busyIds.contains(entry.value.id),
                                          onTap: () => _showDoctorForm(
                                              doctor: entry.value),
                                          onToggle: (value) =>
                                              _toggleDoctor(entry.value, value),
                                        ),
                                      ),
                                    ),
                              SizedBox(height: context.rs(2)),
                              _SectionHeader(
                                title: 'ห้องตรวจ• ${_rooms.length} คน',
                                onAdd: () => _showRoomForm(),
                              ),
                              SizedBox(height: context.rs(8)),
                              if (_rooms.isEmpty)
                                const _EmptyRow(label: 'ยังไม่มีห้องตรวจ')
                              else
                                ..._rooms.asMap().entries.map(
                                      (entry) => Padding(
                                        padding: EdgeInsets.only(
                                            bottom: context.rs(10)),
                                        child: _ResourceCard(
                                          avatarLabel: _roomNumber(
                                              entry.value.name, entry.key + 1),
                                          avatarColor: _avatarColors[
                                              entry.key % _avatarColors.length],
                                          avatarTextColor: _avatarTextColors[
                                              entry.key % _avatarTextColors.length],
                                          title: entry.value.name,
                                          subtitle: entry.value.specialty,
                                          enabled: entry.value.isActive,
                                          busy: _busyIds.contains(entry.value.id),
                                          onTap: () =>
                                              _showRoomForm(room: entry.value),
                                          onToggle: (value) =>
                                              _toggleRoom(entry.value, value),
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
    );
  }

  String _initials(String fullName) {
    final value = fullName
        .replaceFirst(RegExp(r'^(ทพญ\.|ทพ\.|ทันตแพทย์)\s*'), '')
        .trim();
    if (value.isEmpty) return '-';
    final firstWord = value.split(RegExp(r'\s+')).first;
    final runes = firstWord.runes.toList();
    return String.fromCharCodes(runes.take(2));
  }

  String _roomNumber(String name, int fallback) {
    final match = RegExp(r'\d+').firstMatch(name);
    return match?.group(0) ?? '$fallback';
  }
}

/// Alias แบบสั้นสำหรับจุดเรียกที่ต้องการชื่อเดียวกับไฟล์
class DentistRoom extends DentistRoomPage {
  const DentistRoom({super.key, super.onBack});
}

class _Header extends StatelessWidget {
  const _Header({this.onBack});
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.rs(8),
        context.rs(6),
        context.rs(8),
        context.rs(10),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBack ?? () => Navigator.maybePop(context),
              icon: Icon(
                Icons.chevron_left,
                size: context.rs(28),
                color: AppColors.black,
              ),
            ),
          ),
          Text(
            'ทันตแพทย์และห้องตรวจ',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(15),
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onAdd});
  final String title;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.rs(32),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(13),
                fontWeight: FontWeight.w500,
                color: AppColors.textGray,
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onAdd,
            icon: Icon(
              Icons.add,
              size: context.rs(26),
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  const _ResourceCard({
    required this.avatarLabel,
    required this.avatarColor,
    required this.avatarTextColor,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.busy,
    required this.onTap,
    required this.onToggle,
  });

  final String avatarLabel;
  final Color avatarColor;
  final Color avatarTextColor;
  final String title;
  final String subtitle;
  final bool enabled;
  final bool busy;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final contentColor = enabled ? AppColors.black : AppColors.textGray;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.rs(12)),
      child: Container(
        constraints: BoxConstraints(minHeight: context.rs(72)),
        padding: EdgeInsets.symmetric(
          horizontal: context.rs(16),
          vertical: context.rs(10),
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(context.rs(12)),
          border: Border.all(color: AppColors.inputBorder, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: context.rs(54),
              height: context.rs(54),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: avatarColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                avatarLabel,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(20),
                  fontWeight: FontWeight.w500,
                  color: avatarTextColor,
                ),
              ),
            ),
            SizedBox(width: context.rs(16)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(14),
                            fontWeight: FontWeight.w600,
                            color: contentColor,
                          ),
                        ),
                      ),
                      SizedBox(width: context.rs(5)),
                      Icon(
                        Icons.chevron_right,
                        size: context.rs(18),
                        color: AppColors.textGray,
                      ),
                    ],
                  ),
                  SizedBox(height: context.rs(2)),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.rs(13),
                      color: contentColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: context.rs(8)),
            if (busy)
              SizedBox(
                width: context.rs(24),
                height: context.rs(24),
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Transform.scale(
                scale: 0.88,
                child: Switch(
                  value: enabled,
                  onChanged: onToggle,
                  activeThumbColor: AppColors.white,
                  activeTrackColor: const Color(0xFF51499A),
                  inactiveThumbColor: AppColors.white,
                  inactiveTrackColor: const Color(0xFFD9D9DD),
                  trackOutlineColor:
                      WidgetStateProperty.all(Colors.transparent),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyRow extends StatelessWidget {
  const _EmptyRow({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.rs(72),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.inputBorder),
        borderRadius: BorderRadius.circular(context.rs(12)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: context.rs(13),
          color: AppColors.textGray,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.rs(28)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined,
                size: context.rs(42), color: AppColors.textGray),
            SizedBox(height: context.rs(12)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(13),
                color: AppColors.textGray,
              ),
            ),
            SizedBox(height: context.rs(14)),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('ลองใหม่'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormData {
  const _FormData({required this.name, required this.specialty});
  final String name;
  final String specialty;
}

class _ResourceDialog extends StatelessWidget {
  const _ResourceDialog({
    required this.title,
    required this.nameLabel,
    required this.nameHint,
    required this.specialtyLabel,
    required this.specialtyHint,
    required this.nameController,
    required this.specialtyController,
    required this.onSubmit,
  });

  final String title;
  final String nameLabel;
  final String nameHint;
  final String specialtyLabel;
  final String specialtyHint;
  final TextEditingController nameController;
  final TextEditingController specialtyController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nameLabel, style: const TextStyle(fontFamily: 'Inter')),
          SizedBox(height: context.rs(6)),
          TextField(
            controller: nameController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: nameHint,
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(height: context.rs(14)),
          Text(specialtyLabel, style: const TextStyle(fontFamily: 'Inter')),
          SizedBox(height: context.rs(6)),
          TextField(
            controller: specialtyController,
            decoration: InputDecoration(
              hintText: specialtyHint,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ยกเลิก'),
        ),
        ElevatedButton(
          onPressed: onSubmit,
          child: const Text('บันทึก'),
        ),
      ],
    );
  }
}
