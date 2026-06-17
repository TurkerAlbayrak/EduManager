/// Uygulama genelinde kullanılan sabitler.
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'EduManager';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Profesyonel Eğitim Yönetim Sistemi';

  // JSON File Names
  static const String usersFile = 'users.json';
  static const String studentsFile = 'students.json';
  static const String assignmentsFile = 'assignments.json';
  static const String lessonsFile = 'lessons.json';
  static const String notificationsFile = 'notifications.json';

  // Responsive Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Sidebar
  static const double sidebarWidth = 280;
  static const double sidebarCollapsedWidth = 72;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Pagination
  static const int defaultPageSize = 20;

  // Lesson Durations (minutes)
  static const List<int> lessonDurations = [30, 45, 60, 90, 120];

  // Student Levels
  static const List<String> studentLevels = [
    'İlkokul',
    'Ortaokul 5',
    'Ortaokul 6',
    'Ortaokul 7',
    'Ortaokul 8',
    'Lise 9',
    'Lise 10',
    'Lise 11',
    'Lise 12',
    'Üniversite',
    'Yetişkin',
  ];

  // Assignment Statuses
  static const String statusPending = 'pending';
  static const String statusInProgress = 'inProgress';
  static const String statusCompleted = 'completed';
  static const String statusOverdue = 'overdue';

  // Lesson Statuses
  static const String lessonScheduled = 'scheduled';
  static const String lessonCompleted = 'completed';
  static const String lessonCancelled = 'cancelled';

  // Notification Types
  static const String notifNewAssignment = 'newAssignment';
  static const String notifUpcomingLesson = 'upcomingLesson';
  static const String notifOverdueAssignment = 'overdueAssignment';
  static const String notifSystem = 'system';

  // User Roles
  static const String roleTeacher = 'teacher';
  static const String roleStudent = 'student';
}
