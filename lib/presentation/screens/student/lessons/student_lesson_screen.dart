import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/lesson_provider.dart';
import '../../../widgets/common/empty_state_widget.dart';
import '../../../widgets/common/status_badge.dart';

/// Öğrenci ders geçmişi ve yaklaşan dersler ekranı.
class StudentLessonScreen extends StatefulWidget {
  const StudentLessonScreen({super.key});
  @override
  State<StudentLessonScreen> createState() => _StudentLessonScreenState();
}

class _StudentLessonScreenState extends State<StudentLessonScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().currentUser?.id ?? '';
      context.read<LessonProvider>().loadStudentLessons(userId);
    });
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(controller: _tabController, tabs: const [Tab(text: 'Yaklaşan'), Tab(text: 'Geçmiş')], labelColor: AppColors.primary, indicatorColor: AppColors.primary),
        Expanded(child: TabBarView(controller: _tabController, children: [_buildList(true), _buildList(false)])),
      ],
    );
  }

  Widget _buildList(bool upcoming) {
    return Consumer<LessonProvider>(
      builder: (context, provider, _) {
        final list = upcoming ? provider.upcomingLessons : provider.pastLessons;
        if (list.isEmpty) return EmptyStateWidget(icon: Icons.menu_book_outlined, title: upcoming ? 'Yaklaşan ders yok' : 'Geçmiş ders yok');
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final l = list[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  Container(width: 52, height: 52, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('${l.date.day}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.primary)),
                      Text(AppDateUtils.formatShortDay(l.date).split(' ').last, style: const TextStyle(fontSize: 10, color: AppColors.primary)),
                    ])),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(l.topic, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text('${l.startTime} • ${l.durationFormatted}', style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)),
                    if (l.teacherNote != null && l.teacherNote!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(l.teacherNote!, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary)),
                    ],
                  ])),
                  StatusBadge.forLesson(l.status.name),
                ]),
              ),
            ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn().slideX(begin: 0.05);
          },
        );
      },
    );
  }
}
