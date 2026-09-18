import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../components/shared_widgets.dart';
import '../../../services/service_locator.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// RateYourExperiencePage — หน้าให้คะแนนแอป
// ============================================================
class RateYourExperiencePage extends StatefulWidget {
  const RateYourExperiencePage({
    super.key,
    this.onBack,
    this.onSubmit,
    this.onSkip,
  });

  final VoidCallback? onBack;
  final void Function(int rating, String comment)? onSubmit;
  final VoidCallback? onSkip;

  @override
  State<RateYourExperiencePage> createState() =>
      _RateYourExperiencePageState();
}

class _RateYourExperiencePageState extends State<RateYourExperiencePage> {
  int _rating = 2; // จำนวนดาวที่เลือก (1-5)
  final TextEditingController _commentCtrl = TextEditingController();
  static const int _maxLength = 300;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    widget.onSubmit?.call(_rating, _commentCtrl.text.trim());
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
              // ---- AppBar ----
              AppBarBack(
                title: 'ให้คะแนนแอป',
                onBack: widget.onBack,
              ),

              // ---- Body ----
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.rs(16),
                    context.rs(8),
                    context.rs(16),
                    context.rs(24),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: context.rs(8)),

                      // ---- Mascot + title ----
                      _TopSection(),

                      SizedBox(height: context.rs(20)),

                      // ---- Star rating card ----
                      _StarRatingCard(
                        rating: _rating,
                        onRatingChanged: (r) =>
                            setState(() => _rating = r),
                      ),

                      SizedBox(height: context.rs(12)),

                      // ---- Comment card ----
                      _CommentCard(
                        controller: _commentCtrl,
                        maxLength: _maxLength,
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
              ),

              // ---- Bottom buttons ----
              _BottomBar(
                onSubmit: _handleSubmit,
                onSkip: widget.onSkip,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// _TopSection — mascot + title + subtitle
// ============================================================
class _TopSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ---- mascot ----
        Image.asset(
          'assets/images/onboarding/toothmascot.png',
          width: context.rs(100),
          fit: BoxFit.contain,
          errorBuilder: (context, e, s) => Icon(
            Icons.sentiment_very_satisfied_outlined,
            size: context.rs(80),
            color: AppColors.purple,
          ),
        ),

        SizedBox(height: context.rs(12)),

        Text(
          'ชอบการใช้งานแอปเราไหม?',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(15),
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),

        SizedBox(height: context.rs(6)),

        Text(
          'ความคิดเห็นของคุณ ช่วยให้เราพัฒนาแอปให้ดีขึ้น',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: context.rs(12),
            fontWeight: FontWeight.w400,
            color: AppColors.textGray,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ============================================================
// _StarRatingCard — กล่องให้ดาว
// ============================================================
class _StarRatingCard extends StatelessWidget {
  const _StarRatingCard({
    required this.rating,
    required this.onRatingChanged,
  });

  final int rating;
  final ValueChanged<int> onRatingChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: context.rs(20),
        horizontal: context.rs(16),
      ),
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Column(
        children: [
          Text(
            'ให้คะแนนโดยรวม',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(13),
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),

          SizedBox(height: context.rs(14)),

          // ---- ดาว 5 ดวง ----
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final starIndex = i + 1;
              final isSelected = starIndex <= rating;
              return GestureDetector(
                onTap: () => onRatingChanged(starIndex),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.rs(4)),
                  child: Icon(
                    isSelected ? Icons.star : Icons.star_border,
                    size: context.rs(36),
                    color: isSelected
                        ? const Color(0xFFFFBD00)
                        : AppColors.inputBorder,
                  ),
                ),
              );
            }),
          ),

          SizedBox(height: context.rs(10)),

          Text(
            _ratingLabel(rating),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.rs(12),
              fontWeight: FontWeight.w400,
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }

  String _ratingLabel(int r) {
    switch (r) {
      case 1:
        return 'แย่มาก กรุณาบอกเราว่าเราทำอะไรผิดพลาด';
      case 2:
        return 'ขอบคุณสำหรับคะแนนของคุณค่ะ/ครับ';
      case 3:
        return 'พอใช้ได้ค่ะ/ครับ ขอบคุณสำหรับคะแนน';
      case 4:
        return 'ดีมากค่ะ/ครับ ขอบคุณที่ใช้บริการ';
      case 5:
        return 'ยอดเยี่ยมมากค่ะ/ครับ ขอบคุณสำหรับคะแนน';
      default:
        return '';
    }
  }
}

// ============================================================
// _CommentCard — กล่องกรอกความคิดเห็น
// ============================================================
class _CommentCard extends StatelessWidget {
  const _CommentCard({
    required this.controller,
    required this.maxLength,
    required this.onChanged,
  });

  final TextEditingController controller;
  final int maxLength;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final currentLength = controller.text.length;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rs(16)),
      decoration: BoxDecoration(
        color: AppColors.homeBackground,
        borderRadius: BorderRadius.circular(context.rs(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(13),
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
              children: [
                const TextSpan(text: 'บอกความคิดเห็นเพิ่มเติม'),
                TextSpan(
                  text: ' (ไม่บังคับ)',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: context.rs(10)),

          // ---- text area ----
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(context.rs(10)),
              border: Border.all(
                color: AppColors.inputBorder,
                width: 1,
              ),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              maxLines: 5,
              maxLength: maxLength,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(12),
                color: AppColors.black,
              ),
              decoration: InputDecoration(
                hintText:
                    'แจ้งประสบการณ์การใช้งาน\nหรือสิ่งที่คุณอยากบอกเกี่ยวกับแอป .....',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(12),
                  color: AppColors.inputHint,
                  height: 1.55,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.all(context.rs(12)),
                counterText: '',
              ),
            ),
          ),

          SizedBox(height: context.rs(6)),

          // ---- character count ----
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$currentLength/$maxLength',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(11),
                color: AppColors.inputHint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _BottomBar — ปุ่มส่งและข้ามไปก่อน
// ============================================================
class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.onSubmit,
    this.onSkip,
  });

  final VoidCallback onSubmit;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        context.rs(24),
        context.rs(12),
        context.rs(24),
        context.rs(28),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ---- ปุ่มส่ง ----
          SizedBox(
            width: double.infinity,
            height: context.rs(46),
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purple,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.rs(30)),
                ),
              ),
              child: Text(
                'ส่งคะแนนและความคิดเห็น',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: context.rs(12)),

          // ---- ข้ามไปก่อน ----
          GestureDetector(
            onTap: onSkip ?? () => Navigator.maybePop(context),
            child: Text(
              'ข้ามไปก่อน',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(13),
                fontWeight: FontWeight.w500,
                color: AppColors.textGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
