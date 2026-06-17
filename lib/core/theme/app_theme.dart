import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

/// Ana tema sınıfı. Light ve Dark temaları merkezi olarak sunar.
class AppTheme {
  AppTheme._();

  static ThemeData get light => buildLightTheme();
  static ThemeData get dark => buildDarkTheme();
}
