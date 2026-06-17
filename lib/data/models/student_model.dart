import '../../domain/entities/student_entity.dart';

/// Student model — JSON serileştirme/deserileştirme için.
class StudentModel extends StudentEntity {
  const StudentModel({
    required super.id,
    required super.teacherId,
    required super.firstName,
    required super.lastName,
    required super.phone,
    required super.email,
    super.notes,
    required super.level,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  /// JSON'dan model oluşturur.
  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String,
      teacherId: json['teacherId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      notes: json['notes'] as String?,
      level: json['level'] as String,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Model'i JSON'a dönüştürür.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacherId': teacherId,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'notes': notes,
      'level': level,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Entity'den model oluşturur.
  factory StudentModel.fromEntity(StudentEntity entity) {
    return StudentModel(
      id: entity.id,
      teacherId: entity.teacherId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      phone: entity.phone,
      email: entity.email,
      notes: entity.notes,
      level: entity.level,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
