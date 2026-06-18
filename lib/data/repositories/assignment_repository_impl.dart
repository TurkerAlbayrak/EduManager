import '../../domain/entities/assignment_entity.dart';
import '../../domain/repositories/assignment_repository.dart';
import '../datasources/assignment_supabase_data_source.dart';
import '../models/assignment_model.dart';

/// AssignmentRepository'nin Supabase implementasyonu.
class AssignmentRepositoryImpl implements AssignmentRepository {
  final AssignmentSupabaseDataSource _dataSource;

  AssignmentRepositoryImpl({AssignmentSupabaseDataSource? dataSource})
      : _dataSource = dataSource ?? AssignmentSupabaseDataSource();

  @override
  Future<List<AssignmentEntity>> getAssignmentsByTeacherId(String teacherId) async {
    final list = await _dataSource.getAssignmentsByTeacherId(teacherId);
    return List<AssignmentEntity>.from(list);
  }

  @override
  Future<List<AssignmentEntity>> getAssignmentsByStudentId(String studentId) async {
    final list = await _dataSource.getAssignmentsByStudentId(studentId);
    return List<AssignmentEntity>.from(list);
  }

  Future<List<AssignmentEntity>> getAssignmentsByStudentIds(List<String> studentIds) async {
    final list = await _dataSource.getAssignmentsByStudentIds(studentIds);
    return List<AssignmentEntity>.from(list);
  }

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
