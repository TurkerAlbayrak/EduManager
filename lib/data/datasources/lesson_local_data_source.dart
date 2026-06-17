import '../../core/constants/app_constants.dart';
import '../../core/services/json_storage_service.dart';
import '../models/lesson_model.dart';

/// Ders verilerini JSON'dan okuyan data source.
class LessonLocalDataSource {
  final JsonStorageService _storage = JsonStorageService.instance;

  Future<List<LessonModel>> getAllLessons() async {
    final data = await _storage.loadJsonFile(AppConstants.lessonsFile);
    return data.map((json) => LessonModel.fromJson(json)).toList();
  }

  Future<List<LessonModel>> getLessonsByTeacherId(String teacherId) async {
    final lessons = await getAllLessons();
    return lessons.where((l) => l.teacherId == teacherId).toList();
  }

  Future<List<LessonModel>> getLessonsByStudentId(String studentId) async {
    final lessons = await getAllLessons();
    return lessons.where((l) => l.studentId == studentId).toList();
  }

  Future<List<LessonModel>> getLessonsByDate(String teacherId, DateTime date) async {
    final lessons = await getLessonsByTeacherId(teacherId);
    return lessons.where((l) {
      return l.date.year == date.year &&
          l.date.month == date.month &&
          l.date.day == date.day;
    }).toList();
  }

  Future<LessonModel?> getLessonById(String id) async {
    final lessons = await getAllLessons();
    try {
      return lessons.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<LessonModel> createLesson(LessonModel lesson) async {
    _storage.addToCache(AppConstants.lessonsFile, lesson.toJson());
    return lesson;
  }

  Future<LessonModel> updateLesson(LessonModel lesson) async {
    _storage.updateInCache(AppConstants.lessonsFile, lesson.id, lesson.toJson());
    return lesson;
  }

  Future<void> deleteLesson(String id) async {
    _storage.removeFromCache(AppConstants.lessonsFile, id);
  }
}
