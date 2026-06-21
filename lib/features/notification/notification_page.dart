import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/gradient_background.dart';
import '../../data/models/notification_model.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  IconData _getIconForType(String type) {
    switch (type) {
      case 'article':
        return Icons.article_outlined;
      case 'favorite':
        return Icons.favorite_outline;
      case 'briefing':
        return Icons.newspaper_outlined;
      case 'mission':
        return Icons.rocket_launch_outlined;
      case 'breaking':
        return Icons.bolt_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'article':
        return AppColors.cyan;
      case 'favorite':
        return AppColors.favoriteRed;
      case 'briefing':
        return AppColors.success;
      case 'mission':
        return AppColors.violet;
      case 'breaking':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifications = NotificationModel.dummyNotifications;

    return GradientBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifications',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Stay updated with space news',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.cyan.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${notifications.length} new',
                        style: const TextStyle(
                          color: AppColors.cyan,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: notifications.isEmpty
                ? const EmptyState(
                    icon: Icons.notifications_off_outlined,
                    title: AppStrings.noNotifications,
                    subtitle: AppStrings.noNotificationsSubtitle,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      final icon = _getIconForType(notification.iconName);
                      final color = _getColorForType(notification.iconName);

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.glass,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.glassStroke),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(icon, color: color, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.title,
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notification.message,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    DateFormatter.timeAgo(notification.time),
                                    style: const TextStyle(
                                      color: AppColors.textTertiary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: (80 * index).ms).slideX(begin: 0.05);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
