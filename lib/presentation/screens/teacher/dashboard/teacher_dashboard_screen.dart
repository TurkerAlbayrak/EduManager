import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/student_provider.dart';
import '../../../providers/assignment_provider.dart';
import '../../../providers/lesson_provider.dart';
import '../../../widgets/dashboard/stat_card.dart';
import '../../../widgets/common/status_badge.dart';

/// Öğretmen dashboard ekranı. İstatistikler ve grafikler.
class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final userId = context.read<AuthProvider>().userId;
    context.read<StudentProvider>().loadStudents(userId);
    context.read<AssignmentProvider>().loadAssignments(userId);
    context.read<LessonProvider>().loadLessons(userId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(isWide ? 24 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isWide) ...[
                Text(
                  AppStrings.dashboard,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ).animate().fadeIn().slideX(begin: -0.05),
                const SizedBox(height: 4),
                Text(
                  'Hoş geldiniz, ${context.watch<AuthProvider>().userName}',
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ).animate(delay: 100.ms).fadeIn().slideX(begin: -0.05),
                const SizedBox(height: 24),
              ],

              // İstatistik kartları
              _buildStatCards(isWide),
              const SizedBox(height: 24),

              // Grafikler satırı
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildAssignmentChart()),
                    const SizedBox(width: 24),
                    Expanded(child: _buildUpcomingLessons()),
                  ],
                )
              else ...[
                _buildAssignmentChart(),
                const SizedBox(height: 24),
                _buildUpcomingLessons(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCards(bool isWide) {
    return Consumer3<StudentProvider, AssignmentProvider, LessonProvider>(
      builder: (context, students, assignments, lessons, _) {
        final stats = [
          _StatData(
            AppStrings.totalStudents,
            '${students.totalCount}',
            Icons.people_rounded,
            AppColors.primary,
          ),
          _StatData(
            AppStrings.activeStudents,
            '${students.activeCount}',
            Icons.person_rounded,
            AppColors.success,
          ),
          _StatData(
            AppStrings.completedAssignments,
            '${assignments.completedCount}',
            Icons.check_circle_rounded,
            AppColors.success,
          ),
          _StatData(
            AppStrings.pendingAssignments,
            '${assignments.pendingCount + assignments.inProgressCount}',
            Icons.pending_rounded,
            AppColors.warning,
          ),
          _StatData(
            AppStrings.monthlyLessons,
            '${lessons.monthlyLessonCount}',
            Icons.menu_book_rounded,
            AppColors.primary,
          ),
          _StatData(
            AppStrings.totalLessonHours,
            lessons.totalHoursFormatted,
            Icons.timer_rounded,
            const Color(0xFF7C3AED),
          ),
        ];

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWide ? 3 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isWide ? 1.4 : 1.2,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return StatCard(
              title: stat.title,
              value: stat.value,
              icon: stat.icon,
              color: stat.color,
            ).animate(delay: Duration(milliseconds: 100 * index)).fadeIn().slideY(begin: 0.1);
          },
        );
      },
    );
  }

  Widget _buildAssignmentChart() {
    return Consumer<AssignmentProvider>(
      builder: (context, provider, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final completed = provider.completedCount.toDouble();
        final pending = provider.pendingCount.toDouble();
        final inProgress = provider.inProgressCount.toDouble();
        final overdue = provider.overdueCount.toDouble();
        final total = completed + pending + inProgress + overdue;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ödev Durumu',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: total == 0
                      ? const Center(child: Text('Henüz ödev bulunmuyor'))
                      : Row(
                          children: [
                            Expanded(
                              child: PieChart(
                                PieChartData(
                                  sectionsSpace: 3,
                                  centerSpaceRadius: 40,
                                  sections: [
                                    if (completed > 0)
                                      PieChartSectionData(
                                        value: completed,
                                        color: AppColors.success,
                                        title: '${(completed / total * 100).round()}%',
                                        titleStyle: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        radius: 45,
                                      ),
                                    if (inProgress > 0)
                                      PieChartSectionData(
                                        value: inProgress,
                                        color: AppColors.primary,
                                        title: '${(inProgress / total * 100).round()}%',
                                        titleStyle: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        radius: 45,
                                      ),
                                    if (pending > 0)
                                      PieChartSectionData(
                                        value: pending,
                                        color: AppColors.warning,
                                        title: '${(pending / total * 100).round()}%',
                                        titleStyle: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        radius: 45,
                                      ),
                                    if (overdue > 0)
                                      PieChartSectionData(
                                        value: overdue,
                                        color: AppColors.danger,
                                        title: '${(overdue / total * 100).round()}%',
                                        titleStyle: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        radius: 45,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _legendItem('Tamamlandı', AppColors.success, completed.toInt()),
                                const SizedBox(height: 8),
                                _legendItem('Devam Ediyor', AppColors.primary, inProgress.toInt()),
                                const SizedBox(height: 8),
                                _legendItem('Bekliyor', AppColors.warning, pending.toInt()),
                                const SizedBox(height: 8),
                                _legendItem('Gecikti', AppColors.danger, overdue.toInt()),
                              ],
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1);
      },
    );
  }

  Widget _legendItem(String label, Color color, int count) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$label ($count)',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildUpcomingLessons() {
    return Consumer2<LessonProvider, StudentProvider>(
      builder: (context, lessonProvider, studentProvider, _) {
        final upcoming = lessonProvider.upcomingLessons.take(5).toList();
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Yaklaşan Dersler',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                if (upcoming.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text('Yaklaşan ders bulunmuyor'),
                    ),
                  )
                else
                  ...upcoming.map((lesson) {
                    final student =
                        studentProvider.getStudentById(lesson.studentId);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isDark
                              ? AppColors.darkSurfaceVariant.withValues(alpha: 0.5)
                              : AppColors.surfaceVariant.withValues(alpha: 0.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${lesson.date.day}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Text(
                                    AppDateUtils.formatShortDay(lesson.date)
                                        .split(' ')
                                        .last,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lesson.topic,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    student?.fullName ?? 'Bilinmeyen',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  lesson.startTime,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  lesson.durationFormatted,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark
                                        ? AppColors.darkTextTertiary
                                        : AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.1);
      },
    );
  }
}

class _StatData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  _StatData(this.title, this.value, this.icon, this.color);
}
