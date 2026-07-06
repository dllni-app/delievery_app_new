import '../../data/driver_dashboard_models.dart';
import '../../data/driver_models.dart';
import '../../data/driver_optional_api_service.dart';

class LoadDriverOrderHistoryUseCase {
  const LoadDriverOrderHistoryUseCase(this._service);

  final DriverOptionalApiService _service;

  Future<List<DeliveryOrderModel>> call({int perPage = 20, String? status}) {
    return _service.getOrders(perPage: perPage, status: status);
  }
}

class LoadDriverDashboardSummaryUseCase {
  const LoadDriverDashboardSummaryUseCase(this._service);

  final DriverOptionalApiService _service;

  Future<DeliveryDashboardSummaryModel?> call() {
    return _service.getDashboardSummary();
  }
}
