import '../../domain/entities/lesson_entity.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../datasources/lesson_supabase_data_source.dart';
import '../models/lesson_model.dart';

/// LessonRepository'nin Supabase implementasyonu.
class LessonRepositoryImpl implements LessonRepository {
  final LessonSupabaseDataSource _dataSource;

  LessonRepositoryImpl({LessonSupabaseDataSource? dataSource})
      : _dataSource = dataSource ?? LessonSupabaseDataSource();

  @override
  Future<List<LessonEntity>> getLessonsByTeacherId(String teacherId) async {
    final list = await _dataSource.getLessonsByTeacherId(teacherId);
    return List<LessonEntity>.from(list);
  }

  @override
  Future<List<LessonEntity>> getLessonsByStudentId(String studentId) async {
    final list = await _dataSource.getLessonsByStudentId(studentId);
    return List<LessonEntity>.from(list);
  }

  Future<List<LessonEntity>> getLessonsByStudentIds(List<String> studentIds) async {
    final list = await _dataSource.getLessonsByStudentIds(studentIds);
    return List<LessonEntity>.from(list);
  }

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
