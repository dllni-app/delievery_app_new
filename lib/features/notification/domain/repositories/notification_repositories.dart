import '../../../../common/helper/src/typedef.dart';

import '../../data/models/get_all_notification_response.dart';



abstract class NotificationRepositories {

  DataResponse<GetAllNotificationResponse> getAllNotification(QueryParams params);



  DataResponse<void> markNotificationRead(String id);

}

