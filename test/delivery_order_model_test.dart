import 'package:flutter_test/flutter_test.dart';
import 'package:dllne_deliver_app/features/delivery/data/models/delivery_order_model.dart';

DeliveryOrderModel orderFor(
  String status, {
  String? action,
  bool merchantReady = true,
}) {
  return DeliveryOrderModel.fromJson({
    'id': 11,
    'orderNumber': 'DEL-11',
    'status': status,
    'merchantPreparation': {
      'status': merchantReady ? 'ready' : 'preparing',
      'isReady': merchantReady,
      'hasEstimate': false,
      'isEstimateOverdue': false,
    },
    'events': action == null
        ? <Map<String, dynamic>>[]
        : [
            {
              'id': 1,
              'toStatus': status,
              'payload': {'action': action},
            },
          ],
  });
}

void main() {
  group('delivery arrival lifecycle', () {
    test('requires arrival at pickup before pickup confirmation', () {
      expect(orderFor('in_progress').apiAction, 'arrived_pickup');

      final arrived = orderFor('in_progress', action: 'ARRIVED_PICKUP');

      expect(arrived.hasArrivedPickup, isTrue);
      expect(arrived.apiAction, 'pickup');
    });

    test('blocks pickup after arrival while merchant is not ready', () {
      final order = orderFor(
        'in_progress',
        action: 'ARRIVED_PICKUP',
        merchantReady: false,
      );

      expect(order.hasArrivedPickup, isTrue);
      expect(order.isPickupBlocked, isTrue);
      expect(order.apiAction, isNull);
    });

    test('requires arrival at dropoff before delivery confirmation', () {
      expect(orderFor('picked_up').apiAction, 'arrived_dropoff');
      expect(orderFor('picked_up').canReportDeliveryFailure, isTrue);

      final arrived = orderFor('picked_up', action: 'ARRIVED_DROPOFF');

      expect(arrived.hasArrivedDropoff, isTrue);
      expect(arrived.apiAction, 'deliver');
    });

    test('requires merchant return confirmation after delivery failure', () {
      final returning = orderFor('returning_to_merchant');

      expect(returning.apiAction, 'returned_to_merchant');
      expect(returning.nextActionLabel, 'تأكيد إعادة الطلب للمتجر');
      expect(returning.canReportDeliveryFailure, isFalse);
    });
  });
}
