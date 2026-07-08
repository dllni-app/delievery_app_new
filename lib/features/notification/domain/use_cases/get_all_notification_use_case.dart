import '../../../../common/helper/src/typedef.dart';

import 'package:injectable/injectable.dart';



import '../../../../core/use_case/use_case.dart';

import '../../data/models/get_all_notification_response.dart';

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

  final bool? unreadOnly;



  GetAllNotificationParams({

    required this.perPage,

    required this.page,

    this.unreadOnly,

  });



  @override

  QueryParams getParams() {

    return {

      'perPage': perPage.toString(),

      'page': page.toString(),

      if (unreadOnly == true) 'filter[unread]': '1',

    }..removeWhere((key, value) => value == null);

  }

}

