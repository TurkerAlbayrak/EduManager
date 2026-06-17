import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/repositories/user_repository_impl.dart';

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
      _errorMessage = 'Giriş sırasında bir hata oluştu';
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
}
