import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Dart uzantıları (extensions) - yaygın kullanılan
/// işlemleri kolaylaştırmak için.

/// String uzantıları.
extension StringExtension on String {
  /// İlk harfi büyük yapar.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Her kelimenin ilk harfini büyük yapar.
  String get titleCase {
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Ad soyad kısaltması. Örn: "Ahmet Yılmaz" -> "AY"
  String get initials {
    final parts = trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return isNotEmpty ? this[0].toUpperCase() : '';
  }
}

/// DateTime uzantıları.
extension DateTimeExtension on DateTime {
  /// Sadece tarih kısmını alır (saat sıfırlanır).
  DateTime get dateOnly => DateTime(year, month, day);

  /// Aynı gün mü kontrolü.
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Aynı ay mı kontrolü.
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }
}

/// BuildContext uzantıları.
extension ContextExtension on BuildContext {
  /// Ekran genişliği.
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Ekran yüksekliği.
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Mobil mi?
  bool get isMobile => screenWidth < 600;

  /// Tablet mi?
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;

  /// Desktop mi?
  bool get isDesktop => screenWidth >= 1200;

  /// Mevcut tema.
  ThemeData get theme => Theme.of(this);

  /// Mevcut renk şeması.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Mevcut text teması.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Dark mode mu?
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Snackbar göster.
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.danger : AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Onay dialog'u göster.
  Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Onayla',
    String cancelText = 'İptal',
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: isDangerous
                ? ElevatedButton.styleFrom(backgroundColor: AppColors.danger)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}

/// Num uzantıları.
extension NumExtension on num {
  /// SizedBox height olarak kullanım.
  SizedBox get h => SizedBox(height: toDouble());

  /// SizedBox width olarak kullanım.
  SizedBox get w => SizedBox(width: toDouble());
}
