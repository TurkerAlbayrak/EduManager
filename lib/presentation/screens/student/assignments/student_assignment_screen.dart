import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../domain/entities/assignment_entity.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/assignment_provider.dart';
import '../../../widgets/common/empty_state_widget.dart';
import '../../../widgets/common/status_badge.dart';

/// Öğrenci ödev listesi ekranı.
class StudentAssignmentScreen extends StatefulWidget {
  const StudentAssignmentScreen({super.key});
  @override
  State<StudentAssignmentScreen> createState() => _StudentAssignmentScreenState();
}

class _StudentAssignmentScreenState extends State<StudentAssignmentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final linkedId = context.read<AuthProvider>().currentUser?.linkedStudentId ?? '';
      context.read<AssignmentProvider>().loadStudentAssignments(linkedId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssignmentProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) return const Center(child: CircularProgressIndicator());
        if (provider.assignments.isEmpty) return const EmptyStateWidget(icon: Icons.assignment_outlined, title: 'Henüz ödev atanmamış');
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.assignments.length,
          itemBuilder: (context, index) {
            final a = provider.assignments[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(a.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
                    StatusBadge.fromAssignmentStatus(a.status),
                  ]),
                  const SizedBox(height: 8),
                  Text(a.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Icon(Icons.calendar_today_outlined, size: 14, color: a.isOverdue ? AppColors.danger : AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text('Teslim: ${AppDateUtils.formatDate(a.dueDate)}', style: TextStyle(fontSize: 12, color: a.isOverdue ? AppColors.danger : AppColors.textTertiary)),
                    const Spacer(),
                    if (a.status != AssignmentStatus.completed)
                      TextButton.icon(
                        onPressed: () => provider.markAsCompleted(a.id),
                        icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                        label: const Text('Tamamla', style: TextStyle(fontSize: 13)),
                        style: TextButton.styleFrom(foregroundColor: AppColors.success),
                      ),
                  ]),
                  if (a.completionPercentage > 0) ...[
                    const SizedBox(height: 8),
                    ClipRRect(borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(value: a.completionPercentage / 100, minHeight: 6,
                        backgroundColor: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation(a.completionPercentage == 100 ? AppColors.success : AppColors.primary))),
                  ],
                ]),
              ),
            ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn().slideX(begin: 0.05);
          },
        );
      },
    );
  }
}
