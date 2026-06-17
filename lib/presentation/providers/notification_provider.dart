import 'package:flutter/material.dart';
import '../../domain/entities/notification_entity.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../data/models/notification_model.dart';

/// Bildirim state management.
class NotificationProvider extends ChangeNotifier {
  final NotificationRepositoryImpl _repository = NotificationRepositoryImpl();

  List<NotificationEntity> _notifications = [];
  bool _isLoading = false;

  List<NotificationEntity> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  bool get hasUnread => unreadCount > 0;

  /// Kullanıcıya ait bildirimleri yükle.
  Future<void> loadNotifications(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _notifications = await _repository.getNotificationsByUserId(userId);
    } catch (e) {
      _notifications = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Bildirimi okundu olarak işaretle.
  Future<void> markAsRead(String id) async {
    await _repository.markAsRead(id);
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].markAsRead();
      notifyListeners();
    }
  }

  /// Tüm bildirimleri okundu olarak işaretle.
  Future<void> markAllAsRead(String userId) async {
    await _repository.markAllAsRead(userId);
    _notifications = _notifications.map((n) => n.markAsRead()).toList();
    notifyListeners();
  }

  /// Bildirim ekle (in-app).
  Future<void> addNotification(NotificationEntity notification) async {
    final model = NotificationModel.fromEntity(notification);
    await _repository.createNotification(model);
    _notifications.insert(0, notification);
    notifyListeners();
  }

  /// Bildirim sil.
  Future<void> deleteNotification(String id) async {
    await _repository.deleteNotification(id);
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
