import '../../domain/entities/student_entity.dart';

/// Student model — JSON serileştirme/deserileştirme için.
class StudentModel extends StudentEntity {
  const StudentModel({
    required super.id,
    required super.teacherId,
    super.userId,
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
      userId: json['userId'] as String?,
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
    final map = <String, dynamic>{
      'id': id,
      'teacherId': teacherId,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'level': level,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
    if (userId != null) map['userId'] = userId;
    if (notes != null) map['notes'] = notes;
    return map;
  }

  /// Entity'den model oluşturur.
  factory StudentModel.fromEntity(StudentEntity entity) {
    return StudentModel(
      id: entity.id,
      teacherId: entity.teacherId,
      userId: entity.userId,
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
