import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tema state management.
/// Light/Dark mode geçişi ve tercih kaydetme.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadThemePreference();
  }

  /// Tema modunu değiştir.
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveThemePreference();
    notifyListeners();
  }

  /// Belirli bir tema moduna geç.
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveThemePreference();
    notifyListeners();
  }

  /// Kaydedilmiş tema tercihini yükle.
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool('isDarkMode') ?? false;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (_) {
      // SharedPreferences kullanılamıyorsa varsayılan light mode
    }
  }

  /// Tema tercihini kaydet.
  Future<void> _saveThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', isDarkMode);
    } catch (_) {
      // Kaydetme başarısız olsa da devam et
    }
  }
}
