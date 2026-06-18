# 🎓 EduManager — Profesyonel Eğitim Yönetim Sistemi

EduManager, özel ders veren öğretmenler ile öğrencileri arasındaki iletişimi, ödev süreçlerini, ders planlamasını ve öğrenci takibini **tek bir platform üzerinden** yönetmeyi sağlayan, Flutter ile geliştirilmiş, Clean Architecture prensiplerine uygun, gerçek bir bulut veritabanı (Supabase) ile çalışan modern bir eğitim yönetim uygulamasıdır.

Uygulama hem **Web**, hem **Android/iOS**, hem de **tablet** üzerinde tam responsive olarak çalışır; tek bir kod tabanından (single codebase) tüm platformları hedefler.

🔗 **Canlı Demo:** [edu-manager-eosin.vercel.app](https://edu-manager-eosin.vercel.app)

![Flutter](https://img.shields.io/badge/Flutter-v3.44.2-blue.svg?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-v3.4-blue.svg?logo=dart)
![Architecture](https://img.shields.io/badge/Architecture-Clean_Architecture-success)
![Backend](https://img.shields.io/badge/Backend-Supabase-3FCF8E?logo=supabase)
![State Management](https://img.shields.io/badge/State_Management-Provider-orange)

---

## 📌 Proje Hakkında

EduManager, özellikle özel ders / bire bir eğitim veren öğretmenlerin günlük operasyonel ihtiyaçlarını çözmek için tasarlanmıştır: öğrenci kayıtlarının tutulması, ödev atama ve takibi, ders planlama/takvim yönetimi ve öğrenci tarafında şeffaf bir ilerleme görünümü. Proje, gerçek dünya bir SaaS ürününün omurgasını oluşturacak şekilde **katmanlı mimari**, **rol bazlı erişim** ve **bulut tabanlı veri kalıcılığı** ile inşa edilmiştir.

## 🌟 Temel Özellikler

### 👨‍🏫 Öğretmen Modülü
- **Dashboard:** Tamamlanan/bekleyen ödev istatistikleri, `fl_chart` ile pasta grafik analizleri ve yaklaşan derslerin özet görünümü.
- **Öğrenci Yönetimi:** Öğrenci ekleme, düzenleme, silme; arama ve filtreleme; öğrenci bazlı detay sayfası.
- **Ödev Yönetimi:** Birden fazla öğrenciye eş zamanlı ödev atama; durum takibi (Bekliyor / Devam Ediyor / Tamamlandı / Gecikti) ve tamamlanma yüzdesi.
- **Ders Planlama:** Öğrenciyle yapılacak dersin tarihi, saati, süresi ve konusunun planlanması; ders notu ekleme.
- **İnteraktif Takvim:** `table_calendar` tabanlı takvim üzerinde ders ve ödev teslim tarihlerinin birlikte görüntülenmesi.
- **Bildirim Altyapısı:** Yeni ödev ve yaklaşan ders bildirimleri için hazır servis katmanı (ileride push notification'a genişlemeye uygun).

### 👩‍🎓 Öğrenci Modülü
- **Öğrenci Dashboard:** Yaklaşan dersler ve kişisel ödev istatistiklerinin özeti.
- **Ödev Takibi:** Atanan ödevleri görüntüleme ve "Tamamlandı" olarak işaretleme.
- **Ders Geçmişi & Takvimi:** Planlanan ve tamamlanmış derslerin kronolojik listesi.

### ⚙️ Teknik Öne Çıkanlar
- **Clean Architecture:** `core / domain / data / presentation` olarak ayrılmış, SOLID prensiplerine uygun katmanlı yapı.
- **Supabase Entegrasyonu:** Veriler artık statik JSON dosyalarından değil, **Supabase (PostgreSQL + REST)** üzerinden gerçek zamanlı olarak okunup yazılıyor; ortam değişkenleri `flutter_dotenv` ile `.env` dosyasından güvenli şekilde yönetiliyor.
- **Repository Pattern:** Her varlık (`User`, `Student`, `Lesson`, `Assignment`) için `Domain` katmanında soyut repository arayüzü, `Data` katmanında Supabase tabanlı implementasyon — backend değişikliği (örneğin Firebase'e geçiş) mevcut iş mantığını etkilemeden yapılabilir.
- **Rol Bazlı Yönlendirme:** `go_router` ile deklaratif routing; öğretmen ve öğrenci için ayrı "shell" (kabuk) navigasyon yapıları.
- **State Management:** `provider` ile `ChangeNotifier` tabanlı, test edilebilir ve öngörülebilir durum yönetimi (Auth, Student, Lesson, Assignment, Theme provider'ları).
- **Tema Desteği:** `shared_preferences` ile kalıcı hale getirilmiş Dark/Light tema geçişi.
- **Responsive Tasarım:** Masaüstünde kenar çubuğu (sidebar), mobilde alt navigasyon (bottom navigation) ile cihaza duyarlı arayüz.
- **Modern UI/UX:** `google_fonts` ve `flutter_animate` ile tutarlı tipografi ve akıcı geçiş animasyonları.

---

## 🏗️ Mimari Yapı

Proje, **Clean Architecture** yaklaşımıyla dört katmana ayrılmıştır. Bu sayede sunum (UI) katmanı, iş mantığından; iş mantığı da veri kaynağının teknik detaylarından (Supabase, ileride farklı bir servis vb.) tamamen izole edilmiştir.

```
lib/
├── core/                  # Tema, sabitler, validator'lar, navigasyon/bildirim servisleri
│   ├── constants/
│   ├── services/
│   ├── theme/
│   └── utils/
├── domain/                 # Framework'den bağımsız iş kuralları
│   ├── entities/            # UserEntity, StudentEntity, LessonEntity, AssignmentEntity
│   └── repositories/        # Repository arayüzleri (abstract)
├── data/                    # Veri katmanı
│   ├── models/               # Entity'lerin JSON-serileştirilebilir karşılıkları
│   ├── datasources/           # Supabase ile doğrudan haberleşen sınıflar
│   └── repositories/          # Repository arayüzlerinin Supabase implementasyonu
└── presentation/             # UI katmanı
    ├── providers/              # ChangeNotifier tabanlı state management
    ├── screens/                 # Öğretmen / Öğrenci / Auth ekranları
    └── widgets/                  # Tekrar kullanılabilir bileşenler
```

**Veri akışı:** `Screen → Provider → Repository (interface) → Repository Impl → Supabase DataSource → Supabase (PostgreSQL)`

---

## 🚀 Kurulum ve Çalıştırma

### Gereksinimler
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.44.2 veya üzeri)
- Dart SDK (^3.12.2)
- Bir [Supabase](https://supabase.com) projesi (`url` ve `anon key`)

### Adımlar

**1. Repoyu klonlayın**
```bash
git clone https://github.com/TurkerAlbayrak/EduManager.git
cd EduManager
```

**2. Bağımlılıkları yükleyin**
```bash
flutter pub get
```

**3. Ortam değişkenlerini tanımlayın**

Proje kök dizininde bir `.env` dosyası oluşturup Supabase bilgilerinizi girin:
```env
SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**4. Uygulamayı çalıştırın**
```bash
# Web üzerinde
flutter run -d chrome

# Mobil emülatör / fiziksel cihaz
flutter run
```

---

## 🎨 Tasarım Dili

Material 3 standartlarına uygun, tutarlı bir renk paleti kullanılmıştır:

| Renk | Hex | Kullanım |
|---|---|---|
| Primary | `#2563EB` | Marka rengi, vurgular |
| Success | `#16A34A` | Tamamlanan işlemler |
| Warning | `#F59E0B` | Bekleyen/uyarı durumları |
| Danger | `#DC2626` | Gecikmiş/hatalı durumlar |

---

## 🗺️ Yol Haritası (Öneriler)

- [ ] Push notification entegrasyonu (Firebase Cloud Messaging)
- [ ] Supabase Row Level Security (RLS) politikalarının dokümantasyonu
- [ ] Öğretmen–öğrenci içi mesajlaşma modülü
- [ ] Ödeme/abonelik takibi
- [ ] Çoklu dil desteği (i18n)

---

## 🛠️ Kullanılan Teknolojiler

`Flutter` · `Dart` · `Supabase` · `Provider` · `go_router` · `fl_chart` · `table_calendar` · `flutter_animate` · `google_fonts` · `shared_preferences` · `flutter_dotenv` · `uuid`

---

## 👤 Geliştirici

**Türker Albayrak**
GitHub: [@TurkerAlbayrak](https://github.com/TurkerAlbayrak)

---

## 📄 Lisans

Bu proje eğitim ve portföy amaçlı geliştirilmiştir. Kullanım koşulları için repo sahibiyle iletişime geçin.

