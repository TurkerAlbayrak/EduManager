import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class UserSupabaseDataSource {
  final _supabase = Supabase.instance.client;

  Future<List<UserModel>> getAllUsers() async {
    final response = await _supabase.from('users').select();
    return response.map((e) => UserModel.fromJson(e)).toList();
  }

  Future<UserModel?> getUserById(String id) async {
    final response = await _supabase.from('users').select().eq('id', id).maybeSingle();
    if (response == null) return null;
    return UserModel.fromJson(response);
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      final authResponse = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (authResponse.user == null) return null;
      
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', authResponse.user!.id)
          .maybeSingle();

      if (response == null) return null;
      return UserModel.fromJson(response);
    } on AuthException {
      rethrow;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel> createUser(UserModel user) async {
    final authResponse = await _supabase.auth.signUp(
      email: user.email,
      password: user.password,
    );
    
    if (authResponse.user == null) throw Exception('Auth registration failed');
    
    final newUserJson = user.toJson();
    newUserJson['id'] = authResponse.user!.id; // Use Supabase Auth UUID
    
    final response = await _supabase.from('users').insert(newUserJson).select().single();
    return UserModel.fromJson(response);
  }

  Future<UserModel> updateUser(UserModel user) async {
    final response = await _supabase
        .from('users')
        .update(user.toJson())
        .eq('id', user.id)
        .select()
        .single();
    return UserModel.fromJson(response);
  }
}
