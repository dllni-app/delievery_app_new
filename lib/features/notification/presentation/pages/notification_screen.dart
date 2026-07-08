import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/design/src/theme/const.dart';
import '../../../../common/design/src/widgets/shimmer_widget.dart';
import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../common/helper/src/locale_keys.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/notification/notification_service.dart';
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: context.primarySwatch,
      onRefresh: _onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
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
                          return NotificationWidget(
                            notification:
                                state.getAllNotification.list[index],
                          );
                        },
                        childCount:
                            state.getAllNotification.listLength(2),
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
        color: context.surfaceColor,
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
                backgroundColor: context.surfaceVariantColor,
                child: Icon(
                  Icons.notifications_none,
                  size: 34,
                  color: context.onSurfaceVariantColor,
                ),
              ),
              Space.vM2,
              Text(
                LocaleKeys.notificationsEmptyNotifications.tr(),
                textAlign: TextAlign.center,
                style: context.headlineSmall(fontSize: 17),
              ),
              Space.vS3,
              Text(
                LocaleKeys.notificationsNotificationsWillAppeared.tr(),
                textAlign: TextAlign.center,
                style: context.bodyMedium(
                  fontSize: 14,
                  color: context.onSurfaceVariantColor,
                ),
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
