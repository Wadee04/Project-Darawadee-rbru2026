import 'models.dart';
import 'mock_data_store.dart';

// ============================================================
// MockReviewService — จำลองการส่งรีวิว/คะแนนแอป
// ============================================================
class MockReviewService {
  MockReviewService._();
  static final MockReviewService instance = MockReviewService._();

  final _store = MockDataStore.instance;
  final List<ReviewModel> _reviews = [
    ReviewModel(
      id: 'rv-001',
      userId: 'user-001',
      rating: 5,
      comment: 'แอปใช้งานง่ายมาก จองคิวได้สะดวก ทีมงานตอบไวมากเลยค่ะ',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  /// ดึงรีวิวของ user ปัจจุบัน
  Future<ReviewModel?> getMyReview() async {
    await _delay();
    try {
      return _reviews.firstWhere((r) => r.userId == _store.currentUser.id);
    } catch (_) {
      return null;
    }
  }

  /// ส่งรีวิว
  Future<ReviewModel> submitReview({
    required int rating,
    String? comment,
  }) async {
    await _delay();
    // ถ้ามีรีวิวอยู่แล้วให้ลบก่อน
    _reviews.removeWhere((r) => r.userId == _store.currentUser.id);

    final review = ReviewModel(
      id: 'rv-${DateTime.now().millisecondsSinceEpoch}',
      userId: _store.currentUser.id,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );
    _reviews.add(review);
    return review;
  }

  /// คะแนนเฉลี่ยทั้งหมด
  Future<double> getAverageRating() async {
    await _delay();
    if (_reviews.isEmpty) return 0.0;
    return _reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        _reviews.length;
  }
}

Future<void> _delay() => Future.delayed(const Duration(milliseconds: 300));
