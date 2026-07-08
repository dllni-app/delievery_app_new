import 'package:injectable/injectable.dart';

import '../../../../common/helper/src/typedef.dart';
import '../../../../core/use_case/use_case.dart';
import '../../data/models/delivery_offer_model.dart';
import '../repositories/delivery_repositories.dart';

@lazySingleton
class GetCurrentOfferUseCase
    implements UseCase<DeliveryAssignmentAttemptModel?, NoParams> {
  GetCurrentOfferUseCase({required DeliveryRepositories repositories})
      : _repositories = repositories;

  final DeliveryRepositories _repositories;

  @override
  DataResponse<DeliveryAssignmentAttemptModel?> call(NoParams params) async =>
      _repositories.getCurrentOffer();
}
