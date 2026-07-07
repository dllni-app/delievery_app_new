
import '../../../../common/helper/src/typedef.dart';
import '../../../../core/unified_api/error/error_handeler.dart';
import '../../domain/repositories/auth_repositories.dart';
import 'package:injectable/injectable.dart';
import '../data_sources/auth_remote_data.dart';
import '../models/auth_response.dart';

@LazySingleton(as: AuthRepositories)
class AuthRepositoriesImp with HandlingException implements AuthRepositories {
  final AuthRemoteData _remoteData;

  AuthRepositoriesImp({required AuthRemoteData remoteData})
    : _remoteData = remoteData;

  @override
  DataResponse<AuthResponse> logIn(BodyMap params) async {
    return wrapHandlingException(tryCall: () => _remoteData.logIn(params));
  }


  @override
  DataResponse<void> logOut() async =>
      wrapHandlingException(tryCall: () => _remoteData.logOut());

}
