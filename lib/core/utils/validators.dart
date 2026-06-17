/// Form validasyon fonksiyonları.
class Validators {
  Validators._();

  /// Boş alan kontrolü.
  static String? required(String? value, [String fieldName = 'Bu alan']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName zorunludur';
    }
    return null;
  }

  /// E-posta validasyonu.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-posta adresi zorunludur';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Geçersiz e-posta adresi';
    }
    return null;
  }

  /// Şifre validasyonu.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre zorunludur';
    }
    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalıdır';
    }
    return null;
  }

  /// Telefon numarası validasyonu.
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Telefon opsiyonel olabilir
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-()]'), ''))) {
      return 'Geçersiz telefon numarası';
    }
    return null;
  }

  /// Min uzunluk kontrolü.
  static String? minLength(String? value, int min, [String fieldName = 'Bu alan']) {
    if (value != null && value.trim().length < min) {
      return '$fieldName en az $min karakter olmalıdır';
    }
    return null;
  }

  /// Max uzunluk kontrolü.
  static String? maxLength(String? value, int max, [String fieldName = 'Bu alan']) {
    if (value != null && value.trim().length > max) {
      return '$fieldName en fazla $max karakter olabilir';
    }
    return null;
  }

  /// Tarih geçmişte olmamalı kontrolü.
  static String? futureDate(DateTime? date) {
    if (date == null) {
      return 'Tarih seçmelisiniz';
    }
    if (date.isBefore(DateTime.now())) {
      return 'Geçmiş tarih seçilemez';
    }
    return null;
  }

  /// Birden fazla validatörü birleştiren yardımcı fonksiyon.
  static String? Function(String?) compose(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
