import 'dart:convert';
import 'package:flutter/services.dart';

/// JSON dosyalarından veri okuma/yazma servisi.
/// İlk sürümde assets/json klasöründen okuma yapar.
/// Gelecekte Supabase/Firebase'e geçişte bu katman değiştirilir.
class JsonStorageService {
  JsonStorageService._();
  static final JsonStorageService instance = JsonStorageService._();

  final Map<String, List<Map<String, dynamic>>> _cache = {};

  /// JSON dosyasını assets'den yükler.
  Future<List<Map<String, dynamic>>> loadJsonFile(String fileName) async {
    // Önce cache'de ara
    if (_cache.containsKey(fileName)) {
      return List<Map<String, dynamic>>.from(_cache[fileName]!);
    }

    try {
      final jsonString = await rootBundle.loadString('assets/json/$fileName');
      final List<dynamic> jsonData = json.decode(jsonString);
      final data = jsonData.cast<Map<String, dynamic>>();

      // Cache'e kaydet
      _cache[fileName] = List<Map<String, dynamic>>.from(data);

      return data;
    } catch (e) {
      // Dosya bulunamazsa boş liste döndür
      return [];
    }
  }

  /// Cache'deki tüm verileri getirir.
  List<Map<String, dynamic>> getCachedData(String fileName) {
    return List<Map<String, dynamic>>.from(_cache[fileName] ?? []);
  }

  /// Cache'e yeni veri ekler.
  void addToCache(String fileName, Map<String, dynamic> item) {
    _cache[fileName] ??= [];
    _cache[fileName]!.add(item);
  }

  /// Cache'deki bir veriyi günceller.
  void updateInCache(String fileName, String id, Map<String, dynamic> updatedItem) {
    if (_cache.containsKey(fileName)) {
      final index = _cache[fileName]!.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        _cache[fileName]![index] = updatedItem;
      }
    }
  }

  /// Cache'den bir veri siler.
  void removeFromCache(String fileName, String id) {
    if (_cache.containsKey(fileName)) {
      _cache[fileName]!.removeWhere((item) => item['id'] == id);
    }
  }

  /// Belirli bir dosyanın cache'ini temizler.
  void clearCache(String fileName) {
    _cache.remove(fileName);
  }

  /// Tüm cache'i temizler.
  void clearAllCache() {
    _cache.clear();
  }

  /// Cache'deki veriyi JSON string'e dönüştürür (debug için).
  String toJsonString(String fileName) {
    if (_cache.containsKey(fileName)) {
      return const JsonEncoder.withIndent('  ').convert(_cache[fileName]);
    }
    return '[]';
  }
}
