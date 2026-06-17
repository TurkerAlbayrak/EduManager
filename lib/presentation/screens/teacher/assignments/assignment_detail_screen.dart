import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../providers/student_provider.dart';
import '../../../providers/assignment_provider.dart';
import '../../../widgets/common/status_badge.dart';

/// Ödev detay ekranı.
class AssignmentDetailScreen extends StatelessWidget {
  final String assignmentId;
  const AssignmentDetailScreen({super.key, required this.assignmentId});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer2<AssignmentProvider, StudentProvider>(
      builder: (context, assignmentP, studentP, _) {
        final a = assignmentP.assignments.where((x) => x.id == assignmentId).firstOrNull;
        if (a == null) {
          return Scaffold(appBar: AppBar(), body: const Center(child: Text('Ödev bulunamadı')));
        }
        return Scaffold(
          appBar: isWide ? null : AppBar(
            title: Text(a.title),
            leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.go('/teacher/assignments')),
            actions: [
              IconButton(icon: const Icon(Icons.edit_rounded), onPressed: () => context.go('/teacher/assignments/form?id=${a.id}')),
              IconButton(icon: const Icon(Icons.delete_rounded, color: AppColors.danger), onPressed: () => _delete(context, assignmentP)),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(isWide ? 32 : 16),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (isWide) ...[
                    Row(children: [
                      IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.go('/teacher/assignments')),
                      const SizedBox(width: 8),
                      Expanded(child: Text(a.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700))),
                      OutlinedButton.icon(onPressed: () => context.go('/teacher/assignments/form?id=${a.id}'), icon: const Icon(Icons.edit_rounded, size: 18), label: const Text(AppStrings.edit)),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () => _delete(context, assignmentP),
                        icon: const Icon(Icons.delete_rounded, size: 18, color: AppColors.danger),
                        label: const Text(AppStrings.delete, style: TextStyle(color: AppColors.danger)),
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.danger)),
                      ),
                    ]),
                    const SizedBox(height: 24),
                  ],
                  Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [const Text('Durum', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)), const Spacer(), StatusBadge.fromAssignmentStatus(a.status)]),
                    const SizedBox(height: 16),
                    const Text('Açıklama', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text(a.description, style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 16),
                    Row(children: [
                      _infoChip(Icons.calendar_today_outlined, 'Teslim: ${AppDateUtils.formatDate(a.dueDate)}'),
                      const SizedBox(width: 12),
                      _infoChip(Icons.trending_up_rounded, 'Tamamlanma: %${a.completionPercentage}'),
                    ]),
                    const SizedBox(height: 16),
                    ClipRRect(borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(value: a.completionPercentage / 100, minHeight: 8,
                        backgroundColor: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation(a.completionPercentage == 100 ? AppColors.success : AppColors.primary))),
                  ]))),
                  const SizedBox(height: 16),
                  Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Atanan Öğrenciler (${a.assignedStudentIds.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    ...a.assignedStudentIds.map((sid) {
                      final s = studentP.getStudentById(sid);
                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(radius: 18, backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                          child: Text(s?.initials ?? '?', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 12))),
                        title: Text(s?.fullName ?? 'Bilinmeyen Öğrenci'),
                        subtitle: Text(s?.level ?? '', style: const TextStyle(fontSize: 12)),
                      );
                    }),
                  ]))),
                ]),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primary)),
      ]),
    );
  }

  void _delete(BuildContext context, AssignmentProvider provider) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text(AppStrings.deleteConfirmTitle),
      content: const Text(AppStrings.deleteAssignmentConfirm),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(AppStrings.cancel)),
        ElevatedButton(onPressed: () {
          provider.deleteAssignment(assignmentId);
          Navigator.pop(ctx);
          context.go('/teacher/assignments');
        }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger), child: const Text(AppStrings.delete)),
      ],
    ));
  }
}
