import '../../domain/entities/lesson_entity.dart';

/// Lesson model — JSON serileştirme/deserileştirme için.
class LessonModel extends LessonEntity {
  const LessonModel({
    required super.id,
    required super.teacherId,
    required super.studentId,
    required super.date,
    required super.startTime,
    required super.durationMinutes,
    required super.topic,
    super.content,
    super.teacherNote,
    required super.status,
  });

  /// JSON'dan model oluşturur.
  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      teacherId: json['teacherId'] as String,
      studentId: json['studentId'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String,
      durationMinutes: json['durationMinutes'] as int,
      topic: json['topic'] as String,
      content: json['content'] as String?,
      teacherNote: json['teacherNote'] as String?,
      status: _parseStatus(json['status'] as String),
    );
  }

  /// Model'i JSON'a dönüştürür.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacherId': teacherId,
      'studentId': studentId,
      'date': date.toIso8601String().split('T').first,
      'startTime': startTime,
      'durationMinutes': durationMinutes,
      'topic': topic,
      'content': content,
      'teacherNote': teacherNote,
      'status': _statusToString(status),
    };
  }

  /// Entity'den model oluşturur.
  factory LessonModel.fromEntity(LessonEntity entity) {
    return LessonModel(
      id: entity.id,
      teacherId: entity.teacherId,
      studentId: entity.studentId,
      date: entity.date,
      startTime: entity.startTime,
      durationMinutes: entity.durationMinutes,
      topic: entity.topic,
      content: entity.content,
      teacherNote: entity.teacherNote,
      status: entity.status,
    );
  }

  static LessonStatus _parseStatus(String status) {
    switch (status) {
      case 'scheduled':
        return LessonStatus.scheduled;
      case 'completed':
        return LessonStatus.completed;
      case 'cancelled':
        return LessonStatus.cancelled;
      default:
        return LessonStatus.scheduled;
    }
  }

  static String _statusToString(LessonStatus status) {
    switch (status) {
      case LessonStatus.scheduled:
        return 'scheduled';
      case LessonStatus.completed:
        return 'completed';
      case LessonStatus.cancelled:
        return 'cancelled';
    }
  }
}
