import 'package:flutter/material.dart';
import '../../domain/entities/student_entity.dart';
import '../../data/repositories/student_repository_impl.dart';
import 'package:uuid/uuid.dart';

/// Öğrenci state management.
/// CRUD işlemleri ve filtreleme.
class StudentProvider extends ChangeNotifier {
  final StudentRepositoryImpl _repository = StudentRepositoryImpl();
  static const _uuid = Uuid();

  List<StudentEntity> _students = [];
  List<StudentEntity> _filteredStudents = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _filterStatus = 'all'; // all, active, passive

  List<StudentEntity> get students =>
      _searchQuery.isEmpty && _filterStatus == 'all'
          ? _students
          : _filteredStudents;
  bool get isLoading => _isLoading;
  int get totalCount => _students.length;
  int get activeCount => _students.where((s) => s.isActive).length;
  int get passiveCount => _students.where((s) => !s.isActive).length;
  String get searchQuery => _searchQuery;
  String get filterStatus => _filterStatus;

  /// Öğretmene ait öğrencileri yükle.
  Future<void> loadStudents(String teacherId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _students = await _repository.getStudentsByTeacherId(teacherId);
      _applyFilters();
    } catch (e) {
      _students = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Yeni öğrenci oluştur.
  Future<StudentEntity> createStudent({
    required String teacherId,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    String? notes,
    required String level,
  }) async {
    final now = DateTime.now();
    final student = StudentEntity(
      id: _uuid.v4(),
      teacherId: teacherId,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      notes: notes,
      level: level,
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    final created = await _repository.createStudent(student);
    _students.add(created);
    _applyFilters();
    notifyListeners();
    return created;
  }

  /// Öğrenci güncelle.
  Future<void> updateStudent(StudentEntity student) async {
    final updated = student.copyWith(updatedAt: DateTime.now());
    await _repository.updateStudent(updated);

    final index = _students.indexWhere((s) => s.id == student.id);
    if (index != -1) {
      _students[index] = updated;
      _applyFilters();
      notifyListeners();
    }
  }

  /// Öğrenci sil.
  Future<void> deleteStudent(String id) async {
    await _repository.deleteStudent(id);
    _students.removeWhere((s) => s.id == id);
    _applyFilters();
    notifyListeners();
  }

  /// Arama sorgusu değiştir.
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// Filtre durumu değiştir.
  void setFilterStatus(String status) {
    _filterStatus = status;
    _applyFilters();
    notifyListeners();
  }

  /// ID ile öğrenci bul.
  StudentEntity? getStudentById(String id) {
    try {
      return _students.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Filtreleri uygula.
  void _applyFilters() {
    _filteredStudents = _students.where((student) {
      // Status filter
      if (_filterStatus == 'active' && !student.isActive) return false;
      if (_filterStatus == 'passive' && student.isActive) return false;

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return student.fullName.toLowerCase().contains(query) ||
            student.email.toLowerCase().contains(query) ||
            student.phone.contains(query);
      }

      return true;
    }).toList();
  }
}
