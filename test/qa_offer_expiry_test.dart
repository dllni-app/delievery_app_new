import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dllne_deliver_app/features/delivery/data/models/delivery_offer_model.dart';
import 'package:dllne_deliver_app/features/delivery/data/models/delivery_order_model.dart';
import 'package:dllne_deliver_app/features/delivery/domain/repositories/delivery_repositories.dart';
import 'package:dllne_deliver_app/features/delivery/domain/use_cases/load_delivery_dashboard_use_case.dart';
import 'package:dllne_deliver_app/features/delivery/domain/use_cases/accept_offer_use_case.dart';
import 'package:dllne_deliver_app/features/delivery/domain/use_cases/reject_offer_use_case.dart';
import 'package:dllne_deliver_app/features/delivery/domain/use_cases/perform_order_action_use_case.dart';
import 'package:dllne_deliver_app/features/delivery/domain/use_cases/get_disputes_use_case.dart';
import 'package:dllne_deliver_app/features/delivery/presentation/cubit/delivery_cubit.dart';
import 'package:dllne_deliver_app/common/helper/src/typedef.dart';

class FakeOffersRepository implements DeliveryRepositories {
  FakeOffersRepository(this.offer);
  final DeliveryAssignmentAttemptModel offer;
  int currentOfferCalls = 0;

  @override
  DataResponse<DeliveryAssignmentAttemptModel?> getCurrentOffer() async {
    currentOfferCalls++;
    return Right(currentOfferCalls == 1 ? offer : null);
  }

  @override
  DataResponse<DeliveryOrderModel?> getCurrentOrder() async => const Right(null);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('offer disappears at expiry without a manual refresh', (tester) async {
    final offer = DeliveryAssignmentAttemptModel(
      id: 123,
      orderId: 19,
      driverId: 7,
      attemptNo: 1,
      status: 'offered',
      distanceToPickupKm: 1,
      expiresAt: DateTime.now().add(const Duration(seconds: 2)),
    );
    final repository = FakeOffersRepository(offer);
    final cubit = DeliveryCubit(
      LoadDeliveryDashboardUseCase(repositories: repository),
      AcceptOfferUseCase(repositories: repository),
      RejectOfferUseCase(repositories: repository),
      PerformOrderActionUseCase(repositories: repository),
      GetDisputesUseCase(repositories: repository),
    );
    await cubit.loadDashboard();
    expect(cubit.state.currentOffer?.id, offer.id);
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
    expect(cubit.state.currentOffer, isNull);
    expect(repository.currentOfferCalls, greaterThan(1));
    await cubit.close();
  });
}
