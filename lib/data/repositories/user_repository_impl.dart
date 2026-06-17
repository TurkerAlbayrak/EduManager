import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';
import '../models/user_model.dart';

/// UserRepository'nin yerel JSON implementasyonu.
class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource _dataSource;

  UserRepositoryImpl({UserLocalDataSource? dataSource})
      : _dataSource = dataSource ?? UserLocalDataSource();

  @override
  Future<List<UserEntity>> getAllUsers() => _dataSource.getAllUsers();

  @override
  Future<UserEntity?> getUserById(String id) => _dataSource.getUserById(id);

  @override
  Future<UserEntity?> login(String email, String password) =>
      _dataSource.login(email, password);

  @override
  Future<UserEntity> createUser(UserEntity user) =>
      _dataSource.createUser(UserModel.fromEntity(user));

  @override
  Future<UserEntity> updateUser(UserEntity user) =>
      _dataSource.updateUser(UserModel.fromEntity(user));
}
