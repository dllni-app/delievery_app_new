import 'package:injectable/injectable.dart';

import '../../../../common/helper/src/typedef.dart';
import '../../../../core/use_case/use_case.dart';
import '../../data/models/driver_profile_response.dart';
import '../repositories/user_repositories.dart';

@lazySingleton
class DriverGetMeUseCases implements UseCase<DriverProfileResponse, NoParams> {
  final UserRepositories _repositories;

  DriverGetMeUseCases({required UserRepositories repositories})
      : _repositories = repositories;

  @override
  DataResponse<DriverProfileResponse> call(NoParams params) async =>
      await _repositories.driverGetMe();
}
