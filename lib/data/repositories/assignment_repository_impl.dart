import '../../domain/entities/assignment_entity.dart';
import '../../domain/repositories/assignment_repository.dart';
import '../datasources/assignment_local_data_source.dart';
import '../models/assignment_model.dart';

/// AssignmentRepository'nin yerel JSON implementasyonu.
class AssignmentRepositoryImpl implements AssignmentRepository {
  final AssignmentLocalDataSource _dataSource;

  AssignmentRepositoryImpl({AssignmentLocalDataSource? dataSource})
      : _dataSource = dataSource ?? AssignmentLocalDataSource();

  @override
  Future<List<AssignmentEntity>> getAssignmentsByTeacherId(String teacherId) =>
      _dataSource.getAssignmentsByTeacherId(teacherId);

  @override
  Future<List<AssignmentEntity>> getAssignmentsByStudentId(String studentId) =>
      _dataSource.getAssignmentsByStudentId(studentId);

  @override
  Future<AssignmentEntity?> getAssignmentById(String id) =>
      _dataSource.getAssignmentById(id);

  @override
  Future<AssignmentEntity> createAssignment(AssignmentEntity assignment) =>
      _dataSource.createAssignment(AssignmentModel.fromEntity(assignment));

  @override
  Future<AssignmentEntity> updateAssignment(AssignmentEntity assignment) =>
      _dataSource.updateAssignment(AssignmentModel.fromEntity(assignment));

  @override
  Future<void> deleteAssignment(String id) => _dataSource.deleteAssignment(id);

  @override
  Future<int> getPendingAssignmentCount(String teacherId) async {
    final assignments = await getAssignmentsByTeacherId(teacherId);
    return assignments
        .where((a) =>
            a.status == AssignmentStatus.pending ||
            a.status == AssignmentStatus.inProgress)
        .length;
  }

  @override
  Future<int> getCompletedAssignmentCount(String teacherId) async {
    final assignments = await getAssignmentsByTeacherId(teacherId);
    return assignments
        .where((a) => a.status == AssignmentStatus.completed)
        .length;
  }
}
