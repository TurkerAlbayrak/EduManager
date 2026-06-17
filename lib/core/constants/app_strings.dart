/// Uygulama genelinde kullanılan string sabitleri.
/// Gelecekte çoklu dil desteği için bu dosya temel oluşturur.
class AppStrings {
  AppStrings._();

  // General
  static const String appName = 'EduManager';
  static const String loading = 'Yükleniyor...';
  static const String error = 'Hata';
  static const String success = 'Başarılı';
  static const String cancel = 'İptal';
  static const String save = 'Kaydet';
  static const String delete = 'Sil';
  static const String edit = 'Düzenle';
  static const String add = 'Ekle';
  static const String search = 'Ara...';
  static const String noData = 'Veri bulunamadı';
  static const String confirm = 'Onayla';
  static const String yes = 'Evet';
  static const String no = 'Hayır';
  static const String close = 'Kapat';
  static const String back = 'Geri';
  static const String next = 'İleri';
  static const String all = 'Tümü';
  static const String active = 'Aktif';
  static const String passive = 'Pasif';

  // Auth
  static const String login = 'Giriş Yap';
  static const String logout = 'Çıkış Yap';
  static const String email = 'E-posta';
  static const String password = 'Şifre';
  static const String emailHint = 'ornek@email.com';
  static const String passwordHint = '••••••••';
  static const String loginTitle = 'Hoş Geldiniz';
  static const String loginSubtitle = 'Devam etmek için giriş yapın';
  static const String invalidEmail = 'Geçersiz e-posta adresi';
  static const String invalidPassword = 'Şifre en az 6 karakter olmalı';
  static const String loginError = 'E-posta veya şifre hatalı';
  static const String rememberMe = 'Beni hatırla';

  // Navigation
  static const String dashboard = 'Dashboard';
  static const String students = 'Öğrenciler';
  static const String assignments = 'Ödevler';
  static const String lessons = 'Dersler';
  static const String calendar = 'Takvim';
  static const String notifications = 'Bildirimler';
  static const String profile = 'Profil';
  static const String settings = 'Ayarlar';

  // Dashboard
  static const String totalStudents = 'Toplam Öğrenci';
  static const String activeStudents = 'Aktif Öğrenci';
  static const String completedAssignments = 'Tamamlanan Ödev';
  static const String pendingAssignments = 'Bekleyen Ödev';
  static const String monthlyLessons = 'Bu Ay Ders';
  static const String totalLessonHours = 'Toplam Ders Süresi';
  static const String recentActivities = 'Son Aktiviteler';
  static const String upcomingLessons = 'Yaklaşan Dersler';
  static const String overdueAssignments = 'Geciken Ödevler';

  // Student
  static const String addStudent = 'Öğrenci Ekle';
  static const String editStudent = 'Öğrenci Düzenle';
  static const String deleteStudent = 'Öğrenci Sil';
  static const String studentDetail = 'Öğrenci Detayı';
  static const String firstName = 'Ad';
  static const String lastName = 'Soyad';
  static const String phone = 'Telefon';
  static const String notes = 'Notlar';
  static const String level = 'Seviye';
  static const String status = 'Durum';
  static const String deleteStudentConfirm =
      'Bu öğrenciyi silmek istediğinize emin misiniz?';
  static const String studentCreated = 'Öğrenci başarıyla oluşturuldu';
  static const String studentUpdated = 'Öğrenci başarıyla güncellendi';
  static const String studentDeleted = 'Öğrenci başarıyla silindi';

  // Assignment
  static const String addAssignment = 'Ödev Ekle';
  static const String editAssignment = 'Ödev Düzenle';
  static const String deleteAssignment = 'Ödev Sil';
  static const String assignmentDetail = 'Ödev Detayı';
  static const String title = 'Başlık';
  static const String description = 'Açıklama';
  static const String dueDate = 'Son Teslim Tarihi';
  static const String assignedStudents = 'Atanan Öğrenciler';
  static const String completionPercentage = 'Tamamlanma';
  static const String selectStudents = 'Öğrenci Seç';
  static const String deleteAssignmentConfirm =
      'Bu ödevi silmek istediğinize emin misiniz?';
  static const String assignmentCreated = 'Ödev başarıyla oluşturuldu';
  static const String assignmentUpdated = 'Ödev başarıyla güncellendi';
  static const String assignmentDeleted = 'Ödev başarıyla silindi';
  static const String markAsCompleted = 'Tamamlandı İşaretle';

  // Assignment Statuses
  static const String statusPending = 'Bekliyor';
  static const String statusInProgress = 'Devam Ediyor';
  static const String statusCompleted = 'Tamamlandı';
  static const String statusOverdue = 'Gecikti';

  // Lesson
  static const String addLesson = 'Ders Ekle';
  static const String editLesson = 'Ders Düzenle';
  static const String deleteLesson = 'Ders Sil';
  static const String lessonDetail = 'Ders Detayı';
  static const String date = 'Tarih';
  static const String time = 'Saat';
  static const String duration = 'Süre';
  static const String topic = 'Konu';
  static const String content = 'İçerik';
  static const String teacherNote = 'Öğretmen Notu';
  static const String selectStudent = 'Öğrenci Seç';
  static const String durationMinutes = 'dakika';
  static const String lessonHistory = 'Ders Geçmişi';
  static const String deleteLessonConfirm =
      'Bu dersi silmek istediğinize emin misiniz?';
  static const String lessonCreated = 'Ders başarıyla oluşturuldu';
  static const String lessonUpdated = 'Ders başarıyla güncellendi';
  static const String lessonDeleted = 'Ders başarıyla silindi';

  // Lesson Statuses
  static const String lessonScheduled = 'Planlandı';
  static const String lessonCompleted = 'Tamamlandı';
  static const String lessonCancelled = 'İptal Edildi';

  // Notification Types
  static const String notifNewAssignment = 'Yeni Ödev';
  static const String notifUpcomingLesson = 'Yaklaşan Ders';
  static const String notifOverdueAssignment = 'Geciken Ödev';
  static const String notifSystem = 'Sistem Mesajı';
  static const String markAllRead = 'Tümünü Okundu İşaretle';
  static const String noNotifications = 'Bildirim bulunmuyor';

  // Calendar
  static const String today = 'Bugün';
  static const String thisWeek = 'Bu Hafta';
  static const String thisMonth = 'Bu Ay';

  // Validation
  static const String fieldRequired = 'Bu alan zorunludur';
  static const String invalidPhoneNumber = 'Geçersiz telefon numarası';
  static const String invalidEmailAddress = 'Geçersiz e-posta adresi';
  static const String selectAtLeastOneStudent =
      'En az bir öğrenci seçmelisiniz';

  // Theme
  static const String darkMode = 'Karanlık Mod';
  static const String lightMode = 'Aydınlık Mod';

  // Delete Confirmation
  static const String deleteConfirmTitle = 'Silme Onayı';
  static const String deleteConfirmMessage =
      'Bu işlem geri alınamaz. Devam etmek istiyor musunuz?';
}
