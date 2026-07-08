import 'package:dio/dio.dart';
import '../../../../common/helper/src/typedef.dart';
import '../../data/models/driver_profile_response.dart';
import '../../data/models/user_model.dart';

abstract class UserRepositories {
  DataResponse<DriverProfileResponse> userGetMe();

  DataResponse<DriverProfileResponse> driverGetMe();

  DataResponse<DriverProfileResponse> updateAvailability(BodyMap param);

  DataResponse<void> postLocation(BodyMap param);

  DataResponse<UserResponse> userUpdateMe(BodyMap param);

  DataResponse<UserResponse> userUpdateProfileImage(FormData param);

  DataResponse<void> userDeleteMe();
}
