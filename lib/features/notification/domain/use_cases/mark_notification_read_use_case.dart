import '../../../../common/helper/src/typedef.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/notification_repositories.dart';

@lazySingleton
class MarkNotificationReadUseCase
    implements UseCase<void, MarkNotificationReadParams> {
  final NotificationRepositories _repositories;

  MarkNotificationReadUseCase({required NotificationRepositories repositories})
      : _repositories = repositories;

  @override
  DataResponse<void> call(MarkNotificationReadParams params) async =>
      await _repositories.markNotificationRead(params.id);
}

class MarkNotificationReadParams with Params {
  final String id;

  MarkNotificationReadParams({required this.id});
}
