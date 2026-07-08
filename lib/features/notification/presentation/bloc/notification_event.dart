part of 'notification_bloc.dart';


sealed class NotificationEvent {}

class GetAllNotificationEvent extends NotificationEvent with EventWithReload{

  @override
  final bool isReload;

  GetAllNotificationEvent({ this.isReload=false});

}

class MarkNotificationReadEvent extends NotificationEvent {
  final MarkNotificationReadParams params;

  MarkNotificationReadEvent({required this.params});
}

class AddOneNotificationEvent extends NotificationEvent {
  final NotificationModel notificationModel;

  AddOneNotificationEvent({required this.notificationModel});
}

class NewNotificationRevisedEvent extends NotificationEvent{

  final  String id;

  NewNotificationRevisedEvent({required this.id});
}
