import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_data_source.dart';
import '../models/notification_model.dart';

/// NotificationRepository'nin yerel JSON implementasyonu.
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource _dataSource;

  NotificationRepositoryImpl({NotificationLocalDataSource? dataSource})
      : _dataSource = dataSource ?? NotificationLocalDataSource();

  @override
  Future<List<NotificationEntity>> getNotificationsByUserId(String userId) =>
      _dataSource.getNotificationsByUserId(userId);

  @override
  Future<int> getUnreadCount(String userId) =>
      _dataSource.getUnreadCount(userId);

  @override
  Future<NotificationEntity> createNotification(NotificationEntity notification) =>
      _dataSource.createNotification(NotificationModel.fromEntity(notification));

  @override
  Future<void> markAsRead(String id) => _dataSource.markAsRead(id);

  @override
  Future<void> markAllAsRead(String userId) => _dataSource.markAllAsRead(userId);

  @override
  Future<void> deleteNotification(String id) =>
      _dataSource.deleteNotification(id);
}
