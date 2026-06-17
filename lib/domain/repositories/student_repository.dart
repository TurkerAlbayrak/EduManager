import '../entities/student_entity.dart';

/// Öğrenci repository arayüzü.
abstract class StudentRepository {
  /// Öğretmene ait tüm öğrencileri getirir.
  Future<List<StudentEntity>> getStudentsByTeacherId(String teacherId);

  /// ID ile öğrenci getirir.
  Future<StudentEntity?> getStudentById(String id);

  /// Yeni öğrenci oluşturur.
  Future<StudentEntity> createStudent(StudentEntity student);

  /// Öğrenci günceller.
  Future<StudentEntity> updateStudent(StudentEntity student);

  /// Öğrenci siler.
  Future<void> deleteStudent(String id);

  /// Aktif öğrenci sayısını getirir.
  Future<int> getActiveStudentCount(String teacherId);
}
