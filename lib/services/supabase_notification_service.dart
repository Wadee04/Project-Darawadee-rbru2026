import 'package:supabase_flutter/supabase_flutter.dart';
import '../mock/models.dart';
import '../mock/mock_notification_service.dart' show NotificationSettings;

// ============================================================
// SupabaseNotificationService — แจ้งเตือน + ตั้งค่า
// ============================================================
class SupabaseNotificationService {
  SupabaseNotificationService._();
  static final SupabaseNotificationService instance =
      SupabaseNotificationService._();

  final _db = Supabase.instance.client;
  String get _userId => _db.auth.currentUser!.id;

  // ---- Read ----------------------------------------------

  Future<List<NotificationModel>> getNotifications() async {
    final res = await _db
        .from('notifications')
        .select()
        .eq('user_id', _userId)
        .order('created_at', ascending: false);
    return (res as List).map((m) => NotificationModel.fromMap(m)).toList();
  }

  Future<List<NotificationModel>> getUnread() async {
    final res = await _db
        .from('notifications')
        .select()
        .eq('user_id', _userId)
        .eq('is_read', false)
        .order('created_at', ascending: false);
    return (res as List).map((m) => NotificationModel.fromMap(m)).toList();
  }

  Future<int> getUnreadCount() async {
    final res = await _db
        .from('notifications')
        .select()
        .eq('user_id', _userId)
        .eq('is_read', false);
    return (res as List).length;
  }

  // ---- Update --------------------------------------------

  Future<void> markAsRead(String id) async {
    await _db
        .from('notifications')
        .update({'is_read': true})
        .eq('id', id)
        .eq('user_id', _userId);
  }

  Future<void> markAllAsRead() async {
    await _db
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', _userId)
        .eq('is_read', false);
  }

  Future<void> delete(String id) async {
    await _db
        .from('notifications')
        .delete()
        .eq('id', id)
        .eq('user_id', _userId);
  }

  // ---- Settings ------------------------------------------

  Future<NotificationSettings> getSettings() async {
    final res = await _db
        .from('user_notification_settings')
        .select()
        .eq('user_id', _userId)
        .maybeSingle();

    if (res == null) return const NotificationSettings();

    return NotificationSettings(
      allEnabled: (res['all_enabled'] as bool?) ?? true,
      appointment: (res['appointment'] as bool?) ?? true,
      promotion: (res['promotion'] as bool?) ?? true,
      treatmentTip: (res['treatment_tip'] as bool?) ?? true,
      feedback: (res['feedback'] as bool?) ?? true,
    );
  }

  Future<void> updateSettings(NotificationSettings settings) async {
    await _db.from('user_notification_settings').upsert({
      'user_id': _userId,
      'all_enabled': settings.allEnabled,
      'appointment': settings.appointment,
      'promotion': settings.promotion,
      'treatment_tip': settings.treatmentTip,
      'feedback': settings.feedback,
    });
  }

  // ---- Realtime ------------------------------------------

  /// Subscribe การแจ้งเตือนใหม่แบบ realtime
  RealtimeChannel subscribeToNotifications(
    void Function(NotificationModel) onNew,
  ) {
    return _db
        .channel('notifications:$_userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: _userId,
          ),
          callback: (payload) {
            final model = NotificationModel.fromMap(
              payload.newRecord,
            );
            onNew(model);
          },
        )
        .subscribe();
  }
}
