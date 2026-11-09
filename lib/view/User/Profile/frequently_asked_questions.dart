import 'package:flutter/material.dart';

import '../../../components/shared_widgets.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// FrequentlyAskedQuestionsPage — หน้าคำถามที่พบบ่อย
// ============================================================
class FrequentlyAskedQuestionsPage extends StatefulWidget {
  const FrequentlyAskedQuestionsPage({
    super.key,
    this.onBack,
  });

  final VoidCallback? onBack;

  @override
  State<FrequentlyAskedQuestionsPage> createState() =>
      _FrequentlyAskedQuestionsPageState();
}

class _FrequentlyAskedQuestionsPageState
    extends State<FrequentlyAskedQuestionsPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  int? _expandedIndex;

  static final List<_FaqData> _allFaqs = [
    _FaqData(
      question: 'การจองนัดหมายทำได้อย่างไร?',
      answer:
          'คุณสามารถจองนัดหมายได้โดย\n'
          '1. เลือกบริการที่ต้องการ\n'
          '2. เลือกหมอที่ต้องการเข้ารับการ\n'
          '3. เลือกวันที่และเวลาที่สะดวก\n'
          '4. กรอกข้อมูลและยืนยันการจอง\n'
          '5. ทำการชำระมัดจำ\n\n'
          'คุณได้รับการยืนยันนัดหมายผ่านทางแอปและอีเมล',
    ),
    _FaqData(
      question: 'สามารถเลื่อนนัดหมายได้หรือไม่?',
      answer:
          'สามารถเลื่อนนัดหมายได้ โดยต้องแจ้งล่วงหน้าอย่างน้อย 24 ชั่วโมงก่อนวันนัด '
          'ผ่านทางแอปหรือติดต่อคลินิกโดยตรง',
    ),
    _FaqData(
      question: 'หากยกเลิกนัด ได้รับเงินมัดจำคืนหรือไม่?',
      answer:
          'หากยกเลิกก่อน 48 ชั่วโมง จะได้รับเงินมัดจำคืน 70%\n'
          'หากยกเลิกภายใน 48 ชั่วโมง จะไม่ได้รับเงินมัดจำคืน',
    ),
    _FaqData(
      question: 'ชำระเงินผ่านช่องทางใดได้บ้าง?',
      answer:
          'รองรับการชำระเงินผ่าน QR Code พร้อมเพย์, โอนเงินผ่านธนาคาร '
          'และบัตรเครดิต/เดบิต',
    ),
    _FaqData(
      question: 'ลืมรหัสผ่าน ต้องทำอย่างไร?',
      answer:
          'กดปุ่ม "ลืมรหัสผ่าน" ในหน้าเข้าสู่ระบบ จากนั้นกรอกอีเมลที่ลงทะเบียนไว้ '
          'ระบบจะส่งลิงก์รีเซ็ตรหัสผ่านไปยังอีเมลของคุณ',
    ),
    _FaqData(
      question: 'สามารถแก้ไขข้อมูลส่วนตัวได้อย่างไร?',
      answer:
          'ไปที่เมนู "โปรไฟล์" แล้วกด "ข้อมูลส่วนตัว" เพื่อแก้ไขชื่อ, เบอร์โทร, '
          'อีเมล หรือข้อมูลอื่นๆ',
    ),
    _FaqData(
      question: 'หากพบปัญหาการใช้งานแอป ควรทำอย่างไร?',
      answer:
          'ติดต่อทีมสนับสนุนผ่านทางอีเมล support@dentb.com หรือโทร 039-134-456 '
          'ในเวลาทำการ 08:00 - 18:00 น.',
    ),
  ];

  List<_FaqData> get _filteredFaqs {
    if (_searchQuery.isEmpty) return _allFaqs;
    return _allFaqs
        .where((f) =>
            f.question.contains(_searchQuery) ||
            f.answer.contains(_searchQuery))
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final faqs = _filteredFaqs;

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
              // ---- AppBar ----
              AppBarBack(
                title: 'คำถามที่พบบ่อย',
                onBack: widget.onBack,
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
                      // ---- Search bar ----
                      _SearchBar(
                        controller: _searchCtrl,
                        onChanged: (v) =>
                            setState(() => _searchQuery = v),
                      ),

                      SizedBox(height: context.rs(16)),

                      // ---- FAQ accordion ----
                      if (faqs.isEmpty)
                        _EmptyResult()
                      else
                        _FaqAccordion(
                          faqs: faqs,
                          expandedIndex: _expandedIndex,
                          onExpand: (i) => setState(() {
                            _expandedIndex =
                                _expandedIndex == i ? null : i;
                          }),
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
// _SearchBar — ช่องค้นหา
// ============================================================
class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(30)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.rs(14)),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: context.rs(18),
              color: AppColors.inputHint,
            ),
            SizedBox(width: context.rs(8)),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(13),
                  color: AppColors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'ค้นหาคำถามที่พบบ่อย',
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: context.rs(13),
                    color: AppColors.inputHint,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: context.rs(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _FaqAccordion — รายการ accordion
// ============================================================
class _FaqAccordion extends StatelessWidget {
  const _FaqAccordion({
    required this.faqs,
    required this.expandedIndex,
    required this.onExpand,
  });

  final List<_FaqData> faqs;
  final int? expandedIndex;
  final void Function(int) onExpand;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Column(
        children: List.generate(faqs.length, (i) {
          final isLast = i == faqs.length - 1;
          return _FaqTile(
            data: faqs[i],
            isExpanded: expandedIndex == i,
            showDivider: !isLast,
            onTap: () => onExpand(i),
          );
        }),
      ),
    );
  }
}

class _FaqData {
  const _FaqData({required this.question, required this.answer});
  final String question;
  final String answer;
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({
    required this.data,
    required this.isExpanded,
    required this.showDivider,
    required this.onTap,
  });

  final _FaqData data;
  final bool isExpanded;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(context.rs(16)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.rs(16),
              vertical: context.rs(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- header row ----
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        data.question,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: context.rs(13),
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: context.rs(8)),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: context.rs(20),
                      color: AppColors.textGray,
                    ),
                  ],
                ),

                // ---- answer (animated) ----
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: isExpanded
                      ? Padding(
                          padding: EdgeInsets.only(top: context.rs(10)),
                          child: Text(
                            data.answer,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: context.rs(12),
                              fontWeight: FontWeight.w400,
                              color: AppColors.textGray,
                              height: 1.6,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.rs(16)),
            child: const Divider(
              color: AppColors.inputBorder,
              height: 1,
              thickness: 0.5,
            ),
          ),
      ],
    );
  }
}

// ============================================================
// _EmptyResult — ไม่พบคำถาม
// ============================================================
class _EmptyResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: context.rs(40)),
      child: Column(
        children: [
          Icon(
            Icons.search_off_outlined,
            size: context.rs(48),
            color: AppColors.inputBorder,
          ),
          SizedBox(height: context.rs(12)),
          Text(
            'ไม่พบคำถามที่ค้นหา',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(13),
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }
}
