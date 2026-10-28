import 'package:flutter/material.dart';

import '../../../../common/helper/src/locale_keys.dart';
import '../../../../common/models/notification_model.dart';
import '../../../../core/utils/app_colors.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationWidget({
    super.key,
    required this.notification,
    required this.onTap,
  });

  bool get _isRead =>
      notification.readAt != null || notification.datumReadAt != null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: _isRead ? Colors.white : const Color(0xFFF6F7FF),
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Icon(
              _isRead ? Icons.notifications_none : Icons.notifications_active,
              color: AppColors.primary,
              size: 28,
            ),
            title: Text(
              notification.title ?? LocaleKeys.nullText.tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                notification.body ??
                    notification.message ??
                    LocaleKeys.nullText.tr(),
                style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatNotificationDate(
                    notification.createdAt ?? notification.datumCreatedAt,
                  ),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 6),
                const Icon(
                  Icons.chevron_left_rounded,
                  size: 21,
                  color: AppColors.primary,
                ),
              ],
            ),
            isThreeLine: true,
          ),
        ),
      ),
    );
  }
}

String formatNotificationDate(DateTime? createdAt) {
  final safeDate = createdAt ?? DateTime.now();
  final date = safeDate.toLocal();
  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final target = DateTime(date.year, date.month, date.day);

  if (target == today) {
    return LocaleKeys.today.tr();
  } else if (target == yesterday) {
    return LocaleKeys.yesterday.tr();
  } else {
    return DateFormat('yyyy/MM/dd', 'ar').format(date);
  }
}
