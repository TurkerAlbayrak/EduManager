import '../entities/notification_entity.dart';

/// Bildirim repository arayüzü.
abstract class NotificationRepository {
  /// Kullanıcıya ait tüm bildirimleri getirir.
  Future<List<NotificationEntity>> getNotificationsByUserId(String userId);

  /// Okunmamış bildirim sayısını getirir.
  Future<int> getUnreadCount(String userId);

  /// Bildirim oluşturur.
  Future<NotificationEntity> createNotification(NotificationEntity notification);

  /// Bildirimi okundu olarak işaretler.
  Future<void> markAsRead(String id);

  /// Tüm bildirimleri okundu olarak işaretler.
  Future<void> markAllAsRead(String userId);

  /// Bildirim siler.
  Future<void> deleteNotification(String id);
}
