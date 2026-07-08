import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../common/helper/src/typedef.dart';
import '../../../../core/unified_api/error/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../../data/models/delivery_offer_model.dart';
import '../../data/models/delivery_order_model.dart';
import '../repositories/delivery_repositories.dart';

class DeliveryDashboardSnapshot {
  const DeliveryDashboardSnapshot({
    required this.currentOffer,
    required this.currentOrder,
  });

  final DeliveryAssignmentAttemptModel? currentOffer;
  final DeliveryOrderModel? currentOrder;
}

@lazySingleton
class LoadDeliveryDashboardUseCase
    implements UseCase<DeliveryDashboardSnapshot, NoParams> {
  LoadDeliveryDashboardUseCase({required DeliveryRepositories repositories})
      : _repositories = repositories;

  final DeliveryRepositories _repositories;

  @override
  DataResponse<DeliveryDashboardSnapshot> call(NoParams params) async {
    final results = await Future.wait([
      _repositories.getCurrentOffer(),
      _repositories.getCurrentOrder(),
    ]);

    final offerEither =
        results[0] as Either<Failure, DeliveryAssignmentAttemptModel?>;
    final orderEither = results[1] as Either<Failure, DeliveryOrderModel?>;

    return offerEither.fold(
      Left.new,
      (offer) => orderEither.fold(
        Left.new,
        (order) => Right(
          DeliveryDashboardSnapshot(
            currentOffer: offer,
            currentOrder: order,
          ),
        ),
      ),
    );
  }
}
