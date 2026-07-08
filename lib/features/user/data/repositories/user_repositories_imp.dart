import 'package:dio/src/form_data.dart';
import '../../../../common/helper/src/typedef.dart';
import '../../../../core/unified_api/error/error_handeler.dart';
import '../../domain/repositories/user_repositories.dart';
import '../data_sources/user_remote_data.dart';
import '../models/driver_profile_response.dart';
import '../models/user_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserRepositories)
class UserRepositoriesImp with HandlingException implements UserRepositories {
  final UserRemoteData _remoteData;

  UserRepositoriesImp({required UserRemoteData remoteData})
      : _remoteData = remoteData;

  @override
  DataResponse<void> userDeleteMe() async =>
      await wrapHandlingException(tryCall: () => _remoteData.userDeleteMe());

  @override
  DataResponse<DriverProfileResponse> userGetMe() async =>
      await wrapHandlingException(tryCall: () => _remoteData.userGetMe());

  @override
  DataResponse<DriverProfileResponse> driverGetMe() async =>
      await wrapHandlingException(tryCall: () => _remoteData.driverGetMe());

  @override
  DataResponse<DriverProfileResponse> updateAvailability(BodyMap param) async =>
      await wrapHandlingException(
        tryCall: () => _remoteData.updateAvailability(param),
      );

  @override
  DataResponse<void> postLocation(BodyMap param) async =>
      await wrapHandlingException(
        tryCall: () => _remoteData.postLocation(param),
      );

  @override
  DataResponse<UserResponse> userUpdateMe(BodyMap param) async =>
      await wrapHandlingException(
        tryCall: () => _remoteData.userUpdateMe(param),
      );

  @override
  DataResponse<UserResponse> userUpdateProfileImage(FormData param) async =>
      await wrapHandlingException(
        tryCall: () => _remoteData.userUpdateProfileImage(param),
      );
}
