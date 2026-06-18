import '../../domain/entities/student_entity.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/student_supabase_data_source.dart';
import '../models/student_model.dart';

/// StudentRepository'nin Supabase implementasyonu.
class StudentRepositoryImpl implements StudentRepository {
  final StudentSupabaseDataSource _dataSource;

  StudentRepositoryImpl({StudentSupabaseDataSource? dataSource})
      : _dataSource = dataSource ?? StudentSupabaseDataSource();

  @override
  Future<List<StudentEntity>> getAllStudents() async {
    final list = await _dataSource.getAllStudents();
    return List<StudentEntity>.from(list);
  }

  @override
  Future<List<StudentEntity>> getStudentsByTeacherId(String teacherId) async {
    final list = await _dataSource.getStudentsByTeacherId(teacherId);
    return List<StudentEntity>.from(list);
  }

  Future<List<StudentEntity>> getStudentsByUserId(String userId) async {
    final list = await _dataSource.getStudentsByUserId(userId);
    return List<StudentEntity>.from(list);
  }

  @override
  Future<StudentEntity?> getStudentById(String id) =>
      _dataSource.getStudentById(id);

  @override
  Future<StudentEntity> createStudent(StudentEntity student) =>
      _dataSource.createStudent(StudentModel.fromEntity(student));

  @override
  Future<StudentEntity> updateStudent(StudentEntity student) =>
      _dataSource.updateStudent(StudentModel.fromEntity(student));

  @override
  Future<void> deleteStudent(String id) => _dataSource.deleteStudent(id);

  @override
  Future<int> getActiveStudentCount(String teacherId) async {
    final students = await getStudentsByTeacherId(teacherId);
    return students.where((s) => s.isActive).length;
  }
}
