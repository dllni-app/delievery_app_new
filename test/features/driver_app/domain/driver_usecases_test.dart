import 'package:dllne_deliver_app/features/driver_app/data/driver_models.dart';
import 'package:dllne_deliver_app/features/driver_app/domain/driver_data_source.dart';
import 'package:dllne_deliver_app/features/driver_app/domain/usecases/driver_usecases.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PerformOrderLifecycleActionUseCase', () {
    test('starts accepted order', () async {
      final source = _FakeDriverDataSource();
      final useCase = PerformOrderLifecycleActionUseCase(source);

      final result = await useCase(_order(status: 'accepted'));

      expect(source.lastAction, 'start');
      expect(result.status, 'in_progress');
    });

    test('marks in progress order as picked up', () async {
      final source = _FakeDriverDataSource();
      final useCase = PerformOrderLifecycleActionUseCase(source);

      final result = await useCase(_order(status: 'in_progress'));

      expect(source.lastAction, 'pickup');
      expect(result.status, 'picked_up');
    });

    test('marks picked up order as delivered', () async {
      final source = _FakeDriverDataSource();
      final useCase = PerformOrderLifecycleActionUseCase(source);

      final result = await useCase(_order(status: 'picked_up'));

      expect(source.lastAction, 'deliver');
      expect(result.status, 'delivered');
    });
  });
}

class _FakeDriverDataSource implements DriverDataSource {
  String? lastAction;

  @override
  Future<LoginResult> login({required String phone, required String password, String? fcmToken}) async {
    return LoginResult(token: 'token', driver: await getMe());
  }

  @override
  Future<void> logout() async {}

  @override
  Future<DriverModel> getMe() async {
    return const DriverModel(
      id: 7,
      userId: 11,
      companyId: 3,
      firstName: 'Driver',
      phone: '0999999999',
      vehicleType: 'motorbike',
      plateNumber: 'A-123',
      availabilityStatus: 'available',
      isActive: true,
      isSuspended: false,
      trustScore: 90,
      openDisputesCount: 0,
    );
  }

  @override
  Future<DriverModel> updateAvailability(String availabilityStatus) async {
    final driver = await getMe();
    return driver.copyWith(availabilityStatus: availabilityStatus);
  }

  @override
  Future<void> postLocation({required double latitude, required double longitude, double? accuracy, double? speed, double? heading}) async {}

  @override
  Future<DeliveryAssignmentAttemptModel?> getCurrentOffer() async => null;

  @override
  Future<DeliveryOrderModel> acceptOffer(int attemptId) async => _order(status: 'accepted');

  @override
  Future<void> rejectOffer(int attemptId, String reason) async {}

  @override
  Future<DeliveryOrderModel?> getCurrentOrder() async => _order(status: 'accepted');

  @override
  Future<DeliveryOrderModel> startOrder(int orderId) async {
    lastAction = 'start';
    return _order(status: 'in_progress');
  }

  @override
  Future<DeliveryOrderModel> pickupOrder(int orderId) async {
    lastAction = 'pickup';
    return _order(status: 'picked_up');
  }

  @override
  Future<DeliveryOrderModel> deliverOrder(int orderId) async {
    lastAction = 'deliver';
    return _order(status: 'delivered');
  }

  @override
  Future<DeliveryFinancialSummaryModel> getFinancialSummary() async {
    return const DeliveryFinancialSummaryModel(
      currentBalance: 1000,
      financialLimit: 5000,
      isSuspended: false,
      currency: 'SYP',
    );
  }

  @override
  Future<List<UserNotificationModel>> getNotifications({int perPage = 20, bool unreadOnly = false}) async => const [];

  @override
  Future<void> markNotificationRead(String id) async {}

  @override
  Future<List<DeliveryDisputeModel>> getDisputes({int perPage = 20}) async => const [];

  @override
  String userFacingError(Object error) => error.toString();

  @override
  bool isUnauthorized(Object error) => false;
}

DeliveryOrderModel _order({required String status}) {
  return DeliveryOrderModel(
    id: 99,
    orderNumber: 'ORD-99',
    companyId: 3,
    driverId: 7,
    status: status,
    customerName: 'Customer',
    customerPhone: '0999999999',
    pickupAddress: 'Pickup',
    pickupLatitude: 36.2,
    pickupLongitude: 37.1,
    dropoffAddress: 'Dropoff',
    dropoffLatitude: 36.3,
    dropoffLongitude: 37.2,
    distanceKm: 3.2,
    deliveryFee: 250,
    currency: 'SYP',
    events: const [],
  );
}
