import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/student_model.dart';

class StudentSupabaseDataSource {
  final _supabase = Supabase.instance.client;

  Future<List<StudentModel>> getAllStudents() async {
    final response = await _supabase.from('students').select();
    return response.map((e) => StudentModel.fromJson(e)).toList();
  }

  Future<List<StudentModel>> getStudentsByTeacherId(String teacherId) async {
    final response = await _supabase.from('students').select().eq('teacherId', teacherId);
    return response.map((e) => StudentModel.fromJson(e)).toList();
  }

  Future<List<StudentModel>> getStudentsByUserId(String userId) async {
    if (userId.isEmpty) return [];
    final response = await _supabase.from('students').select().eq('userId', userId);
    return response.map((e) => StudentModel.fromJson(e)).toList();
  }

  Future<StudentModel?> getStudentById(String id) async {
    final response = await _supabase.from('students').select().eq('id', id).maybeSingle();
    if (response == null) return null;
    return StudentModel.fromJson(response);
  }

  Future<StudentModel> createStudent(StudentModel student) async {
    final response = await _supabase.from('students').insert(student.toJson()).select().single();
    return StudentModel.fromJson(response);
  }

  Future<StudentModel> updateStudent(StudentModel student) async {
    final response = await _supabase
        .from('students')
        .update(student.toJson())
        .eq('id', student.id)
        .select()
        .single();
    return StudentModel.fromJson(response);
  }

  Future<void> deleteStudent(String id) async {
    await _supabase.from('students').delete().eq('id', id);
  }
}
