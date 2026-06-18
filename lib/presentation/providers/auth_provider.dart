import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/repositories/user_repository_impl.dart';
import 'package:uuid/uuid.dart';

/// Authentication state management.
/// Kullanıcı girişi, çıkışı ve mevcut kullanıcı bilgisi yönetimi.
class AuthProvider extends ChangeNotifier {
  final UserRepositoryImpl _userRepository = UserRepositoryImpl();

  UserEntity? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserEntity? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  bool get isTeacher => _currentUser?.isTeacher ?? false;
  bool get isStudent => _currentUser?.isStudent ?? false;
  String? get errorMessage => _errorMessage;
  String get userId => _currentUser?.id ?? '';
  String get userName => _currentUser?.name ?? '';

  /// Giriş yap.
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _userRepository.login(email, password);
      if (user != null) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'E-posta veya şifre hatalı';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      if (e.toString().contains('Email not confirmed')) {
        _errorMessage = 'Lütfen e-postanızı doğrulayıp tekrar deneyin.';
      } else if (e.toString().contains('Invalid login credentials')) {
        _errorMessage = 'E-posta veya şifre hatalı';
      } else {
        _errorMessage = 'Giriş sırasında bir hata oluştu';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Çıkış yap.
  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Hata mesajını temizle.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Yeni kullanıcı kaydı.
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newUser = UserEntity(
        id: const Uuid().v4(),
        name: name,
        email: email,
        password: password,
        role: role,
        createdAt: DateTime.now(),
      );

      final created = await _userRepository.createUser(newUser);
      _currentUser = created;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Kayıt sırasında bir hata oluştu: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Kullanıcı bilgilerini güncelle
  Future<bool> updateUser({required String name, required String email}) async {
    if (_currentUser == null) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = _currentUser!.copyWith(name: name, email: email);
      final saved = await _userRepository.updateUser(updated);
      _currentUser = saved;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Güncelleme sırasında hata oluştu';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
