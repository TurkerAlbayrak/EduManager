import '../../core/constants/app_constants.dart';
import '../../core/services/json_storage_service.dart';
import '../models/assignment_model.dart';

/// Ödev verilerini JSON'dan okuyan data source.
class AssignmentLocalDataSource {
  final JsonStorageService _storage = JsonStorageService.instance;

  Future<List<AssignmentModel>> getAllAssignments() async {
    final data = await _storage.loadJsonFile(AppConstants.assignmentsFile);
    return data.map((json) => AssignmentModel.fromJson(json)).toList();
  }

  Future<List<AssignmentModel>> getAssignmentsByTeacherId(String teacherId) async {
    final assignments = await getAllAssignments();
    return assignments.where((a) => a.teacherId == teacherId).toList();
  }

  Future<List<AssignmentModel>> getAssignmentsByStudentId(String studentId) async {
    final assignments = await getAllAssignments();
    return assignments
        .where((a) => a.assignedStudentIds.contains(studentId))
        .toList();
  }

  Future<AssignmentModel?> getAssignmentById(String id) async {
    final assignments = await getAllAssignments();
    try {
      return assignments.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<AssignmentModel> createAssignment(AssignmentModel assignment) async {
    _storage.addToCache(AppConstants.assignmentsFile, assignment.toJson());
    return assignment;
  }

  Future<AssignmentModel> updateAssignment(AssignmentModel assignment) async {
    _storage.updateInCache(
      AppConstants.assignmentsFile,
      assignment.id,
      assignment.toJson(),
    );
    return assignment;
  }

  Future<void> deleteAssignment(String id) async {
    _storage.removeFromCache(AppConstants.assignmentsFile, id);
  }
}
