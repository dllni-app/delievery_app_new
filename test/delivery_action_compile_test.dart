import 'package:flutter_test/flutter_test.dart';
import 'package:dllne_deliver_app/core/unified_api/api_variables.dart';
import 'package:dllne_deliver_app/features/delivery/data/data_sources/delivery_remote_data.dart';
import 'package:dllne_deliver_app/features/delivery/data/repositories/delivery_repositories_imp.dart';
import 'package:dllne_deliver_app/features/delivery/domain/use_cases/perform_order_action_use_case.dart';

void main() {
  test('arrival action stack compiles and exposes the expected endpoints', () {
    expect(
      ApiVariables.arrivedPickupDeliveryOrder(42).path,
      endsWith('/orders/42/arrived-pickup'),
    );
    expect(
      ApiVariables.arrivedDropoffDeliveryOrder(42).path,
      endsWith('/orders/42/arrived-dropoff'),
    );
    expect(
      ApiVariables.reportDeliveryFailure(42).path,
      endsWith('/orders/42/delivery-failed'),
    );
    expect(
      ApiVariables.returnedToMerchant(42).path,
      endsWith('/orders/42/returned-to-merchant'),
    );

    expect(
      ApiVariables.getDeliveryOrderById(42).path,
      endsWith('/orders/42'),
    );
    expect(DeliveryRemoteData, isNotNull);
    expect(DeliveryRepositoriesImp, isNotNull);
    expect(PerformOrderActionUseCase, isNotNull);
  });
}
