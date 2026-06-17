import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/assignment_provider.dart';
import '../../../providers/lesson_provider.dart';
import '../../../widgets/dashboard/stat_card.dart';
import '../../../widgets/common/status_badge.dart';

/// Öğrenci dashboard ekranı.
class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});
  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final linkedId = auth.currentUser?.linkedStudentId ?? '';
      context.read<AssignmentProvider>().loadStudentAssignments(linkedId);
      context.read<LessonProvider>().loadStudentLessons(linkedId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Hoş geldin, ${context.watch<AuthProvider>().userName}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)).animate().fadeIn(),
        const SizedBox(height: 4),
        Text('Bugün neler var?', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)).animate(delay: 100.ms).fadeIn(),
        const SizedBox(height: 20),
        Consumer2<AssignmentProvider, LessonProvider>(builder: (context, ap, lp, _) {
          return GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.3,
            children: [
              StatCard(title: 'Bekleyen Ödev', value: '${ap.pendingCount + ap.inProgressCount}', icon: Icons.assignment_late_rounded, color: AppColors.warning).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1),
              StatCard(title: 'Tamamlanan Ödev', value: '${ap.completedCount}', icon: Icons.check_circle_rounded, color: AppColors.success).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1),
              StatCard(title: 'Yaklaşan Ders', value: '${lp.scheduledLessons}', icon: Icons.event_rounded, color: AppColors.primary).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1),
              StatCard(title: 'Toplam Ders', value: '${lp.totalLessons}', icon: Icons.menu_book_rounded, color: Color(0xFF7C3AED)).animate(delay: 500.ms).fadeIn().slideY(begin: 0.1),
            ],
          );
        }),
        const SizedBox(height: 24),
        const Text('Yaklaşan Dersler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Consumer<LessonProvider>(builder: (context, lp, _) {
          final upcoming = lp.upcomingLessons.take(3).toList();
          if (upcoming.isEmpty) return Card(child: Padding(padding: const EdgeInsets.all(24), child: Center(child: Text('Yaklaşan ders yok', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)))));
          return Column(children: upcoming.map((l) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.event_rounded, color: AppColors.primary)),
              title: Text(l.topic, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${AppDateUtils.getRelativeDate(l.date)} • ${l.startTime} • ${l.durationFormatted}', style: const TextStyle(fontSize: 12)),
            ),
          )).toList());
        }),
      ]),
    );
  }
}
