import 'package:uuid/uuid.dart';

/// Bildirim yönetim servisi.
/// İlk sürümde in-app bildirim sağlar.
/// Gelecekte Firebase Cloud Messaging ile değiştirilebilir.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const _uuid = Uuid();

  /// Yeni ödev bildirimi oluşturur.
  Map<String, dynamic> createNewAssignmentNotification({
    required String userId,
    required String assignmentTitle,
    required String assignmentId,
  }) {
    return {
      'id': _uuid.v4(),
      'userId': userId,
      'type': 'newAssignment',
      'title': 'Yeni Ödev',
      'message': '"$assignmentTitle" adlı yeni bir ödev atandı.',
      'isRead': false,
      'createdAt': DateTime.now().toIso8601String(),
      'relatedId': assignmentId,
    };
  }

  /// Yaklaşan ders bildirimi oluşturur.
  Map<String, dynamic> createUpcomingLessonNotification({
    required String userId,
    required String topic,
    required String lessonId,
    required String dateStr,
  }) {
    return {
      'id': _uuid.v4(),
      'userId': userId,
      'type': 'upcomingLesson',
      'title': 'Yaklaşan Ders',
      'message': '"$topic" konulu dersiniz $dateStr tarihinde.',
      'isRead': false,
      'createdAt': DateTime.now().toIso8601String(),
      'relatedId': lessonId,
    };
  }

  /// Geciken ödev bildirimi oluşturur.
  Map<String, dynamic> createOverdueAssignmentNotification({
    required String userId,
    required String assignmentTitle,
    required String assignmentId,
  }) {
    return {
      'id': _uuid.v4(),
      'userId': userId,
      'type': 'overdueAssignment',
      'title': 'Geciken Ödev',
      'message': '"$assignmentTitle" ödevi teslim tarihini geçti!',
      'isRead': false,
      'createdAt': DateTime.now().toIso8601String(),
      'relatedId': assignmentId,
    };
  }

  /// Sistem mesajı bildirimi oluşturur.
  Map<String, dynamic> createSystemNotification({
    required String userId,
    required String title,
    required String message,
  }) {
    return {
      'id': _uuid.v4(),
      'userId': userId,
      'type': 'system',
      'title': title,
      'message': message,
      'isRead': false,
      'createdAt': DateTime.now().toIso8601String(),
      'relatedId': null,
    };
  }
}
