import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// QueueManagementPage — จัดการคิวทั้งหมดของคลินิก (Admin)
// ============================================================
class QueueManagementPage extends StatefulWidget {
  const QueueManagementPage({
    super.key,
    this.onBack,
    this.queues = const [],
    this.onCallQueue,
    this.onSkipQueue,
    this.onCompleteQueue,
    this.onCancelQueue,
  });

  final VoidCallback? onBack;
  final List<AdminQueueItem> queues;
  final void Function(String bookingId)? onCallQueue;
  final void Function(String bookingId)? onSkipQueue;
  final void Function(String bookingId)? onCompleteQueue;
  final void Function(String bookingId)? onCancelQueue;

  @override
  State<QueueManagementPage> createState() => _QueueManagementPageState();
}

class _QueueManagementPageState extends State<QueueManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  List<AdminQueueItem> _filter(QueueCardStatus status) =>
      widget.queues.where((q) => q.status == status).toList();

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
              Padding(
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
                        onTap: widget.onBack ?? () => Navigator.maybePop(context),
                        child: Padding(
                          padding: EdgeInsets.all(context.rs(8)),
                          child: Icon(Icons.chevron_left, size: context.rs(28), color: AppColors.black),
                        ),
                      ),
                    ),
                    Text('จัดการคิว',
                        style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(15),
                            fontWeight: FontWeight.w600, color: AppColors.black)),
                  ],
                ),
              ),

              // ---- Stats row ----
              _QueueStatsRow(
                waiting: _filter(QueueCardStatus.waiting).length,
                inProgress: _filter(QueueCardStatus.inProgress).length,
                completed: _filter(QueueCardStatus.completed).length,
              ),

              // ---- Tab bar ----
              Container(
                color: AppColors.homeBackground,
                child: TabBar(
                  controller: _tab,
                  labelColor: AppColors.purple,
                  unselectedLabelColor: AppColors.textGray,
                  indicatorColor: AppColors.purple,
                  indicatorWeight: 2.5,
                  labelStyle: TextStyle(fontFamily: 'Inter', fontSize: context.rs(12), fontWeight: FontWeight.w600),
                  unselectedLabelStyle: TextStyle(fontFamily: 'Inter', fontSize: context.rs(12)),
                  tabs: const [Tab(text: 'รอเรียก'), Tab(text: 'กำลังรักษา'), Tab(text: 'เสร็จแล้ว')],
                ),
              ),

              // ---- Tab content ----
              Expanded(
                child: TabBarView(
                  controller: _tab,
                  children: [
                    _QueueList(
                      items: _filter(QueueCardStatus.waiting),
                      emptyMessage: 'ไม่มีคิวรอเรียก',
                      showCall: true,
                      onCall: widget.onCallQueue,
                      onSkip: widget.onSkipQueue,
                      onComplete: widget.onCompleteQueue,
                      onCancel: widget.onCancelQueue,
                    ),
                    _QueueList(
                      items: _filter(QueueCardStatus.inProgress),
                      emptyMessage: 'ไม่มีคิวกำลังรักษา',
                      showCall: false,
                      onCall: widget.onCallQueue,
                      onSkip: widget.onSkipQueue,
                      onComplete: widget.onCompleteQueue,
                      onCancel: widget.onCancelQueue,
                    ),
                    _QueueList(
                      items: _filter(QueueCardStatus.completed),
                      emptyMessage: 'ยังไม่มีคิวที่เสร็จแล้ว',
                      showCall: false,
                      onCall: null, onSkip: null, onComplete: null, onCancel: null,
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

// ---- Model ----
enum QueueCardStatus { waiting, inProgress, completed, cancelled }

class AdminQueueItem {
  const AdminQueueItem({
    required this.bookingId,
    required this.queueNumber,
    required this.patientName,
    required this.serviceName,
    required this.appointmentTime,
    required this.roomNumber,
    required this.status,
  });

  final String bookingId;
  final String queueNumber;
  final String patientName;
  final String serviceName;
  final String appointmentTime;
  final int roomNumber;
  final QueueCardStatus status;
}

// ---- Stats row ----
class _QueueStatsRow extends StatelessWidget {
  const _QueueStatsRow({required this.waiting, required this.inProgress, required this.completed});
  final int waiting;
  final int inProgress;
  final int completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(context.rs(16), context.rs(8), context.rs(16), context.rs(8)),
      padding: EdgeInsets.symmetric(vertical: context.rs(10)),
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(12)),
      ),
      child: Row(
        children: [
          _Stat(label: 'รอเรียก', value: waiting, color: AppColors.orange),
          _vDivider(),
          _Stat(label: 'กำลังรักษา', value: inProgress, color: AppColors.purple),
          _vDivider(),
          _Stat(label: 'เสร็จแล้ว', value: completed, color: AppColors.greendentbook),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(width: 1, height: 30, color: AppColors.inputBorder);
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.color});
  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Text('$value', style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(18),
            fontWeight: FontWeight.w700, color: color)),
        Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(10), color: AppColors.textGray)),
      ]),
    );
  }
}

// ---- Queue list ----
class _QueueList extends StatelessWidget {
  const _QueueList({
    required this.items,
    required this.emptyMessage,
    required this.showCall,
    required this.onCall,
    required this.onSkip,
    required this.onComplete,
    required this.onCancel,
  });

  final List<AdminQueueItem> items;
  final String emptyMessage;
  final bool showCall;
  final void Function(String)? onCall;
  final void Function(String)? onSkip;
  final void Function(String)? onComplete;
  final void Function(String)? onCancel;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(emptyMessage,
            style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(13), color: AppColors.textGray)),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.all(context.rs(16)),
      itemCount: items.length,
      separatorBuilder: (_ , _) => SizedBox(height: context.rs(8)),
      itemBuilder: (_, i) => _QueueCard(
        item: items[i],
        showCall: showCall,
        onCall: onCall,
        onSkip: onSkip,
        onComplete: onComplete,
        onCancel: onCancel,
      ),
    );
  }
}

// ---- Queue card ----
class _QueueCard extends StatelessWidget {
  const _QueueCard({
    required this.item,
    required this.showCall,
    this.onCall,
    this.onSkip,
    this.onComplete,
    this.onCancel,
  });

  final AdminQueueItem item;
  final bool showCall;
  final void Function(String)? onCall;
  final void Function(String)? onSkip;
  final void Function(String)? onComplete;
  final void Function(String)? onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rs(14)),
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // queue number
              Container(
                padding: EdgeInsets.symmetric(horizontal: context.rs(10), vertical: context.rs(4)),
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  borderRadius: BorderRadius.circular(context.rs(8)),
                ),
                child: Text(item.queueNumber,
                    style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(14),
                        fontWeight: FontWeight.w800, color: AppColors.white)),
              ),
              SizedBox(width: context.rs(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.patientName,
                        style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(13),
                            fontWeight: FontWeight.w600, color: AppColors.black)),
                    Text('${item.serviceName} • ${item.appointmentTime}',
                        style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(11), color: AppColors.textGray)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: context.rs(8), vertical: context.rs(3)),
                decoration: BoxDecoration(
                  color: AppColors.purpleLight,
                  borderRadius: BorderRadius.circular(context.rs(20)),
                ),
                child: Text('ห้อง ${item.roomNumber}',
                    style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(10), color: AppColors.purple)),
              ),
            ],
          ),

          if (item.status != QueueCardStatus.completed) ...[
            SizedBox(height: context.rs(10)),
            Row(
              children: [
                if (showCall)
                  _ActionChip(
                    label: 'เรียกคิว',
                    color: AppColors.purple,
                    onTap: () => onCall?.call(item.bookingId),
                  ),
                if (showCall) SizedBox(width: context.rs(6)),
                if (onComplete != null && !showCall)
                  _ActionChip(
                    label: 'เสร็จสิ้น',
                    color: AppColors.greendentbook,
                    onTap: () => onComplete?.call(item.bookingId),
                  ),
                if (onComplete != null && !showCall) SizedBox(width: context.rs(6)),
                if (onSkip != null && showCall)
                  _ActionChip(
                    label: 'ข้ามคิว',
                    color: AppColors.orange,
                    onTap: () => onSkip?.call(item.bookingId),
                  ),
                if (onSkip != null && showCall) SizedBox(width: context.rs(6)),
                if (onCancel != null)
                  _ActionChip(
                    label: 'ยกเลิก',
                    color: AppColors.reddentbook,
                    onTap: () => onCancel?.call(item.bookingId),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label, required this.color, required this.onTap});
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: context.rs(12), vertical: context.rs(6)),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(context.rs(20)),
        ),
        child: Text(label,
            style: TextStyle(fontFamily: 'Inter', fontSize: context.rs(11),
                fontWeight: FontWeight.w500, color: color)),
      ),
    );
  }
}
