import 'package:flutter/material.dart';
import '../../domain/entities/assignment_entity.dart';
import '../../data/repositories/assignment_repository_impl.dart';
import '../../data/repositories/student_repository_impl.dart';
import 'package:uuid/uuid.dart';

/// Ödev state management.
/// CRUD işlemleri, filtreleme ve istatistikler.
class AssignmentProvider extends ChangeNotifier {
  final AssignmentRepositoryImpl _repository = AssignmentRepositoryImpl();
  final StudentRepositoryImpl _studentRepository = StudentRepositoryImpl();
  static const _uuid = Uuid();

  List<AssignmentEntity> _assignments = [];
  bool _isLoading = false;
  String? _error;
  String _filterStatus = 'all';

  List<AssignmentEntity> get assignments =>
      _filterStatus == 'all' ? _assignments : filteredAssignments;
  String? get error => _error;

  List<AssignmentEntity> get filteredAssignments {
    if (_filterStatus == 'all') return _assignments;
    return _assignments.where((a) {
      switch (_filterStatus) {
        case 'pending':
          return a.status == AssignmentStatus.pending;
        case 'inProgress':
          return a.status == AssignmentStatus.inProgress;
        case 'completed':
          return a.status == AssignmentStatus.completed;
        case 'overdue':
          return a.status == AssignmentStatus.overdue;
        default:
          return true;
      }
    }).toList();
  }

  bool get isLoading => _isLoading;
  String get filterStatus => _filterStatus;

  int get totalCount => _assignments.length;
  int get pendingCount =>
      _assignments.where((a) => a.status == AssignmentStatus.pending).length;
  int get inProgressCount =>
      _assignments.where((a) => a.status == AssignmentStatus.inProgress).length;
  int get completedCount =>
      _assignments.where((a) => a.status == AssignmentStatus.completed).length;
  int get overdueCount =>
      _assignments.where((a) => a.status == AssignmentStatus.overdue).length;

  /// Öğretmene ait ödevleri yükle.
  Future<void> loadAssignments(String teacherId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _assignments = await _repository.getAssignmentsByTeacherId(teacherId);
      // Otomatik overdue kontrolü
      _checkOverdueAssignments();
    } catch (e) {
      _assignments = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Öğrenciye ait ödevleri yükle. (Artık userId alıyor)
  Future<void> loadStudentAssignments(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Kullanıcının dahil olduğu tüm öğrenci kayıtlarını bul
      final studentRecords = await _studentRepository.getStudentsByUserId(userId);
      final studentIds = studentRecords.map((s) => s.id).toList();

      if (studentIds.isEmpty) {
        _assignments = [];
      } else {
        // 2. O öğrenci kayıtlarına atanmış ödevleri getir
        _assignments = await _repository.getAssignmentsByStudentIds(studentIds);
        _checkOverdueAssignments();
      }
    } catch (e) {
      _error = e.toString();
      _assignments = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Yeni ödev oluştur.
  Future<AssignmentEntity> createAssignment({
    required String teacherId,
    required String title,
    required String description,
    required DateTime dueDate,
    required List<String> assignedStudentIds,
  }) async {
    final assignment = AssignmentEntity(
      id: _uuid.v4(),
      teacherId: teacherId,
      title: title,
      description: description,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      assignedStudentIds: assignedStudentIds,
      status: AssignmentStatus.pending,
      completionPercentage: 0,
    );

    final created = await _repository.createAssignment(assignment);
    _assignments.add(created);
    notifyListeners();
    return created;
  }

  /// Ödev güncelle.
  Future<void> updateAssignment(AssignmentEntity assignment) async {
    await _repository.updateAssignment(assignment);
    final index = _assignments.indexWhere((a) => a.id == assignment.id);
    if (index != -1) {
      _assignments[index] = assignment;
      notifyListeners();
    }
  }

  /// Ödev sil.
  Future<void> deleteAssignment(String id) async {
    await _repository.deleteAssignment(id);
    _assignments.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  /// Ödevi tamamlandı olarak işaretle (öğrenci tarafı).
  Future<void> markAsCompleted(String assignmentId) async {
    final index = _assignments.indexWhere((a) => a.id == assignmentId);
    if (index != -1) {
      final updated = _assignments[index].copyWith(
        status: AssignmentStatus.completed,
        completionPercentage: 100,
      );
      await _repository.updateAssignment(updated);
      _assignments[index] = updated;
      notifyListeners();
    }
  }

  /// Filtre değiştir.
  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  /// Gecikmiş ödevleri kontrol et ve durumlarını güncelle.
  void _checkOverdueAssignments() {
    final now = DateTime.now();
    for (int i = 0; i < _assignments.length; i++) {
      final a = _assignments[i];
      if (a.dueDate.isBefore(now) &&
          a.status != AssignmentStatus.completed &&
          a.status != AssignmentStatus.overdue) {
        _assignments[i] = a.copyWith(status: AssignmentStatus.overdue);
      }
    }
  }
}
