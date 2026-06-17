import '../entities/assignment_entity.dart';

/// Ödev repository arayüzü.
abstract class AssignmentRepository {
  /// Öğretmene ait tüm ödevleri getirir.
  Future<List<AssignmentEntity>> getAssignmentsByTeacherId(String teacherId);

  /// Öğrenciye atanmış tüm ödevleri getirir.
  Future<List<AssignmentEntity>> getAssignmentsByStudentId(String studentId);

  /// ID ile ödev getirir.
  Future<AssignmentEntity?> getAssignmentById(String id);

  /// Yeni ödev oluşturur.
  Future<AssignmentEntity> createAssignment(AssignmentEntity assignment);

  /// Ödev günceller.
  Future<AssignmentEntity> updateAssignment(AssignmentEntity assignment);

  /// Ödev siler.
  Future<void> deleteAssignment(String id);

  /// Bekleyen ödev sayısını getirir.
  Future<int> getPendingAssignmentCount(String teacherId);

  /// Tamamlanan ödev sayısını getirir.
  Future<int> getCompletedAssignmentCount(String teacherId);
}
