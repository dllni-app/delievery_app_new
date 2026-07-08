import 'package:injectable/injectable.dart';

import '../../../../common/helper/src/typedef.dart';
import '../../../../core/use_case/use_case.dart';
import '../../data/models/delivery_order_model.dart';
import '../repositories/delivery_repositories.dart';

@lazySingleton
class AcceptOfferUseCase implements UseCase<DeliveryOrderModel, AcceptOfferParams> {
  AcceptOfferUseCase({required DeliveryRepositories repositories})
      : _repositories = repositories;

  final DeliveryRepositories _repositories;

  @override
  DataResponse<DeliveryOrderModel> call(AcceptOfferParams params) async =>
      _repositories.acceptOffer(params.attemptId);
}

class AcceptOfferParams {
  const AcceptOfferParams({required this.attemptId});

  final int attemptId;
}
