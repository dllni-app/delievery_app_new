import '../../../../common/helper/src/typedef.dart';
import '../../data/models/auth_response.dart';

abstract class AuthRepositories {
  DataResponse<AuthResponse> logIn(BodyMap params);

  DataResponse<void> logOut();


}
