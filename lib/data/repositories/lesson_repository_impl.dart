import '../../domain/entities/lesson_entity.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../datasources/lesson_local_data_source.dart';
import '../models/lesson_model.dart';

/// LessonRepository'nin yerel JSON implementasyonu.
class LessonRepositoryImpl implements LessonRepository {
  final LessonLocalDataSource _dataSource;

  LessonRepositoryImpl({LessonLocalDataSource? dataSource})
      : _dataSource = dataSource ?? LessonLocalDataSource();

  @override
  Future<List<LessonEntity>> getLessonsByTeacherId(String teacherId) =>
      _dataSource.getLessonsByTeacherId(teacherId);

  @override
  Future<List<LessonEntity>> getLessonsByStudentId(String studentId) =>
      _dataSource.getLessonsByStudentId(studentId);

  @override
  Future<LessonEntity?> getLessonById(String id) =>
      _dataSource.getLessonById(id);

  @override
  Future<List<LessonEntity>> getLessonsByDate(String teacherId, DateTime date) =>
      _dataSource.getLessonsByDate(teacherId, date);

  @override
  Future<LessonEntity> createLesson(LessonEntity lesson) =>
      _dataSource.createLesson(LessonModel.fromEntity(lesson));

  @override
  Future<LessonEntity> updateLesson(LessonEntity lesson) =>
      _dataSource.updateLesson(LessonModel.fromEntity(lesson));

  @override
  Future<void> deleteLesson(String id) => _dataSource.deleteLesson(id);

  @override
  Future<int> getMonthlyLessonCount(String teacherId) async {
    final lessons = await getLessonsByTeacherId(teacherId);
    final now = DateTime.now();
    return lessons
        .where((l) => l.date.year == now.year && l.date.month == now.month)
        .length;
  }

  @override
  Future<int> getTotalLessonMinutes(String teacherId) async {
    final lessons = await getLessonsByTeacherId(teacherId);
    return lessons
        .where((l) => l.status == LessonStatus.completed)
        .fold<int>(0, (sum, l) => sum + l.durationMinutes);
  }
}
