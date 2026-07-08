import 'package:flutter/material.dart';

import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../common/helper/src/locale_keys.dart';
import '../../../../common/models/notification_model.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationModel notification;

  const NotificationWidget({super.key, required this.notification});

  bool get _isRead => notification.readAt != null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (notification.data?.args == null) {
              return;
            } else {
              return;
            }
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Icon(
              _isRead ? Icons.notifications_none : Icons.notifications_active,
              color: context.primarySwatch,
              size: 28,
            ),
            title: Text(
              notification.title ?? LocaleKeys.nullText.tr(),
              style: context.headlineSmall(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                notification.body ??
                    notification.message ??
                    LocaleKeys.nullText.tr(),
                style: context.bodySmall(
                  fontSize: 14,
                  color: context.onSurfaceVariantColor,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: notification.createdAt == null
                ? null
                : Text(
                    formatNotificationDate(notification.createdAt),
                    style: context.bodySmall(
                      fontSize: 11,
                      color: context.onSurfaceVariantColor,
                    ),
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
