import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/services/navigation_service.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/student_provider.dart';
import 'presentation/providers/assignment_provider.dart';
import 'presentation/providers/lesson_provider.dart';
import 'presentation/providers/notification_provider.dart';
import 'presentation/providers/theme_provider.dart';

/// EduManager - Profesyonel Eğitim Yönetim Sistemi
/// Ana uygulama giriş noktası.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EduManagerApp());
}

class EduManagerApp extends StatelessWidget {
  const EduManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => AssignmentProvider()),
        ChangeNotifierProvider(create: (_) => LessonProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            title: 'EduManager',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
