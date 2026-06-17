import '../../domain/entities/notification_entity.dart';

/// Notification model — JSON serileştirme/deserileştirme için.
class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.title,
    required super.message,
    required super.isRead,
    required super.createdAt,
    super.relatedId,
  });

  /// JSON'dan model oluşturur.
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: _parseType(json['type'] as String),
      title: json['title'] as String,
      message: json['message'] as String,
      isRead: json['isRead'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      relatedId: json['relatedId'] as String?,
    );
  }

  /// Model'i JSON'a dönüştürür.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': _typeToString(type),
      'title': title,
      'message': message,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'relatedId': relatedId,
    };
  }

  /// Entity'den model oluşturur.
  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      userId: entity.userId,
      type: entity.type,
      title: entity.title,
      message: entity.message,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
      relatedId: entity.relatedId,
    );
  }

  static NotificationType _parseType(String type) {
    switch (type) {
      case 'newAssignment':
        return NotificationType.newAssignment;
      case 'upcomingLesson':
        return NotificationType.upcomingLesson;
      case 'overdueAssignment':
        return NotificationType.overdueAssignment;
      case 'system':
        return NotificationType.system;
      default:
        return NotificationType.system;
    }
  }

  static String _typeToString(NotificationType type) {
    switch (type) {
      case NotificationType.newAssignment:
        return 'newAssignment';
      case NotificationType.upcomingLesson:
        return 'upcomingLesson';
      case NotificationType.overdueAssignment:
        return 'overdueAssignment';
      case NotificationType.system:
        return 'system';
    }
  }
}
