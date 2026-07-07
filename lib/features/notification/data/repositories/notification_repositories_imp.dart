import 'package:injectable/injectable.dart';
import '../../../../common/helper/src/typedef.dart';
import '../../../../core/unified_api/error/error_handeler.dart';
import '../../domin/repositories/notification_repositories.dart';
import '../data_source/notification_remote_data.dart';
import '../model/get_all_notification_response.dart';

@LazySingleton(as: NotificationRepositories)
class NotificationRepositoriesImp
    with HandlingException
    implements NotificationRepositories {
  final NotificationRemoteData _remoteData;

  NotificationRepositoriesImp({required NotificationRemoteData remoteData})
      : _remoteData = remoteData;

  @override
  DataResponse<GetAllNotificationResponse> getAllNotification(
      QueryParams params,) async =>
      wrapHandlingException(
        tryCall: () => _remoteData.getAllNotification(params),
      );

  @override
  DataResponse<void> postMarkAll()async =>
      wrapHandlingException(
        tryCall: () => _remoteData.postMarkAllNotification(),
      );

}

