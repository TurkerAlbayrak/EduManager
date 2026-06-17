/// Ödev durumları.
enum AssignmentStatus { pending, inProgress, completed, overdue }

/// Ödev entity'si. Domain katmanında kullanılır.
class AssignmentEntity {
  final String id;
  final String teacherId;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime dueDate;
  final List<String> assignedStudentIds;
  final AssignmentStatus status;
  final int completionPercentage;

  const AssignmentEntity({
    required this.id,
    required this.teacherId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.dueDate,
    required this.assignedStudentIds,
    required this.status,
    required this.completionPercentage,
  });

  /// Ödev gecikmiş mi?
  bool get isOverdue =>
      DateTime.now().isAfter(dueDate) && status != AssignmentStatus.completed;

  /// Teslime kalan gün sayısı.
  int get daysUntilDue {
    final now = DateTime.now();
    return dueDate.difference(now).inDays;
  }

  /// Durum string'i.
  String get statusText {
    switch (status) {
      case AssignmentStatus.pending:
        return 'Bekliyor';
      case AssignmentStatus.inProgress:
        return 'Devam Ediyor';
      case AssignmentStatus.completed:
        return 'Tamamlandı';
      case AssignmentStatus.overdue:
        return 'Gecikti';
    }
  }

  /// Kopyalama metodu.
  AssignmentEntity copyWith({
    String? id,
    String? teacherId,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? dueDate,
    List<String>? assignedStudentIds,
    AssignmentStatus? status,
    int? completionPercentage,
  }) {
    return AssignmentEntity(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      assignedStudentIds: assignedStudentIds ?? this.assignedStudentIds,
      status: status ?? this.status,
      completionPercentage: completionPercentage ?? this.completionPercentage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssignmentEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
