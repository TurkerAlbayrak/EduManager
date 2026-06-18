import '../../domain/entities/user_entity.dart';

/// User model — JSON serileştirme/deserileştirme için.
/// Entity'den genişletilir, veri katmanı detaylarını içerir.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.password,
    required super.role,
    super.avatarUrl,
    required super.createdAt,
    super.linkedStudentId,
  });

  /// JSON'dan model oluşturur.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: json['role'] == 'teacher' ? UserRole.teacher : UserRole.student,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      linkedStudentId: json['linkedStudentId'] as String?,
    );
  }

  /// Model'i JSON'a dönüştürür.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role == UserRole.teacher ? 'teacher' : 'student',
      'createdAt': createdAt.toIso8601String(),
    };
    if (avatarUrl != null) map['avatarUrl'] = avatarUrl;
    if (linkedStudentId != null) map['linkedStudentId'] = linkedStudentId;
    return map;
  }

  /// Entity'den model oluşturur.
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      password: entity.password,
      role: entity.role,
      avatarUrl: entity.avatarUrl,
      createdAt: entity.createdAt,
      linkedStudentId: entity.linkedStudentId,
    );
  }
}
