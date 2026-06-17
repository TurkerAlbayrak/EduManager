import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Tarih ve saat ile ilgili yardımcı fonksiyonlar.
class AppDateUtils {
  AppDateUtils._();

  static final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormat = DateFormat('dd.MM.yyyy HH:mm');
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy', 'tr_TR');
  static final DateFormat _dayMonthFormat = DateFormat('dd MMMM', 'tr_TR');
  static final DateFormat _shortDayFormat = DateFormat('dd MMM', 'tr_TR');
  static final DateFormat _isoFormat = DateFormat('yyyy-MM-dd');

  /// Tarihi dd.MM.yyyy formatında gösterir.
  static String formatDate(DateTime date) => _dateFormat.format(date);

  /// Saati HH:mm formatında gösterir.
  static String formatTime(DateTime date) => _timeFormat.format(date);

  /// Tarihi dd.MM.yyyy HH:mm formatında gösterir.
  static String formatDateTime(DateTime date) => _dateTimeFormat.format(date);

  /// Tarihi 'Haziran 2026' formatında gösterir.
  static String formatMonthYear(DateTime date) => _monthYearFormat.format(date);

  /// Tarihi '15 Haziran' formatında gösterir.
  static String formatDayMonth(DateTime date) => _dayMonthFormat.format(date);

  /// Tarihi '15 Haz' formatında gösterir.
  static String formatShortDay(DateTime date) => _shortDayFormat.format(date);

  /// Tarihi ISO formatında (yyyy-MM-dd) gösterir.
  static String formatIso(DateTime date) => _isoFormat.format(date);

  /// ISO tarihini parse eder.
  static DateTime parseIso(String dateStr) => DateTime.parse(dateStr);

  /// Tarihin bugün olup olmadığını kontrol eder.
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Tarihin yarın olup olmadığını kontrol eder.
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Tarihin geçmişte olup olmadığını kontrol eder.
  static bool isPast(DateTime date) => date.isBefore(DateTime.now());

  /// Tarihin bu hafta içinde olup olmadığını kontrol eder.
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
  }

  /// Tarihin bu ay içinde olup olmadığını kontrol eder.
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// İki tarih arasındaki gün farkını hesaplar.
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  /// Tarihi insanlar için okunabilir formata dönüştürür.
  /// Örn: "Bugün", "Yarın", "3 gün sonra", "2 gün önce"
  static String getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;

    if (diff == 0) return 'Bugün';
    if (diff == 1) return 'Yarın';
    if (diff == -1) return 'Dün';
    if (diff > 1 && diff <= 7) return '$diff gün sonra';
    if (diff < -1 && diff >= -7) return '${-diff} gün önce';
    return formatDate(date);
  }

  /// Dakikayı saat:dakika formatına dönüştürür.
  /// Örn: 90 -> "1 saat 30 dk"
  static String formatDuration(int minutes) {
    if (minutes < 60) return '$minutes dk';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '$hours saat';
    return '$hours saat $mins dk';
  }

  /// Bir saat string'ini TimeOfDay'e çevirir. Örn: "14:30"
  static TimeOfDay parseTimeString(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  /// TimeOfDay'i string'e çevirir. Örn: "14:30"
  static String timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
