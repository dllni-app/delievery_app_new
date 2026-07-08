import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../common/helper/src/typedef.dart';
import '../../../../core/use_case/use_case.dart';
import '../../data/models/delivery_order_model.dart';
import '../repositories/delivery_repositories.dart';

@lazySingleton
class PerformOrderActionUseCase
    implements UseCase<DeliveryOrderModel, PerformOrderActionParams> {
  PerformOrderActionUseCase({required DeliveryRepositories repositories})
      : _repositories = repositories;

  final DeliveryRepositories _repositories;

  @override
  DataResponse<DeliveryOrderModel> call(PerformOrderActionParams params) async {
    return switch (params.order.apiAction) {
      'start' => _repositories.startOrder(params.order.id),
      'pickup' => _repositories.pickupOrder(params.order.id),
      'deliver' => _repositories.deliverOrder(params.order.id),
      _ => Future.value(Right(params.order)),
    };
  }
}

class PerformOrderActionParams {
  const PerformOrderActionParams({required this.order});

  final DeliveryOrderModel order;
}
