import 'package:injectable/injectable.dart';

import '../../../../common/helper/src/typedef.dart';
import '../../../../core/use_case/use_case.dart';
import '../../data/models/driver_profile_response.dart';
import '../repositories/user_repositories.dart';

@lazySingleton
class UpdateAvailabilityUseCases
    implements UseCase<DriverProfileResponse, UpdateAvailabilityParams> {
  final UserRepositories _repositories;

  UpdateAvailabilityUseCases({required UserRepositories repositories})
      : _repositories = repositories;

  @override
  DataResponse<DriverProfileResponse> call(UpdateAvailabilityParams params) async =>
      await _repositories.updateAvailability(params.getBody());
}

class UpdateAvailabilityParams with Params {
  final String availabilityStatus;

  UpdateAvailabilityParams({required this.availabilityStatus});

  @override
  BodyMap getBody() => {'availabilityStatus': availabilityStatus};
}
