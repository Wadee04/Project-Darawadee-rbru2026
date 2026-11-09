import 'models.dart';
import 'mock_data_store.dart';

// ============================================================
// MockNotificationService — จำลองการแจ้งเตือน + ตั้งค่า
// ============================================================
class MockNotificationService {
  MockNotificationService._();
  static final MockNotificationService instance =
      MockNotificationService._();

  final _store = MockDataStore.instance;

  // ---- ตั้งค่าการแจ้งเตือน ---------------------------------
  bool _allEnabled = true;
  bool _appointmentEnabled = true;
  bool _promotionEnabled = true;
  bool _treatmentTipEnabled = true;
  bool _feedbackEnabled = true;

  // ---- Read ----------------------------------------------

  /// ดึงการแจ้งเตือนทั้งหมด (เรียงล่าสุดก่อน)
  Future<List<NotificationModel>> getNotifications() async {
    await _delay();
    final list = List<NotificationModel>.from(_store.notifications)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  /// ดึงเฉพาะที่ยังไม่ได้อ่าน
  Future<List<NotificationModel>> getUnread() async {
    await _delay();
    return _store.notifications.where((n) => !n.isRead).toList();
  }

  /// จำนวนที่ยังไม่ได้อ่าน
  Future<int> getUnreadCount() async {
    await _delay();
    return _store.notifications.where((n) => !n.isRead).length;
  }

  // ---- Update --------------------------------------------

  /// อ่านการแจ้งเตือน 1 รายการ
  Future<void> markAsRead(String id) async {
    await _delay();
    final index = _store.notifications.indexWhere((n) => n.id == id);
    if (index == -1) return;
    final old = _store.notifications[index];
    _store.notifications[index] = NotificationModel(
      id: old.id,
      userId: old.userId,
      type: old.type,
      title: old.title,
      body: old.body,
      isRead: true,
      createdAt: old.createdAt,
    );
  }

  /// อ่านทั้งหมด
  Future<void> markAllAsRead() async {
    await _delay();
    _store.notifications = _store.notifications
        .map((n) => NotificationModel(
              id: n.id,
              userId: n.userId,
              type: n.type,
              title: n.title,
              body: n.body,
              isRead: true,
              createdAt: n.createdAt,
            ))
        .toList();
  }

  /// ลบการแจ้งเตือน
  Future<void> delete(String id) async {
    await _delay();
    _store.notifications.removeWhere((n) => n.id == id);
  }

  // ---- Settings ------------------------------------------

  /// ดึงการตั้งค่า
  Future<NotificationSettings> getSettings() async {
    await _delay();
    return NotificationSettings(
      allEnabled: _allEnabled,
      appointment: _appointmentEnabled,
      promotion: _promotionEnabled,
      treatmentTip: _treatmentTipEnabled,
      feedback: _feedbackEnabled,
    );
  }

  /// อัปเดตการตั้งค่า
  Future<void> updateSettings(NotificationSettings settings) async {
    await _delay();
    _allEnabled = settings.allEnabled;
    _appointmentEnabled = settings.appointment;
    _promotionEnabled = settings.promotion;
    _treatmentTipEnabled = settings.treatmentTip;
    _feedbackEnabled = settings.feedback;
  }

  // ---- Create (ใช้ภายใน) ---------------------------------

  /// เพิ่มการแจ้งเตือนใหม่
  Future<void> addNotification({
    required NotificationType type,
    required String title,
    String? body,
  }) async {
    _store.notifications.insert(
      0,
      NotificationModel(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        userId: _store.currentUser.id,
        type: type,
        title: title,
        body: body,
        isRead: false,
        createdAt: DateTime.now(),
      ),
    );
  }
}

// ---- DTO ตั้งค่าการแจ้งเตือน -------------------------------
class NotificationSettings {
  const NotificationSettings({
    this.allEnabled = true,
    this.appointment = true,
    this.promotion = true,
    this.treatmentTip = true,
    this.feedback = true,
  });

  final bool allEnabled;
  final bool appointment;
  final bool promotion;
  final bool treatmentTip;
  final bool feedback;
}

Future<void> _delay() => Future.delayed(const Duration(milliseconds: 300));
