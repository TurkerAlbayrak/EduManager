import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/student_provider.dart';
import '../../../widgets/common/empty_state_widget.dart';
import '../../../widgets/common/status_badge.dart';

/// Öğrenci listesi ekranı.
class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().userId;
      context.read<StudentProvider>().loadStudents(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Column(
        children: [
          if (isWide) _buildDesktopHeader(),
          _buildFilters(),
          Expanded(child: _buildStudentList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/teacher/students/form'),
        icon: const Icon(Icons.add_rounded),
        label: const Text(AppStrings.addStudent),
      ),
    );
  }

  Widget _buildDesktopHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        children: [
          const Text(
            AppStrings.students,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          Consumer<StudentProvider>(
            builder: (context, provider, _) {
              return Text(
                '${provider.totalCount} öğrenci',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Consumer<StudentProvider>(
      builder: (context, provider, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Arama
              TextField(
                onChanged: provider.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Öğrenci ara...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: provider.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () => provider.setSearchQuery(''),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              // Filtreler
              Row(
                children: [
                  _filterChip('Tümü (${provider.totalCount})', 'all', provider),
                  const SizedBox(width: 8),
                  _filterChip('Aktif (${provider.activeCount})', 'active', provider),
                  const SizedBox(width: 8),
                  _filterChip('Pasif (${provider.passiveCount})', 'passive', provider),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterChip(String label, String value, StudentProvider provider) {
    final isSelected = provider.filterStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => provider.setFilterStatus(value),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : null,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        fontSize: 13,
      ),
    );
  }

  Widget _buildStudentList() {
    return Consumer<StudentProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.students.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.people_outline_rounded,
            title: 'Henüz öğrenci eklenmemiş',
            subtitle: 'İlk öğrencinizi ekleyerek başlayın',
            buttonText: AppStrings.addStudent,
            onButtonPressed: () => context.go('/teacher/students/form'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: provider.students.length,
          itemBuilder: (context, index) {
            final student = provider.students[index];
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => context.go('/teacher/students/${student.id}'),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.12),
                        child: Text(
                          student.initials,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.fullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.school_outlined,
                                  size: 14,
                                  color: isDark
                                      ? AppColors.darkTextTertiary
                                      : AppColors.textTertiary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  student.level,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      StatusBadge.activeStatus(student.isActive),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right_rounded),
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
