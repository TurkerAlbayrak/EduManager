/// Öğrenci entity'si. Domain katmanında kullanılır.
class StudentEntity {
  final String id;
  final String teacherId;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String? notes;
  final String level;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StudentEntity({
    required this.id,
    required this.teacherId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    this.notes,
    required this.level,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Ad soyad birleşik.
  String get fullName => '$firstName $lastName';

  /// Ad soyad baş harfleri.
  String get initials {
    final f = firstName.isNotEmpty ? firstName[0] : '';
    final l = lastName.isNotEmpty ? lastName[0] : '';
    return '$f$l'.toUpperCase();
  }

  /// Kopyalama metodu.
  StudentEntity copyWith({
    String? id,
    String? teacherId,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? notes,
    String? level,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudentEntity(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      notes: notes ?? this.notes,
      level: level ?? this.level,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
