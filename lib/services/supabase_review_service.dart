import 'package:supabase_flutter/supabase_flutter.dart';
import '../mock/models.dart';

// ============================================================
// SupabaseReviewService — ส่งรีวิว / คะแนนแอป
// ============================================================
class SupabaseReviewService {
  SupabaseReviewService._();
  static final SupabaseReviewService instance = SupabaseReviewService._();

  final _db = Supabase.instance.client;
  String get _userId => _db.auth.currentUser!.id;

  Future<ReviewModel?> getMyReview() async {
    final res = await _db
        .from('reviews')
        .select()
        .eq('user_id', _userId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();
    if (res == null) return null;
    return ReviewModel(
      id: res['id'] as String,
      userId: _userId,
      rating: res['rating'] as int,
      comment: res['comment'] as String?,
      createdAt: DateTime.parse(res['created_at'] as String),
    );
  }

  Future<ReviewModel> submitReview({
    required int rating,
    String? comment,
  }) async {
    final res = await _db
        .from('reviews')
        .insert({
          'user_id': _userId,
          'rating': rating,
          'comment': comment,
        })
        .select()
        .single();

    return ReviewModel(
      id: res['id'] as String,
      userId: _userId,
      rating: rating,
      comment: comment,
      createdAt: DateTime.parse(res['created_at'] as String),
    );
  }

  Future<double> getAverageRating() async {
    final res = await _db.from('reviews').select('rating');
    final list = res as List;
    if (list.isEmpty) return 0.0;
    final sum = list.fold<int>(0, (s, r) => s + (r['rating'] as int));
    return sum / list.length;
  }
}
