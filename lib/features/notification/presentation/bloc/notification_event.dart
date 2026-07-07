part of 'notification_bloc.dart';


sealed class NotificationEvent {}

class GetAllNotificationEvent extends NotificationEvent with EventWithReload{

  @override
  final bool isReload;

  GetAllNotificationEvent({ this.isReload=false});

}

class GetMarkNotificationEvent extends NotificationEvent {}
class AddOneNotificationEvent extends NotificationEvent {
  final NotificationModel notificationModel;

  AddOneNotificationEvent({required this.notificationModel});
}

class NewNotificationRevisedEvent extends NotificationEvent{

  final  String id;

  NewNotificationRevisedEvent({required this.id});
}

