import 'package:dllne_deliver_app/features/driver_app/data/driver_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriverModel', () {
    test('parses snake_case API response', () {
      final driver = DriverModel.fromJson(const {
        'id': 7,
        'user_id': 11,
        'company_id': 3,
        'first_name': 'محمد',
        'phone': '0999999999',
        'vehicle_type': 'motorbike',
        'plate_number': 'A-123',
        'availability_status': 'available',
        'is_active': true,
        'is_suspended': false,
        'trust_score': 95,
        'open_disputes_count': 2,
      });

      expect(driver.id, 7);
      expect(driver.firstName, 'محمد');
      expect(driver.availabilityStatus, 'available');
      expect(driver.isActive, isTrue);
      expect(driver.openDisputesCount, 2);
    });
  });

  group('DeliveryOrderModel', () {
    test('parses order and exposes next action label', () {
      final order = DeliveryOrderModel.fromJson(const {
        'id': 99,
        'order_number': 'ORD-99',
        'company_id': 3,
        'driver_id': 7,
        'status': 'in_progress',
        'customer_name': 'عبد الله',
        'customer_phone': '0999999999',
        'pickup_address': 'نقطة الاستلام',
        'pickup_latitude': 36.2,
        'pickup_longitude': 37.1,
        'dropoff_address': 'نقطة التسليم',
        'dropoff_latitude': 36.3,
        'dropoff_longitude': 37.2,
        'distance_km': 3.2,
        'delivery_fee': 145,
        'currency': 'SYP',
      });

      expect(order.orderNumber, 'ORD-99');
      expect(order.hasLifecycleAction, isTrue);
      expect(order.nextActionLabel, 'تأكيد الاستلام');
      expect(order.distanceKm, 3.2);
    });
  });

  group('DeliveryAssignmentAttemptModel', () {
    test('parses nested order', () {
      final offer = DeliveryAssignmentAttemptModel.fromJson(const {
        'id': 5,
        'order_id': 99,
        'driver_id': 7,
        'attempt_no': 1,
        'status': 'offered',
        'distance_to_pickup_km': 1.4,
        'order': {
          'id': 99,
          'order_number': 'ORD-99',
          'company_id': 3,
          'driver_id': 7,
          'status': 'offered',
          'pickup_address': 'مطعم',
          'dropoff_address': 'بيت العميل',
          'delivery_fee': 250,
          'currency': 'SYP',
        },
      });

      expect(offer.id, 5);
      expect(offer.order?.deliveryFee, 250);
      expect(offer.order?.pickupAddress, 'مطعم');
    });
  });
}
