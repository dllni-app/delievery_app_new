import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../common/helper/src/typedef.dart';
import '../../../../core/unified_api/error/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../../data/models/delivery_offer_model.dart';
import '../../data/models/driver_order_status_counts.dart';
import '../../data/models/delivery_order_model.dart';
import '../repositories/delivery_repositories.dart';

class DeliveryDashboardSnapshot {
  const DeliveryDashboardSnapshot({
    required this.currentOffer,
    required this.currentOrder,
    this.counts,
  });

  final DeliveryAssignmentAttemptModel? currentOffer;
  final DeliveryOrderModel? currentOrder;
  final DriverOrderStatusCounts? counts;
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
      _repositories.getOrderStatusCounts(),
    ]);

    final offerEither =
        results[0] as Either<Failure, DeliveryAssignmentAttemptModel?>;
    final orderEither = results[1] as Either<Failure, DeliveryOrderModel?>;
    final countsEither = results[2] as Either<Failure, DriverOrderStatusCounts>;

    return offerEither.fold(
      Left.new,
      (offer) => orderEither.fold(
        Left.new,
        (order) => Right(
          DeliveryDashboardSnapshot(
            currentOffer: offer,
            currentOrder: order,
            // A summary failure must not make the active order disappear.
            counts: countsEither.fold((_) => null, (value) => value),
          ),
        ),
      ),
    );
  }
}
