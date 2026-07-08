import 'package:dio/dio.dart';
import '../../../../common/helper/src/app_varibles.dart';
import '../../../../common/helper/src/typedef.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../../../../core/unified_api/dio/api_client.dart';
import '../../../../core/unified_api/error/api_handeler_manager.dart';
import '../models/auth_response.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthRemoteData with HandlingApiManager {
  final ApiClient _apiClient;

  AuthRemoteData({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<AuthResponse> logIn(BodyMap params) async => wrapHandlingApi(
    tryCall: () => _apiClient.post(
      ApiVariables.login(),
      data: params,
      // options: Options(headers: {'fcm-token': AppVariables.fcmToken}),
    ),
    jsonConvert: authResponseFromJson,
  );




  Future<void> logOut() async => wrapHandlingApi(
    tryCall: () => _apiClient.post(ApiVariables.logOut()),
    jsonConvert: (_){},
  );
}
