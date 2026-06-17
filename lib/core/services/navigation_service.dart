import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teachstudentapp/presentation/screens/splash/splash_screen.dart';
import 'package:teachstudentapp/presentation/screens/auth/login_screen.dart';
import 'package:teachstudentapp/presentation/screens/teacher/teacher_shell.dart';
import 'package:teachstudentapp/presentation/screens/teacher/dashboard/teacher_dashboard_screen.dart';
import 'package:teachstudentapp/presentation/screens/teacher/students/student_list_screen.dart';
import 'package:teachstudentapp/presentation/screens/teacher/students/student_detail_screen.dart';
import 'package:teachstudentapp/presentation/screens/teacher/students/student_form_screen.dart';
import 'package:teachstudentapp/presentation/screens/teacher/assignments/assignment_list_screen.dart';
import 'package:teachstudentapp/presentation/screens/teacher/assignments/assignment_detail_screen.dart';
import 'package:teachstudentapp/presentation/screens/teacher/assignments/assignment_form_screen.dart';
import 'package:teachstudentapp/presentation/screens/teacher/lessons/lesson_list_screen.dart';
import 'package:teachstudentapp/presentation/screens/teacher/lessons/lesson_form_screen.dart';
import 'package:teachstudentapp/presentation/screens/teacher/calendar/calendar_screen.dart';
import 'package:teachstudentapp/presentation/screens/teacher/notifications/notification_screen.dart';
import 'package:teachstudentapp/presentation/screens/student/student_shell.dart';
import 'package:teachstudentapp/presentation/screens/student/dashboard/student_dashboard_screen.dart';
import 'package:teachstudentapp/presentation/screens/student/assignments/student_assignment_screen.dart';
import 'package:teachstudentapp/presentation/screens/student/lessons/student_lesson_screen.dart';

/// Uygulama navigasyon yapılandırması.
class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      // ========== ÖĞRETMEN ==========
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            TeacherShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/teacher/dashboard', builder: (context, state) => const TeacherDashboardScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/teacher/students',
              builder: (context, state) => const StudentListScreen(),
              routes: [
                GoRoute(path: 'form', builder: (context, state) => StudentFormScreen(studentId: state.uri.queryParameters['id'])),
                GoRoute(path: ':id', builder: (context, state) => StudentDetailScreen(studentId: state.pathParameters['id']!)),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/teacher/assignments',
              builder: (context, state) => const AssignmentListScreen(),
              routes: [
                GoRoute(path: 'form', builder: (context, state) => AssignmentFormScreen(assignmentId: state.uri.queryParameters['id'])),
                GoRoute(path: ':id', builder: (context, state) => AssignmentDetailScreen(assignmentId: state.pathParameters['id']!)),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/teacher/lessons',
              builder: (context, state) => const LessonListScreen(),
              routes: [
                GoRoute(path: 'form', builder: (context, state) => LessonFormScreen(lessonId: state.uri.queryParameters['id'])),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/teacher/calendar', builder: (context, state) => const CalendarScreen()),
          ]),
        ],
      ),
      GoRoute(path: '/teacher/notifications', builder: (context, state) => const NotificationScreen()),

      // ========== ÖĞRENCİ ==========
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            StudentShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/student/dashboard', builder: (context, state) => const StudentDashboardScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/student/assignments', builder: (context, state) => const StudentAssignmentScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/student/lessons', builder: (context, state) => const StudentLessonScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/student/calendar', builder: (context, state) => const CalendarScreen()),
          ]),
        ],
      ),
      GoRoute(path: '/student/notifications', builder: (context, state) => const NotificationScreen()),
    ],
  );
}
