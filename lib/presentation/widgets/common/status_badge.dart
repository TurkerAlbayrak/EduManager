import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/assignment_entity.dart';

/// Durum rozeti widget'ı. Ödev ve ders durumlarını renkli badge olarak gösterir.
class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.text,
    required this.color,
    this.icon,
  });

  /// Ödev durumuna göre oluşturur.
  factory StatusBadge.fromAssignmentStatus(AssignmentStatus status) {
    switch (status) {
      case AssignmentStatus.pending:
        return const StatusBadge(
          text: 'Bekliyor',
          color: AppColors.statusPending,
          icon: Icons.hourglass_empty_rounded,
        );
      case AssignmentStatus.inProgress:
        return const StatusBadge(
          text: 'Devam Ediyor',
          color: AppColors.statusInProgress,
          icon: Icons.play_circle_outline_rounded,
        );
      case AssignmentStatus.completed:
        return const StatusBadge(
          text: 'Tamamlandı',
          color: AppColors.statusCompleted,
          icon: Icons.check_circle_outline_rounded,
        );
      case AssignmentStatus.overdue:
        return const StatusBadge(
          text: 'Gecikti',
          color: AppColors.statusOverdue,
          icon: Icons.warning_amber_rounded,
        );
    }
  }

  /// Ders durumuna göre oluşturur.
  factory StatusBadge.forLesson(String status) {
    switch (status) {
      case 'scheduled':
        return const StatusBadge(
          text: 'Planlandı',
          color: AppColors.statusInProgress,
          icon: Icons.event_rounded,
        );
      case 'completed':
        return const StatusBadge(
          text: 'Tamamlandı',
          color: AppColors.statusCompleted,
          icon: Icons.check_circle_outline_rounded,
        );
      case 'cancelled':
        return const StatusBadge(
          text: 'İptal',
          color: AppColors.statusCancelled,
          icon: Icons.cancel_outlined,
        );
      default:
        return StatusBadge(
          text: status,
          color: AppColors.textSecondary,
        );
    }
  }

  /// Aktif/Pasif durumu gösterir.
  factory StatusBadge.activeStatus(bool isActive) {
    return StatusBadge(
      text: isActive ? 'Aktif' : 'Pasif',
      color: isActive ? AppColors.success : AppColors.textTertiary,
      icon: isActive ? Icons.check_circle_rounded : Icons.pause_circle_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
