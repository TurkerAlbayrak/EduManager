import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../domain/entities/notification_entity.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/notification_provider.dart';
import '../../../widgets/common/empty_state_widget.dart';

/// Bildirim ekranı. Tüm bildirimleri listeler.
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().userId;
      context.read<NotificationProvider>().loadNotifications(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: isWide ? null : AppBar(title: const Text(AppStrings.notifications)),
      body: Column(
        children: [
          if (isWide) Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Row(children: [
              const Text(AppStrings.notifications, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
              const Spacer(),
              Consumer<NotificationProvider>(builder: (context, p, _) {
                if (!p.hasUnread) return const SizedBox();
                return TextButton.icon(
                  onPressed: () => p.markAllAsRead(context.read<AuthProvider>().userId),
                  icon: const Icon(Icons.done_all_rounded, size: 18),
                  label: const Text(AppStrings.markAllRead),
                );
              }),
            ]),
          ),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildList() {
    return Consumer<NotificationProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) return const Center(child: CircularProgressIndicator());
        if (provider.notifications.isEmpty) {
          return const EmptyStateWidget(icon: Icons.notifications_off_outlined, title: AppStrings.noNotifications);
        }
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.notifications.length,
          itemBuilder: (context, index) {
            final n = provider.notifications[index];
            return Dismissible(
              key: Key(n.id),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => provider.deleteNotification(n.id),
              background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(color: AppColors.danger, borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.delete_rounded, color: Colors.white)),
              child: Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () { if (!n.isRead) provider.markAsRead(n.id); },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: !n.isRead ? Border.all(color: AppColors.primary.withValues(alpha: 0.3)) : null,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: _getNotifColor(n.type).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                          child: Icon(_getNotifIcon(n.type), color: _getNotifColor(n.type), size: 22)),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Expanded(child: Text(n.title, style: TextStyle(fontWeight: n.isRead ? FontWeight.w500 : FontWeight.w700, fontSize: 14))),
                            if (!n.isRead) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                          ]),
                          const SizedBox(height: 4),
                          Text(n.message, style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Text(AppDateUtils.getRelativeDate(n.createdAt), style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary)),
                        ])),
                      ],
                    ),
                  ),
                ),
              ),
            ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn().slideX(begin: 0.05);
          },
        );
      },
    );
  }

  IconData _getNotifIcon(NotificationType type) {
    switch (type) {
      case NotificationType.newAssignment: return Icons.assignment_rounded;
      case NotificationType.upcomingLesson: return Icons.event_rounded;
      case NotificationType.overdueAssignment: return Icons.warning_amber_rounded;
      case NotificationType.system: return Icons.info_rounded;
    }
  }

  Color _getNotifColor(NotificationType type) {
    switch (type) {
      case NotificationType.newAssignment: return AppColors.primary;
      case NotificationType.upcomingLesson: return AppColors.success;
      case NotificationType.overdueAssignment: return AppColors.danger;
      case NotificationType.system: return AppColors.warning;
    }
  }
}
