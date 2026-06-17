import '../entities/user_entity.dart';

/// Kullanıcı repository arayüzü.
/// Data katmanında implement edilir.
/// Gelecekte farklı backend'ler için aynı arayüz kullanılır.
abstract class UserRepository {
  /// Tüm kullanıcıları getirir.
  Future<List<UserEntity>> getAllUsers();

  /// ID ile kullanıcı getirir.
  Future<UserEntity?> getUserById(String id);

  /// E-posta ve şifre ile giriş yapar.
  Future<UserEntity?> login(String email, String password);

  /// Kullanıcı oluşturur.
  Future<UserEntity> createUser(UserEntity user);

  /// Kullanıcı günceller.
  Future<UserEntity> updateUser(UserEntity user);
}
