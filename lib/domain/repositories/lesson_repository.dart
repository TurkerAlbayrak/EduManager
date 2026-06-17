import '../entities/lesson_entity.dart';

/// Ders repository arayüzü.
abstract class LessonRepository {
  /// Öğretmene ait tüm dersleri getirir.
  Future<List<LessonEntity>> getLessonsByTeacherId(String teacherId);

  /// Öğrenciye ait tüm dersleri getirir.
  Future<List<LessonEntity>> getLessonsByStudentId(String studentId);

  /// ID ile ders getirir.
  Future<LessonEntity?> getLessonById(String id);

  /// Belirli bir tarihteki dersleri getirir.
  Future<List<LessonEntity>> getLessonsByDate(String teacherId, DateTime date);

  /// Yeni ders oluşturur.
  Future<LessonEntity> createLesson(LessonEntity lesson);

  /// Ders günceller.
  Future<LessonEntity> updateLesson(LessonEntity lesson);

  /// Ders siler.
  Future<void> deleteLesson(String id);

  /// Bu aydaki ders sayısını getirir.
  Future<int> getMonthlyLessonCount(String teacherId);

  /// Toplam ders süresini (dakika) getirir.
  Future<int> getTotalLessonMinutes(String teacherId);
}
