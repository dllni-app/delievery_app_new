import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/design/src/theme/const.dart';
import '../../../../common/design/src/widgets/shimmer_widget.dart';
import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../common/helper/src/locale_keys.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/notification/notification_service.dart';
import '../../../../core/utils/app_colors.dart';
import '../../domain/use_cases/mark_notification_read_use_case.dart';
import '../bloc/notification_bloc.dart';
import '../widgets/notification_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final NotificationBloc notificationBloc;

  @override
  void initState() {
    notificationBloc = getIt<NotificationBloc>()
      ..add(GetAllNotificationEvent(isReload: true));
    NotificationUtils.clearUnreadCount();
    super.initState();
  }

  Future<void> _onRefresh() async {
    notificationBloc.add(GetAllNotificationEvent(isReload: true));
  }

  Future<void> _confirmDeleteAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف الكل'),
        content: const Text('هل أنت متأكد من حذف جميع الإشعارات؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      notificationBloc.add(DeleteAllNotificationsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          BlocBuilder<NotificationBloc, NotificationState>(
            bloc: notificationBloc,
            builder: (context, state) {
              if (state.getAllNotification.list.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              return SliverToBoxAdapter(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                    child: TextButton.icon(
                      onPressed: _confirmDeleteAll,
                      icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                      label: const Text(
                        'حذف الكل',
                        style: TextStyle(color: Color(0xFFEF4444)),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          BlocBuilder<NotificationBloc, NotificationState>(
            bloc: notificationBloc,
            builder: (context, state) {
              return state.getAllNotification.builderSliver(
                successWidget: () {
                  return SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (state.getAllNotification.length <= index) {
                            if (state.getAllNotification.length == index) {
                              notificationBloc.add(GetAllNotificationEvent());
                            }
                            return _NotificationLoadingCard();
                          }

                          final notification = state.getAllNotification.list[index];
                          final id = notification.id;
                          return Dismissible(
                            key: ValueKey(id ?? '${notification.createdAt}-$index'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: AlignmentDirectional.centerEnd,
                              padding: const EdgeInsetsDirectional.only(end: 20),
                              child: const Icon(Icons.delete_outline, color: Colors.white),
                            ),
                            onDismissed: (_) {
                              if (id != null && id.isNotEmpty) {
                                notificationBloc.add(DeleteNotificationEvent(id: id));
                              }
                            },
                            child: NotificationWidget(
                              notification: notification,
                              onTap: () {
                                if (id != null &&
                                    id.isNotEmpty &&
                                    notification.readAt == null) {
                                  notificationBloc.add(
                                    MarkNotificationReadEvent(
                                      params: MarkNotificationReadParams(id: id),
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                        childCount: state.getAllNotification.listLength(2),
                      ),
                    ),
                  );
                },
                emptyWidget: SliverFillRemaining(
                  hasScrollBody: false,
                  child: _NotificationEmptyState(onRefresh: _onRefresh),
                ),
                loadingWidget: SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _NotificationLoadingCard(),
                      childCount: 6,
                    ),
                  ),
                ),
                onTapRetry: () => notificationBloc
                  ..add(GetAllNotificationEvent(isReload: true)),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NotificationLoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ShimmerWidget(
        borderRadius: BorderRadius.circular(16),
        width: double.infinity,
        height: 88,
      ),
    );
  }
}

class _NotificationEmptyState extends StatelessWidget {
  const _NotificationEmptyState({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Material(
        borderRadius: BorderRadius.circular(24),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        child: Padding(
          padding: PEdgeInsets.all,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(
                  Icons.notifications_none,
                  size: 34,
                  color: Colors.black,
                ),
              ),
              Space.vM2,
              Text(
                LocaleKeys.notificationsEmptyNotifications.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17),
              ),
              Space.vS3,
              Text(
                LocaleKeys.notificationsNotificationsWillAppeared.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              Space.vM2,
              TextButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: Text(LocaleKeys.retry.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
