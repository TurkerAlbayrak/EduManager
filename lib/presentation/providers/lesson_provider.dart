import 'package:flutter/material.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../data/repositories/lesson_repository_impl.dart';
import 'package:uuid/uuid.dart';

/// Ders state management.
class LessonProvider extends ChangeNotifier {
  final LessonRepositoryImpl _repository = LessonRepositoryImpl();
  static const _uuid = Uuid();

  List<LessonEntity> _lessons = [];
  bool _isLoading = false;

  List<LessonEntity> get lessons => _lessons;
  bool get isLoading => _isLoading;

  List<LessonEntity> get upcomingLessons => _lessons
      .where((l) => l.status == LessonStatus.scheduled)
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  List<LessonEntity> get pastLessons => _lessons
      .where((l) => l.status == LessonStatus.completed)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  int get totalLessons => _lessons.length;
  int get completedLessons =>
      _lessons.where((l) => l.status == LessonStatus.completed).length;
  int get scheduledLessons =>
      _lessons.where((l) => l.status == LessonStatus.scheduled).length;

  int get monthlyLessonCount {
    final now = DateTime.now();
    return _lessons
        .where((l) => l.date.year == now.year && l.date.month == now.month)
        .length;
  }

  int get totalMinutes => _lessons
      .where((l) => l.status == LessonStatus.completed)
      .fold<int>(0, (sum, l) => sum + l.durationMinutes);

  String get totalHoursFormatted {
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    if (hours == 0) return '$mins dk';
    if (mins == 0) return '$hours saat';
    return '$hours sa $mins dk';
  }

  /// Öğretmene ait dersleri yükle.
  Future<void> loadLessons(String teacherId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _lessons = await _repository.getLessonsByTeacherId(teacherId);
    } catch (e) {
      _lessons = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Öğrenciye ait dersleri yükle.
  Future<void> loadStudentLessons(String studentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _lessons = await _repository.getLessonsByStudentId(studentId);
    } catch (e) {
      _lessons = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Belirli bir tarihteki dersleri getir.
  List<LessonEntity> getLessonsForDate(DateTime date) {
    return _lessons.where((l) {
      return l.date.year == date.year &&
          l.date.month == date.month &&
          l.date.day == date.day;
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Derse sahip günleri getir (takvim için).
  Map<DateTime, List<LessonEntity>> get lessonsByDate {
    final map = <DateTime, List<LessonEntity>>{};
    for (final lesson in _lessons) {
      final dateKey = DateTime(lesson.date.year, lesson.date.month, lesson.date.day);
      map.putIfAbsent(dateKey, () => []).add(lesson);
    }
    return map;
  }

  /// Yeni ders oluştur.
  Future<LessonEntity> createLesson({
    required String teacherId,
    required String studentId,
    required DateTime date,
    required String startTime,
    required int durationMinutes,
    required String topic,
    String? content,
    String? teacherNote,
  }) async {
    final lesson = LessonEntity(
      id: _uuid.v4(),
      teacherId: teacherId,
      studentId: studentId,
      date: date,
      startTime: startTime,
      durationMinutes: durationMinutes,
      topic: topic,
      content: content,
      teacherNote: teacherNote,
      status: LessonStatus.scheduled,
    );

    final created = await _repository.createLesson(lesson);
    _lessons.add(created);
    notifyListeners();
    return created;
  }

  /// Ders güncelle.
  Future<void> updateLesson(LessonEntity lesson) async {
    await _repository.updateLesson(lesson);
    final index = _lessons.indexWhere((l) => l.id == lesson.id);
    if (index != -1) {
      _lessons[index] = lesson;
      notifyListeners();
    }
  }

  /// Ders sil.
  Future<void> deleteLesson(String id) async {
    await _repository.deleteLesson(id);
    _lessons.removeWhere((l) => l.id == id);
    notifyListeners();
  }

  /// Belirli bir öğrencinin derslerini getir.
  List<LessonEntity> getLessonsByStudentId(String studentId) {
    return _lessons.where((l) => l.studentId == studentId).toList();
  }
}
