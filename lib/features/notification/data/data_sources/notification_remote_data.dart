import 'package:injectable/injectable.dart';

import '../../../../common/helper/src/typedef.dart';

import '../../../../core/unified_api/api_variables.dart';

import '../../../../core/unified_api/dio/api_client.dart';

import '../../../../core/unified_api/error/api_handeler_manager.dart';

import '../models/get_all_notification_response.dart';



@lazySingleton

class NotificationRemoteData with HandlingApiManager {

  final ApiClient _apiClient;



  NotificationRemoteData({required ApiClient apiClient})

      : _apiClient = apiClient;



  Future<GetAllNotificationResponse> getAllNotification(

    QueryParams queryParams,

  ) async =>

      wrapHandlingApi(

        tryCall: () =>

            _apiClient.get(ApiVariables.getDriverNotifications(queryParams)),

        jsonConvert: getAllNotificationResponseFromJson,

      );



  Future<void> markNotificationRead(String id) async => wrapHandlingApi(

        tryCall: () => _apiClient.patch(

          ApiVariables.markDriverNotificationRead(id),

        ),

        jsonConvert: (_) {},

      );

}

