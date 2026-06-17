import '../../core/constants/app_constants.dart';
import '../../core/services/json_storage_service.dart';
import '../models/student_model.dart';

/// Öğrenci verilerini JSON'dan okuyan data source.
class StudentLocalDataSource {
  final JsonStorageService _storage = JsonStorageService.instance;

  Future<List<StudentModel>> getAllStudents() async {
    final data = await _storage.loadJsonFile(AppConstants.studentsFile);
    return data.map((json) => StudentModel.fromJson(json)).toList();
  }

  Future<List<StudentModel>> getStudentsByTeacherId(String teacherId) async {
    final students = await getAllStudents();
    return students.where((s) => s.teacherId == teacherId).toList();
  }

  Future<StudentModel?> getStudentById(String id) async {
    final students = await getAllStudents();
    try {
      return students.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<StudentModel> createStudent(StudentModel student) async {
    _storage.addToCache(AppConstants.studentsFile, student.toJson());
    return student;
  }

  Future<StudentModel> updateStudent(StudentModel student) async {
    _storage.updateInCache(AppConstants.studentsFile, student.id, student.toJson());
    return student;
  }

  Future<void> deleteStudent(String id) async {
    _storage.removeFromCache(AppConstants.studentsFile, id);
  }
}
