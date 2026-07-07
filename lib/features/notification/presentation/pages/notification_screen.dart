import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/design/src/widgets/empty_data_widget.dart';
import '../../../../common/design/src/widgets/shimmer_widget.dart';
import '../../../../common/extensions/src/context_extensions.dart';
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

  @override
  void dispose() {
    if (notificationBloc.state.isNew) {
      notificationBloc.add(GetMarkNotificationEvent());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [



        BlocBuilder<NotificationBloc, NotificationState>(
          bloc: notificationBloc,
          builder: (context, state) {
            return state.getAllNotification.builderSliver(
              successWidget: () {
                return SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 22,
                  ),

                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (state.getAllNotification.length <= index) {
                        if (state.getAllNotification.length == index) {
                          notificationBloc.add(GetAllNotificationEvent());
                        }
                        return Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: ShimmerWidget(
                            borderRadius: BorderRadius.circular(12),
                            width: double.infinity,
                            height: context.width * .2+32,

                          ),
                        );
                      }
                      return NotificationWidget(
                        notification: state.getAllNotification.list[index],
                      );

                    }, childCount: state.getAllNotification.listLength(2)),
                  ),
                );
              },
              emptyWidget: SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: EmptyDataWidget(


                  ),
                ),
              ),
              loadingWidget: SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 26, vertical: 22),

                sliver: SliverList(

                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: ShimmerWidget(
                        borderRadius: BorderRadius.circular(12),
                        width: double.infinity,
                        height: context.width * .2+32,
                      ),
                    );
                  }, childCount: 8,

                  ),
                ),
              ),
              onTapRetry: () =>
                  notificationBloc
                    ..add(GetAllNotificationEvent(isReload: true)),
            );
          },
        ),



      ],
    );
  }
}
