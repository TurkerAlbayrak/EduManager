import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/assignment_provider.dart';
import '../../../providers/student_provider.dart';
import '../../../widgets/common/empty_state_widget.dart';
import '../../../widgets/common/status_badge.dart';
import '../../../../domain/entities/assignment_entity.dart';

/// Ödev listesi ekranı.
class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});
  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().userId;
      context.read<AssignmentProvider>().loadAssignments(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      body: Column(
        children: [
          if (isWide) _buildDesktopHeader(),
          _buildFilters(),
          Expanded(child: _buildList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/teacher/assignments/form'),
        icon: const Icon(Icons.add_rounded),
        label: const Text(AppStrings.addAssignment),
      ),
    );
  }

  Widget _buildDesktopHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        children: [
          const Text(AppStrings.assignments,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
          const Spacer(),
          Consumer<AssignmentProvider>(
            builder: (context, p, _) => Text('${p.totalCount} ödev',
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Consumer<AssignmentProvider>(
      builder: (context, provider, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _chip('Tümü', 'all', provider),
              const SizedBox(width: 8),
              _chip('Bekliyor (${provider.pendingCount})', 'pending', provider),
              const SizedBox(width: 8),
              _chip('Devam (${provider.inProgressCount})', 'inProgress', provider),
              const SizedBox(width: 8),
              _chip('Tamamlandı (${provider.completedCount})', 'completed', provider),
              const SizedBox(width: 8),
              _chip('Gecikti (${provider.overdueCount})', 'overdue', provider),
            ],
          ),
        );
      },
    );
  }

  Widget _chip(String label, String value, AssignmentProvider provider) {
    final sel = provider.filterStatus == value;
    return FilterChip(
      label: Text(label),
      selected: sel,
      onSelected: (_) => provider.setFilterStatus(value),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: sel ? AppColors.primary : null,
        fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
        fontSize: 13,
      ),
    );
  }

  Widget _buildList() {
    return Consumer2<AssignmentProvider, StudentProvider>(
      builder: (context, assignmentP, studentP, _) {
        if (assignmentP.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        final list = assignmentP.assignments;
        if (list.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.assignment_outlined,
            title: 'Henüz ödev eklenmemiş',
            subtitle: 'İlk ödevinizi oluşturun',
            buttonText: AppStrings.addAssignment,
            onButtonPressed: () => context.go('/teacher/assignments/form'),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final a = list[index];
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => context.go('/teacher/assignments/${a.id}'),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(a.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15)),
                          ),
                          StatusBadge.fromAssignmentStatus(a.status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(a.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 14,
                              color: isDark
                                  ? AppColors.darkTextTertiary
                                  : AppColors.textTertiary),
                          const SizedBox(width: 4),
                          Text(
                              'Teslim: ${AppDateUtils.formatDate(a.dueDate)}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: a.isOverdue
                                      ? AppColors.danger
                                      : (isDark
                                          ? AppColors.darkTextTertiary
                                          : AppColors.textTertiary))),
                          const Spacer(),
                          Icon(Icons.people_outlined,
                              size: 14,
                              color: isDark
                                  ? AppColors.darkTextTertiary
                                  : AppColors.textTertiary),
                          const SizedBox(width: 4),
                          Text('${a.assignedStudentIds.length} öğrenci',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.darkTextTertiary
                                      : AppColors.textTertiary)),
                        ],
                      ),
                      if (a.completionPercentage > 0) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: a.completionPercentage / 100,
                            backgroundColor: isDark
                                ? AppColors.darkSurfaceVariant
                                : AppColors.surfaceVariant,
                            valueColor: AlwaysStoppedAnimation(
                              a.completionPercentage == 100
                                  ? AppColors.success
                                  : AppColors.primary,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn().slideX(begin: 0.05);
          },
        );
      },
    );
  }
}
