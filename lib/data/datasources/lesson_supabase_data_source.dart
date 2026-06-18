import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/lesson_model.dart';

class LessonSupabaseDataSource {
  final _supabase = Supabase.instance.client;

  Future<List<LessonModel>> getAllLessons() async {
    final response = await _supabase.from('lessons').select();
    return response.map((e) => LessonModel.fromJson(e)).toList();
  }

  Future<List<LessonModel>> getLessonsByTeacherId(String teacherId) async {
    final response = await _supabase.from('lessons').select().eq('teacherId', teacherId);
    return response.map((e) => LessonModel.fromJson(e)).toList();
  }

  Future<List<LessonModel>> getLessonsByStudentId(String studentId) async {
    final response = await _supabase.from('lessons').select().eq('studentId', studentId);
    return response.map((e) => LessonModel.fromJson(e)).toList();
  }

  Future<List<LessonModel>> getLessonsByStudentIds(List<String> studentIds) async {
    if (studentIds.isEmpty) return [];
    final response = await _supabase.from('lessons').select().inFilter('studentId', studentIds);
    return response.map((e) => LessonModel.fromJson(e)).toList();
  }

  Future<List<LessonModel>> getLessonsByDate(String teacherId, DateTime date) async {
    // Basic date filtering
    final startDate = DateTime(date.year, date.month, date.day).toIso8601String();
    final endDate = DateTime(date.year, date.month, date.day, 23, 59, 59).toIso8601String();
    
    final response = await _supabase
        .from('lessons')
        .select()
        .eq('teacherId', teacherId)
        .gte('date', startDate)
        .lte('date', endDate);
    return response.map((e) => LessonModel.fromJson(e)).toList();
  }

  Future<LessonModel?> getLessonById(String id) async {
    final response = await _supabase.from('lessons').select().eq('id', id).maybeSingle();
    if (response == null) return null;
    return LessonModel.fromJson(response);
  }

  Future<LessonModel> createLesson(LessonModel lesson) async {
    final response = await _supabase.from('lessons').insert(lesson.toJson()).select().single();
    return LessonModel.fromJson(response);
  }

  Future<LessonModel> updateLesson(LessonModel lesson) async {
    final response = await _supabase
        .from('lessons')
        .update(lesson.toJson())
        .eq('id', lesson.id)
        .select()
        .single();
    return LessonModel.fromJson(response);
  }

  Future<void> deleteLesson(String id) async {
    await _supabase.from('lessons').delete().eq('id', id);
  }
}
