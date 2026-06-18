import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../providers/student_provider.dart';
import '../../../widgets/common/status_badge.dart';

/// Öğrenci detay ekranı.
class StudentDetailScreen extends StatelessWidget {
  final String studentId;

  const StudentDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width > 600;

    return Consumer<StudentProvider>(
      builder: (context, provider, _) {
        final student = provider.getStudentById(studentId);
        if (student == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Öğrenci bulunamadı')),
          );
        }

        return Scaffold(
          appBar: isWide
              ? null
              : AppBar(
                  title: Text(student.fullName),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => context.go('/teacher/students'),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit_rounded),
                      onPressed: () =>
                          context.go('/teacher/students/form?id=${student.id}'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_rounded, color: AppColors.danger),
                      onPressed: () => _deleteStudent(context, provider),
                    ),
                  ],
                ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(isWide ? 32 : 16),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isWide)
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_rounded),
                            onPressed: () => context.go('/teacher/students'),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              student.fullName,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w700),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () =>
                                context.go('/teacher/students/form?id=${student.id}'),
                            icon: const Icon(Icons.edit_rounded, size: 18),
                            label: const Text(AppStrings.edit),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () => _deleteStudent(context, provider),
                            icon: const Icon(Icons.delete_rounded,
                                size: 18, color: AppColors.danger),
                            label: const Text(AppStrings.delete,
                                style: TextStyle(color: AppColors.danger)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.danger),
                            ),
                          ),
                        ],
                      ),
                    if (isWide) const SizedBox(height: 24),

                    // Profil kartı
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundColor:
                                  AppColors.primary.withValues(alpha: 0.12),
                              child: Text(
                                student.initials,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    student.fullName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    student.level,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StatusBadge.activeStatus(student.isActive),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // İletişim bilgileri
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'İletişim Bilgileri',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 16),
                            _infoRow(Icons.email_outlined, 'E-posta', student.email),
                            if (student.notes != null &&
                                student.notes!.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              _infoRow(Icons.note_outlined, 'Notlar', student.notes!),
                            ],
                            const SizedBox(height: 12),
                            _infoRow(Icons.calendar_today_outlined, 'Kayıt Tarihi',
                                AppDateUtils.formatDate(student.createdAt)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }

  void _deleteStudent(BuildContext context, StudentProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.deleteConfirmTitle),
        content: const Text(AppStrings.deleteStudentConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteStudent(studentId);
              Navigator.pop(ctx);
              context.go('/teacher/students');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(AppStrings.studentDeleted),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }
}
