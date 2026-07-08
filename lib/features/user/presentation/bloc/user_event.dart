part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class UserGetMeEvent extends UserEvent {}

class DriverGetMeEvent extends UserEvent {}

class UpdateAvailabilityEvent extends UserEvent {
  final UpdateAvailabilityParams params;

  UpdateAvailabilityEvent({required this.params});
}

class PostLocationEvent extends UserEvent {
  final PostLocationParams params;

  PostLocationEvent({required this.params});
}

class UserUpdateProfileImageEvent extends UserEvent {
  final UserUpdateProfileImageParams params;

  UserUpdateProfileImageEvent({required this.params});
}

class UserDeleteMeEvent extends UserEvent {}

class UserUpdateMeEvent extends UserEvent {
  final UserUpdateMeParams params;

  UserUpdateMeEvent({required this.params});
}
