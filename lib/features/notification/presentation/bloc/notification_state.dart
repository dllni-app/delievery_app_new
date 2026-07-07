part of 'notification_bloc.dart';

class NotificationState {
  final PaginationStateModel<NotificationModel> getAllNotification;
  final DataStateModel<void> getMarkNotification;
  final DataStateModel<String?> newNotificationRevisedData;
  final bool isNew;

  const NotificationState({
    this.getAllNotification = const PaginationStateModel(perPage: 10),
    this.getMarkNotification = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
    this.newNotificationRevisedData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),

    this.isNew = false,
  });

  NotificationState copyWith({
    PaginationStateModel<NotificationModel>? getAllNotification,
    DataStateModel<void>? getMarkNotification,
    DataStateModel<String?>? newNotificationRevisedData,

    bool? isNew,
  }) {
    return NotificationState(
      getAllNotification: getAllNotification ?? this.getAllNotification,
      getMarkNotification: getMarkNotification ?? this.getMarkNotification,
      newNotificationRevisedData: newNotificationRevisedData ?? this.newNotificationRevisedData,
      isNew: isNew ?? this.isNew,
    );
  }
}
