import '../../../../common/helper/src/typedef.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/use_case/use_case.dart';
import '../../data/model/get_all_notification_response.dart';
import '../repositories/notification_repositories.dart';

@lazySingleton
class GetAllNotificationUseCase
    implements UseCase<GetAllNotificationResponse, GetAllNotificationParams> {
  final NotificationRepositories _repositories;

  GetAllNotificationUseCase({required NotificationRepositories repositories})
    : _repositories = repositories;

  @override
  DataResponse<GetAllNotificationResponse> call(
    GetAllNotificationParams params,
  ) async => await _repositories.getAllNotification(params.getParams());
}

class GetAllNotificationParams with Params {
  final int perPage;
  final int page;

  GetAllNotificationParams({required this.perPage, required this.page});

  @override
  QueryParams getParams() {
    // TODO: implement getParams
    return {
      'perPage': perPage.toString(),
      'page': page.toString(),
      'only_unread': false.toString(),
    }..removeWhere((key, value) => value == null);
  }
}
