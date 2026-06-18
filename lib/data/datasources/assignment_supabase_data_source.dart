import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/assignment_model.dart';

class AssignmentSupabaseDataSource {
  final _supabase = Supabase.instance.client;

  Future<List<AssignmentModel>> getAllAssignments() async {
    final response = await _supabase.from('assignments').select();
    return response.map((e) => AssignmentModel.fromJson(e)).toList();
  }

  Future<List<AssignmentModel>> getAssignmentsByTeacherId(String teacherId) async {
    final response = await _supabase.from('assignments').select().eq('teacherId', teacherId);
    return response.map((e) => AssignmentModel.fromJson(e)).toList();
  }

  Future<List<AssignmentModel>> getAssignmentsByStudentId(String studentId) async {
    // assignedStudentIds is a JSON array
    final response = await _supabase.from('assignments').select().contains('assignedStudentIds', '["$studentId"]');
    return response.map((e) => AssignmentModel.fromJson(e)).toList();
  }

  Future<List<AssignmentModel>> getAssignmentsByStudentIds(List<String> studentIds) async {
    // If studentIds is empty, don't query
    if (studentIds.isEmpty) return [];

    // Supabase allows us to query if a JSONB array contains ANY of the given values using overlaps or multiple OR clauses.
    // For simplicity, since we might have very few studentIds per user, we can just fetch all assignments and filter locally
    // OR we can use the 'cs' operator with OR.
    // Given the constraints, let's fetch all assignments and filter locally like we did with JSON, or write an RPC.
    // Let's do it safely:
    final response = await _supabase.from('assignments').select();
    final allAssignments = response.map((e) => AssignmentModel.fromJson(e)).toList();
    
    return allAssignments
        .where((a) => a.assignedStudentIds.any((id) => studentIds.contains(id)))
        .toList();
  }

  Future<AssignmentModel?> getAssignmentById(String id) async {
    final response = await _supabase.from('assignments').select().eq('id', id).maybeSingle();
    if (response == null) return null;
    return AssignmentModel.fromJson(response);
  }

  Future<AssignmentModel> createAssignment(AssignmentModel assignment) async {
    final response = await _supabase.from('assignments').insert(assignment.toJson()).select().single();
    return AssignmentModel.fromJson(response);
  }

  Future<AssignmentModel> updateAssignment(AssignmentModel assignment) async {
    final response = await _supabase
        .from('assignments')
        .update(assignment.toJson())
        .eq('id', assignment.id)
        .select()
        .single();
    return AssignmentModel.fromJson(response);
  }

  Future<void> deleteAssignment(String id) async {
    await _supabase.from('assignments').delete().eq('id', id);
  }
}
