/// Bildirim tipleri.
enum NotificationType { newAssignment, upcomingLesson, overdueAssignment, system }

/// Bildirim entity'si. Domain katmanında kullanılır.
class NotificationEntity {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final String? relatedId;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.relatedId,
  });

  /// Tip string'i.
  String get typeText {
    switch (type) {
      case NotificationType.newAssignment:
        return 'Yeni Ödev';
      case NotificationType.upcomingLesson:
        return 'Yaklaşan Ders';
      case NotificationType.overdueAssignment:
        return 'Geciken Ödev';
      case NotificationType.system:
        return 'Sistem Mesajı';
    }
  }

  /// Okundu olarak işaretle.
  NotificationEntity markAsRead() {
    return NotificationEntity(
      id: id,
      userId: userId,
      type: type,
      title: title,
      message: message,
      isRead: true,
      createdAt: createdAt,
      relatedId: relatedId,
    );
  }

  /// Kopyalama metodu.
  NotificationEntity copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? message,
    bool? isRead,
    DateTime? createdAt,
    String? relatedId,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      relatedId: relatedId ?? this.relatedId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
