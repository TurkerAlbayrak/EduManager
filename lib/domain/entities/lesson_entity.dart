/// Ders durumları.
enum LessonStatus { scheduled, completed, cancelled }

/// Ders entity'si. Domain katmanında kullanılır.
class LessonEntity {
  final String id;
  final String teacherId;
  final String studentId;
  final DateTime date;
  final String startTime;
  final int durationMinutes;
  final String topic;
  final String? content;
  final String? teacherNote;
  final LessonStatus status;

  const LessonEntity({
    required this.id,
    required this.teacherId,
    required this.studentId,
    required this.date,
    required this.startTime,
    required this.durationMinutes,
    required this.topic,
    this.content,
    this.teacherNote,
    required this.status,
  });

  /// Ders geçmişte mi?
  bool get isPast => date.isBefore(DateTime.now());

  /// Ders bugün mü?
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  /// Süreyi saat formatında gösterir.
  String get durationFormatted {
    if (durationMinutes < 60) return '$durationMinutes dk';
    final hours = durationMinutes ~/ 60;
    final mins = durationMinutes % 60;
    if (mins == 0) return '$hours saat';
    return '$hours saat $mins dk';
  }

  /// Durum string'i.
  String get statusText {
    switch (status) {
      case LessonStatus.scheduled:
        return 'Planlandı';
      case LessonStatus.completed:
        return 'Tamamlandı';
      case LessonStatus.cancelled:
        return 'İptal Edildi';
    }
  }

  /// Kopyalama metodu.
  LessonEntity copyWith({
    String? id,
    String? teacherId,
    String? studentId,
    DateTime? date,
    String? startTime,
    int? durationMinutes,
    String? topic,
    String? content,
    String? teacherNote,
    LessonStatus? status,
  }) {
    return LessonEntity(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      studentId: studentId ?? this.studentId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      topic: topic ?? this.topic,
      content: content ?? this.content,
      teacherNote: teacherNote ?? this.teacherNote,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
