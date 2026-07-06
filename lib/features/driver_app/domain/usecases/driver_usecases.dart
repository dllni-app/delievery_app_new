import '../driver_data_source.dart';
import '../../data/driver_models.dart';

class DriverLoginUseCase {
  const DriverLoginUseCase(this._dataSource);
  final DriverDataSource _dataSource;

  Future<LoginResult> call({required String phone, required String password, String? fcmToken}) {
    return _dataSource.login(phone: phone, password: password, fcmToken: fcmToken);
  }
}

class LoadDriverDashboardUseCase {
  const LoadDriverDashboardUseCase(this._dataSource);
  final DriverDataSource _dataSource;

  Future<DriverDashboardSnapshot> call() async {
    final results = await Future.wait<Object?>([
      _dataSource.getMe(),
      _dataSource.getCurrentOffer(),
      _dataSource.getCurrentOrder(),
      _dataSource.getFinancialSummary(),
    ]);

    return DriverDashboardSnapshot(
      driver: results[0] as DriverModel,
      currentOffer: results[1] as DeliveryAssignmentAttemptModel?,
      currentOrder: results[2] as DeliveryOrderModel?,
      financialSummary: results[3] as DeliveryFinancialSummaryModel,
    );
  }
}

class UpdateDriverAvailabilityUseCase {
  const UpdateDriverAvailabilityUseCase(this._dataSource);
  final DriverDataSource _dataSource;

  Future<DriverModel> call(String availabilityStatus) {
    return _dataSource.updateAvailability(availabilityStatus);
  }
}

class RespondToOfferUseCase {
  const RespondToOfferUseCase(this._dataSource);
  final DriverDataSource _dataSource;

  Future<DeliveryOrderModel> accept(int attemptId) => _dataSource.acceptOffer(attemptId);

  Future<void> reject(int attemptId, String reason) => _dataSource.rejectOffer(attemptId, reason);
}

class PerformOrderLifecycleActionUseCase {
  const PerformOrderLifecycleActionUseCase(this._dataSource);
  final DriverDataSource _dataSource;

  Future<DeliveryOrderModel> call(DeliveryOrderModel order) {
    if (order.status == 'accepted' || order.status == 'offered') {
      return _dataSource.startOrder(order.id);
    }
    if (order.status == 'in_progress') {
      return _dataSource.pickupOrder(order.id);
    }
    if (order.status == 'picked_up') {
      return _dataSource.deliverOrder(order.id);
    }
    return Future.value(order);
  }
}

class DriverDashboardSnapshot {
  const DriverDashboardSnapshot({
    required this.driver,
    required this.currentOffer,
    required this.currentOrder,
    required this.financialSummary,
  });

  final DriverModel driver;
  final DeliveryAssignmentAttemptModel? currentOffer;
  final DeliveryOrderModel? currentOrder;
  final DeliveryFinancialSummaryModel financialSummary;
}
