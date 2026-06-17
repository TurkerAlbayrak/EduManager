import '../../core/constants/app_constants.dart';
import '../../core/services/json_storage_service.dart';
import '../models/user_model.dart';

/// Kullanıcı verilerini JSON'dan okuyan data source.
class UserLocalDataSource {
  final JsonStorageService _storage = JsonStorageService.instance;

  Future<List<UserModel>> getAllUsers() async {
    final data = await _storage.loadJsonFile(AppConstants.usersFile);
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<UserModel?> getUserById(String id) async {
    final users = await getAllUsers();
    try {
      return users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<UserModel?> login(String email, String password) async {
    final users = await getAllUsers();
    try {
      return users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  Future<UserModel> createUser(UserModel user) async {
    _storage.addToCache(AppConstants.usersFile, UserModel.fromEntity(user).toJson());
    return user;
  }

  Future<UserModel> updateUser(UserModel user) async {
    _storage.updateInCache(
      AppConstants.usersFile,
      user.id,
      UserModel.fromEntity(user).toJson(),
    );
    return user;
  }
}
