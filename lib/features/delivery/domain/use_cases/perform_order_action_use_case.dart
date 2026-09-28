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
    final action = params.action ?? params.order.apiAction;

    return switch (action) {
      'start' => _repositories.startOrder(params.order.id),
      'arrived_pickup' => _repositories.arrivedPickup(params.order.id),
      'pickup' => _repositories.pickupOrder(params.order.id),
      'arrived_dropoff' => _repositories.arrivedDropoff(params.order.id),
      'delivery_failed' => _repositories.reportDeliveryFailure(
        params.order.id,
        params.reasonCode ?? 'OTHER',
        params.reason,
      ),
      'returned_to_merchant' => _repositories.returnedToMerchant(
        params.order.id,
      ),
      'deliver' => _repositories.deliverOrder(params.order.id),
      _ => Future.value(Right(params.order)),
    };
  }
}

class PerformOrderActionParams {
  const PerformOrderActionParams({
    required this.order,
    this.action,
    this.reasonCode,
    this.reason,
  });

  final DeliveryOrderModel order;
  final String? action;
  final String? reasonCode;
  final String? reason;
}
