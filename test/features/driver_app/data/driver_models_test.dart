import 'package:dllne_deliver_app/features/delivery/data/models/delivery_order_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeliveryOrderModel merchant preparation', () {
    test('parses nullable preparation state and allows travel before readiness', () {
      final order = DeliveryOrderModel.fromJson(const {
        'id': 99,
        'orderNumber': 'DEL-99',
        'companyId': 3,
        'driverId': 7,
        'status': 'accepted',
        'customerName': 'Customer',
        'customerPhone': '0999999999',
        'pickupAddress': 'Store',
        'pickupLatitude': 36.2,
        'pickupLongitude': 37.1,
        'dropoffAddress': 'Customer home',
        'dropoffLatitude': 36.3,
        'dropoffLongitude': 37.2,
        'distanceKm': 3.2,
        'deliveryFee': 145,
        'currency': 'SYP',
        'merchantPreparation': {
          'status': 'preparing',
          'isReady': false,
          'estimatedPreparationMinutes': null,
          'estimatedReadyAt': null,
          'readyAt': null,
          'hasEstimate': false,
          'isEstimateOverdue': false,
        },
      });

      expect(order.merchantPreparation, isNotNull);
      expect(order.merchantPreparation!.hasEstimate, isFalse);
      expect(order.merchantPreparation!.displayLabel, 'لا يوجد وقت تجهيز متوقع');
      expect(order.apiAction, 'start');
      expect(order.hasLifecycleAction, isTrue);
      expect(order.nextActionLabel, 'بدء التوجه إلى المتجر');
    });

    test('blocks pickup when estimate passed but merchant is not ready', () {
      final order = DeliveryOrderModel.fromJson(const {
        'id': 100,
        'orderNumber': 'DEL-100',
        'companyId': 3,
        'driverId': 7,
        'status': 'in_progress',
        'customerName': 'Customer',
        'customerPhone': '0999999999',
        'pickupAddress': 'Restaurant',
        'pickupLatitude': 36.2,
        'pickupLongitude': 37.1,
        'dropoffAddress': 'Customer home',
        'dropoffLatitude': 36.3,
        'dropoffLongitude': 37.2,
        'distanceKm': 3.2,
        'deliveryFee': 145,
        'currency': 'SYP',
        'merchantPreparation': {
          'status': 'preparing',
          'isReady': false,
          'estimatedPreparationMinutes': 25,
          'estimatedReadyAt': '2026-07-10T12:30:00Z',
          'readyAt': null,
          'hasEstimate': true,
          'isEstimateOverdue': true,
        },
      });

      expect(order.isPickupBlocked, isTrue);
      expect(order.hasLifecycleAction, isFalse);
      expect(
        order.merchantPreparation!.displayLabel,
        'انتهى الوقت المتوقع — بانتظار المتجر',
      );
      expect(order.statusUi, 'انتهى الوقت المتوقع — بانتظار المتجر');
    });

    test('enables pickup only after actual readiness', () {
      final order = DeliveryOrderModel.fromJson(const {
        'id': 101,
        'orderNumber': 'DEL-101',
        'companyId': 3,
        'driverId': 7,
        'status': 'in_progress',
        'customerName': 'Customer',
        'customerPhone': '0999999999',
        'pickupAddress': 'Restaurant',
        'pickupLatitude': 36.2,
        'pickupLongitude': 37.1,
        'dropoffAddress': 'Customer home',
        'dropoffLatitude': 36.3,
        'dropoffLongitude': 37.2,
        'distanceKm': 3.2,
        'deliveryFee': 145,
        'currency': 'SYP',
        'merchantPreparation': {
          'status': 'ready_for_pickup',
          'isReady': true,
          'estimatedPreparationMinutes': 25,
          'estimatedReadyAt': '2026-07-10T12:30:00Z',
          'readyAt': '2026-07-10T12:25:00Z',
          'hasEstimate': true,
          'isEstimateOverdue': false,
        },
      });

      expect(order.isPickupBlocked, isFalse);
      expect(order.apiAction, 'pickup');
      expect(order.hasLifecycleAction, isTrue);
      expect(order.merchantPreparation!.displayLabel, 'جاهز للاستلام');
    });
  });
}
