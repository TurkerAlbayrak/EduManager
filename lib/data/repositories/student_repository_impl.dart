import '../../domain/entities/student_entity.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/student_local_data_source.dart';
import '../models/student_model.dart';

/// StudentRepository'nin yerel JSON implementasyonu.
class StudentRepositoryImpl implements StudentRepository {
  final StudentLocalDataSource _dataSource;

  StudentRepositoryImpl({StudentLocalDataSource? dataSource})
      : _dataSource = dataSource ?? StudentLocalDataSource();

  @override
  Future<List<StudentEntity>> getStudentsByTeacherId(String teacherId) =>
      _dataSource.getStudentsByTeacherId(teacherId);

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
