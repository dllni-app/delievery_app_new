import 'package:dio/dio.dart';
import '../../../../common/helper/src/typedef.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../../../../core/unified_api/dio/api_client.dart';
import '../../../../core/unified_api/error/api_handeler_manager.dart';
import '../models/driver_profile_response.dart';
import '../models/user_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UserRemoteData with HandlingApiManager {
  final ApiClient _apiClient;

  UserRemoteData({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<DriverProfileResponse> userGetMe() async => wrapHandlingApi(
        tryCall: () => _apiClient.get(ApiVariables.driverGetMe()),
        jsonConvert: driverProfileResponseFromJson,
      );

  Future<DriverProfileResponse> driverGetMe() async => wrapHandlingApi(
        tryCall: () => _apiClient.get(ApiVariables.driverGetMe()),
        jsonConvert: driverProfileResponseFromJson,
      );

  Future<DriverProfileResponse> updateAvailability(BodyMap params) async =>
      wrapHandlingApi(
        tryCall: () =>
            _apiClient.patch(ApiVariables.updateAvailability(), data: params),
        jsonConvert: driverProfileResponseFromJson,
      );

  Future<void> postLocation(BodyMap params) async => wrapHandlingApi(
        tryCall: () => _apiClient.post(ApiVariables.postLocation(), data: params),
        jsonConvert: (_) {},
      );

  Future<UserResponse> userUpdateMe(BodyMap params) async => wrapHandlingApi(
        tryCall: () => _apiClient.put(ApiVariables.updateMe(), data: params),
        jsonConvert: userResponseFromJson,
      );

  Future<UserResponse> userUpdateProfileImage(FormData param) async =>
      wrapHandlingApi(
        tryCall: () =>
            _apiClient.post(ApiVariables.postProfileImage(), data: param),
        jsonConvert: userResponseFromJson,
      );

  Future<void> userDeleteMe() async => wrapHandlingApi(
        tryCall: () => _apiClient.delete(ApiVariables.deleteMe()),
        jsonConvert: (_) {},
      );
}
