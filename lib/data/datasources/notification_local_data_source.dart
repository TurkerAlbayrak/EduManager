import '../../core/constants/app_constants.dart';
import '../../core/services/json_storage_service.dart';
import '../models/notification_model.dart';

/// Bildirim verilerini JSON'dan okuyan data source.
class NotificationLocalDataSource {
  final JsonStorageService _storage = JsonStorageService.instance;

  Future<List<NotificationModel>> getAllNotifications() async {
    final data = await _storage.loadJsonFile(AppConstants.notificationsFile);
    return data.map((json) => NotificationModel.fromJson(json)).toList();
  }

  Future<List<NotificationModel>> getNotificationsByUserId(String userId) async {
    final notifications = await getAllNotifications();
    return notifications.where((n) => n.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<int> getUnreadCount(String userId) async {
    final notifications = await getNotificationsByUserId(userId);
    return notifications.where((n) => !n.isRead).length;
  }

  Future<NotificationModel> createNotification(NotificationModel notification) async {
    _storage.addToCache(AppConstants.notificationsFile, notification.toJson());
    return notification;
  }

  Future<void> markAsRead(String id) async {
    final notifications = await getAllNotifications();
    try {
      final notification = notifications.firstWhere((n) => n.id == id);
      final updated = NotificationModel.fromEntity(notification.markAsRead());
      _storage.updateInCache(AppConstants.notificationsFile, id, updated.toJson());
    } catch (_) {
      // Not found, ignore
    }
  }

  Future<void> markAllAsRead(String userId) async {
    final notifications = await getNotificationsByUserId(userId);
    for (final n in notifications) {
      if (!n.isRead) {
        final updated = NotificationModel.fromEntity(n.markAsRead());
        _storage.updateInCache(AppConstants.notificationsFile, n.id, updated.toJson());
      }
    }
  }

  Future<void> deleteNotification(String id) async {
    _storage.removeFromCache(AppConstants.notificationsFile, id);
  }
}
