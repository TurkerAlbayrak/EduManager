import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/lesson_provider.dart';
import '../../../providers/student_provider.dart';
import '../../../widgets/common/empty_state_widget.dart';
import '../../../widgets/common/status_badge.dart';

/// Ders listesi ekranı.
class LessonListScreen extends StatefulWidget {
  const LessonListScreen({super.key});
  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().userId;
      context.read<LessonProvider>().loadLessons(userId);
    });
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      body: Column(
        children: [
          if (isWide) Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(children: [
              const Text(AppStrings.lessons, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
              const Spacer(),
              Consumer<LessonProvider>(builder: (context, p, _) => Text('${p.totalLessons} ders', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextSecondary : AppColors.textSecondary))),
            ]),
          ),
          TabBar(controller: _tabController, tabs: const [Tab(text: 'Yaklaşan'), Tab(text: 'Geçmiş')], labelColor: AppColors.primary, indicatorColor: AppColors.primary),
          Expanded(
            child: TabBarView(controller: _tabController, children: [
              _buildLessonList(upcoming: true),
              _buildLessonList(upcoming: false),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/teacher/lessons/form'),
        icon: const Icon(Icons.add_rounded),
        label: const Text(AppStrings.addLesson),
      ),
    );
  }

  Widget _buildLessonList({required bool upcoming}) {
    return Consumer2<LessonProvider, StudentProvider>(
      builder: (context, lessonP, studentP, _) {
        final list = upcoming ? lessonP.upcomingLessons : lessonP.pastLessons;
        if (list.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.menu_book_outlined,
            title: upcoming ? 'Yaklaşan ders yok' : 'Geçmiş ders yok',
            subtitle: upcoming ? 'Yeni ders ekleyin' : null,
            buttonText: upcoming ? AppStrings.addLesson : null,
            onButtonPressed: upcoming ? () => context.go('/teacher/lessons/form') : null,
          );
        }
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final l = list[index];
            final student = studentP.getStudentById(l.studentId);
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(width: 52, height: 52, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('${l.date.day}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.primary)),
                        Text(AppDateUtils.formatShortDay(l.date).split(' ').last, style: const TextStyle(fontSize: 10, color: AppColors.primary)),
                      ])),
                    const SizedBox(width: 16),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(l.topic, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(student?.fullName ?? 'Bilinmeyen', style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)),
                      if (l.teacherNote != null && l.teacherNote!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(l.teacherNote!, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary)),
                      ],
                    ])),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text(l.startTime, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.primary)),
                      Text(l.durationFormatted, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary)),
                      const SizedBox(height: 4),
                      StatusBadge.forLesson(l.status.name),
                    ]),
                  ],
                ),
              ),
            ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn().slideX(begin: 0.05);
          },
        );
      },
    );
  }
}
