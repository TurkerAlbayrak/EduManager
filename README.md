# 🎓 EduManager - Profesyonel Eğitim Yönetim Sistemi

EduManager, özel ders veren öğretmenlerin ve öğrencilerin iletişimini, ödev süreçlerini, ders planlamasını ve öğrenci takibini tek bir sistem üzerinden profesyonelce yönetebilmesi için geliştirilmiş modern bir Flutter uygulamasıdır.

![Flutter](https://img.shields.io/badge/Flutter-v3.44.2-blue.svg?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-v3.4-blue.svg?logo=dart)
![Architecture](https://img.shields.io/badge/Architecture-Clean_Architecture-success)
![State Management](https://img.shields.io/badge/State_Management-Provider-orange)

---

## 🌟 Özellikler

### 👨‍🏫 Öğretmen Modülü
* **Dashboard:** Tamamlanan ve bekleyen ödevlerin istatistikleri, pasta grafik analizleri ve yaklaşan derslerin özeti.
* **Öğrenci Yönetimi:** Sisteme yeni öğrenci ekleme, mevcut öğrencileri düzenleme ve silme. Arama ve filtreleme yetenekleri.
* **Ödev Yönetimi:** Çoklu öğrencilere eş zamanlı ödev atama, ödevlerin teslim durumlarını takip etme (Gecikmiş, Bekliyor, Tamamlandı).
* **Ders Planlama:** Öğrencilerle yapılacak derslerin takvime eklenmesi, süre ve konu belirlenmesi.
* **Takvim:** `table_calendar` tabanlı interaktif takvim ile ders ve ödev teslim tarihlerinin aynı ekran üzerinden takibi.

### 👩‍🎓 Öğrenci Modülü
* **Öğrenci Dashboard:** Yaklaşan dersler ve kişisel ödev istatistikleri.
* **Ödev Takibi:** Öğretmen tarafından atanan ödevleri görüntüleme ve "Tamamla" durumu bildirme.
* **Ders Geçmişi:** Planlanan ve tamamlanan derslerin listesi.

### ⚙️ Teknik Özellikler
* **Clean Architecture:** Uygulama `Core`, `Domain`, `Data` ve `Presentation` katmanlarına ayrılarak SOLID prensiplerine uygun inşa edilmiştir.
* **Tema Desteği:** Kullanıcı tercihini hatırlayan (persistent) Dark ve Light mod geçişi.
* **Responsive Tasarım:** Web, Tablet ve Mobil platformlar için optimize edilmiş arayüz (Desktop için Sidebar, Mobil için Bottom Navigation).
* **Routing:** `go_router` kullanılarak deklaratif ve güvenli sayfa geçişleri.
* **Animasyonlar:** `flutter_animate` ile pürüzsüz ve modern UI etkileşimleri.

---

## 🏗️ Mimari Yapı

Projede **Clean Architecture** benimsenmiştir. Bu yapı sayesinde gelecekte (Supabase, Firebase, PostgreSQL gibi) backend sistemlerine geçiş son derece kolay olacaktır. Şu anda veriler, soyutlanmış `Repository` katmanı üzerinden uygulamanın `assets/json/` dizinindeki yerel JSON dosyalarından okunmaktadır.

```
lib/
├── core/           # Tema, sabitler, util sınıfları, servisler (Navigation vb.)
├── domain/         # Entity'ler, Repository Interface'leri
├── data/           # Model sınıfları, Data Source (JSON Okuma), Repository Implementasyonları
└── presentation/   # Ekranlar (Screens), Widget'lar ve State Management (Provider)
```

---

## 🚀 Kurulum ve Çalıştırma

### Gereksinimler
* [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.44.2 veya üzeri)
* Dart SDK

### Adımlar

1. **Repoyu Klonlayın**
   ```bash
   git clone https://github.com/KULLANICI_ADI/teachstudentapp.git
   cd teachstudentapp
   ```

2. **Bağımlılıkları Yükleyin**
   ```bash
   flutter pub get
   ```

3. **Uygulamayı Çalıştırın**
   * Web üzerinde test etmek için:
     ```bash
     flutter run -d chrome
     ```
   * Mobil emülatörde test etmek için:
     ```bash
     flutter run
     ```

---

## 🎨 Renk Paleti ve Tasarım

Projede modern bir görünüm için Material 3 dizayn standartları kullanılmıştır:
- **Primary:** `#2563EB` (Mavi)
- **Success:** `#16A34A` (Yeşil)
- **Warning:** `#F59E0B` (Sarı)
- **Danger:** `#DC2626` (Kırmızı)

---

## 📝 Demo Hesaplar

Uygulamayı test etmek için Giriş (Login) ekranındaki **"Öğretmen Demosu"** ve **"Öğrenci Demosu"** butonlarını kullanabilirsiniz.

---

*Geliştirici:* [İsminiz/Kullanıcı Adınız]
