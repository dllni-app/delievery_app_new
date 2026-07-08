import 'package:injectable/injectable.dart';

import '../../../../common/helper/src/typedef.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/delivery_repositories.dart';

@lazySingleton
class RejectOfferUseCase implements UseCase<void, RejectOfferParams> {
  RejectOfferUseCase({required DeliveryRepositories repositories})
      : _repositories = repositories;

  final DeliveryRepositories _repositories;

  @override
  DataResponse<void> call(RejectOfferParams params) async =>
      _repositories.rejectOffer(params.attemptId, params.reason);
}

class RejectOfferParams {
  const RejectOfferParams({required this.attemptId, required this.reason});

  final int attemptId;
  final String reason;
}
