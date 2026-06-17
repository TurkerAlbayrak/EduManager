/// Kullanıcı rolleri.
enum UserRole { teacher, student }

/// Kullanıcı entity'si. Domain katmanında kullanılır.
/// Saf Dart sınıfı — herhangi bir framework'e bağımlı değildir.
class UserEntity {
  final String id;
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final String? avatarUrl;
  final DateTime createdAt;
  final String? linkedStudentId; // Öğrenci rolü için ilişkili student kaydı

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.avatarUrl,
    required this.createdAt,
    this.linkedStudentId,
  });

  /// Öğretmen mi?
  bool get isTeacher => role == UserRole.teacher;

  /// Öğrenci mi?
  bool get isStudent => role == UserRole.student;

  /// Kopyalama metodu.
  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    UserRole? role,
    String? avatarUrl,
    DateTime? createdAt,
    String? linkedStudentId,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      linkedStudentId: linkedStudentId ?? this.linkedStudentId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
