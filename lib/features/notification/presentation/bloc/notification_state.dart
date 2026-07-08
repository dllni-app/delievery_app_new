part of 'notification_bloc.dart';

class NotificationState {
  final PaginationStateModel<NotificationModel> getAllNotification;
  final DataStateModel<void> markNotificationReadData;
  final DataStateModel<String?> newNotificationRevisedData;
  final bool isNew;

  const NotificationState({
    this.getAllNotification = const PaginationStateModel(perPage: 10),
    this.markNotificationReadData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
    this.newNotificationRevisedData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),

    this.isNew = false,
  });

  NotificationState copyWith({
    PaginationStateModel<NotificationModel>? getAllNotification,
    DataStateModel<void>? markNotificationReadData,
    DataStateModel<String?>? newNotificationRevisedData,

    bool? isNew,
  }) {
    return NotificationState(
      getAllNotification: getAllNotification ?? this.getAllNotification,
      markNotificationReadData:
          markNotificationReadData ?? this.markNotificationReadData,
      newNotificationRevisedData: newNotificationRevisedData ?? this.newNotificationRevisedData,
      isNew: isNew ?? this.isNew,
    );
  }
}
