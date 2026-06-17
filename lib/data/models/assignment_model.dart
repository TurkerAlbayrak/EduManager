import '../../domain/entities/assignment_entity.dart';

/// Assignment model — JSON serileştirme/deserileştirme için.
class AssignmentModel extends AssignmentEntity {
  const AssignmentModel({
    required super.id,
    required super.teacherId,
    required super.title,
    required super.description,
    required super.createdAt,
    required super.dueDate,
    required super.assignedStudentIds,
    required super.status,
    required super.completionPercentage,
  });

  /// JSON'dan model oluşturur.
  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as String,
      teacherId: json['teacherId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      assignedStudentIds: List<String>.from(json['assignedStudentIds'] ?? []),
      status: _parseStatus(json['status'] as String),
      completionPercentage: json['completionPercentage'] as int? ?? 0,
    );
  }

  /// Model'i JSON'a dönüştürür.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacherId': teacherId,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'assignedStudentIds': assignedStudentIds,
      'status': _statusToString(status),
      'completionPercentage': completionPercentage,
    };
  }

  /// Entity'den model oluşturur.
  factory AssignmentModel.fromEntity(AssignmentEntity entity) {
    return AssignmentModel(
      id: entity.id,
      teacherId: entity.teacherId,
      title: entity.title,
      description: entity.description,
      createdAt: entity.createdAt,
      dueDate: entity.dueDate,
      assignedStudentIds: entity.assignedStudentIds,
      status: entity.status,
      completionPercentage: entity.completionPercentage,
    );
  }

  static AssignmentStatus _parseStatus(String status) {
    switch (status) {
      case 'pending':
        return AssignmentStatus.pending;
      case 'inProgress':
        return AssignmentStatus.inProgress;
      case 'completed':
        return AssignmentStatus.completed;
      case 'overdue':
        return AssignmentStatus.overdue;
      default:
        return AssignmentStatus.pending;
    }
  }

  static String _statusToString(AssignmentStatus status) {
    switch (status) {
      case AssignmentStatus.pending:
        return 'pending';
      case AssignmentStatus.inProgress:
        return 'inProgress';
      case AssignmentStatus.completed:
        return 'completed';
      case AssignmentStatus.overdue:
        return 'overdue';
    }
  }
}
