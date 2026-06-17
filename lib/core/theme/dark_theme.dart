import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors_theme.dart';

/// Dark tema tanımı. Material 3 ile uyumlu.
ThemeData buildDarkTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColorsTheme.primary,
    brightness: Brightness.dark,
    primary: AppColorsTheme.primaryLight,
    onPrimary: AppColorsTheme.darkBackground,
    primaryContainer: AppColorsTheme.primaryDark,
    secondary: AppColorsTheme.primaryLight,
    surface: AppColorsTheme.darkSurface,
    error: AppColorsTheme.dangerLight,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColorsTheme.darkBackground,
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: AppColorsTheme.darkTextPrimary,
      displayColor: AppColorsTheme.darkTextPrimary,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: AppColorsTheme.darkSurface,
      foregroundColor: AppColorsTheme.darkTextPrimary,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColorsTheme.darkTextPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColorsTheme.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColorsTheme.darkBorder.withValues(alpha: 0.3)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColorsTheme.primaryLight,
        side: const BorderSide(color: AppColorsTheme.primaryLight),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColorsTheme.primaryLight,
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColorsTheme.darkSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColorsTheme.darkBorder.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColorsTheme.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColorsTheme.dangerLight),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.inter(
        color: AppColorsTheme.darkTextTertiary,
        fontSize: 14,
      ),
      labelStyle: GoogleFonts.inter(
        color: AppColorsTheme.darkTextSecondary,
        fontSize: 14,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColorsTheme.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColorsTheme.darkSurfaceVariant,
      labelStyle: GoogleFonts.inter(fontSize: 13, color: AppColorsTheme.darkTextPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      side: BorderSide.none,
    ),
    dividerTheme: DividerThemeData(
      color: AppColorsTheme.darkBorder.withValues(alpha: 0.3),
      thickness: 1,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColorsTheme.darkSurface,
      selectedItemColor: AppColorsTheme.primaryLight,
      unselectedItemColor: AppColorsTheme.darkTextTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: AppColorsTheme.darkSurface,
      selectedIconTheme: const IconThemeData(color: AppColorsTheme.primaryLight),
      unselectedIconTheme: IconThemeData(color: AppColorsTheme.darkTextTertiary),
      indicatorColor: AppColorsTheme.primaryDark,
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: AppColorsTheme.darkSurface,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
