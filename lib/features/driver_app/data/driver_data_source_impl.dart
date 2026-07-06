import '../domain/driver_data_source.dart';
import 'driver_api_service.dart';
import 'driver_models.dart';

class DriverDataSourceImpl implements DriverDataSource {
  const DriverDataSourceImpl(this._service);

  final DriverApiService _service;

  @override
  Future<LoginResult> login({required String phone, required String password, String? fcmToken}) {
    return _service.login(phone: phone, password: password, fcmToken: fcmToken);
  }

  @override
  Future<void> logout() => _service.logout();

  @override
  Future<DriverModel> getMe() => _service.getMe();

  @override
  Future<DriverModel> updateAvailability(String availabilityStatus) => _service.updateAvailability(availabilityStatus);

  @override
  Future<void> postLocation({required double latitude, required double longitude, double? accuracy, double? speed, double? heading}) {
    return _service.postLocation(latitude: latitude, longitude: longitude, accuracy: accuracy, speed: speed, heading: heading);
  }

  @override
  Future<DeliveryAssignmentAttemptModel?> getCurrentOffer() => _service.getCurrentOffer();

  @override
  Future<DeliveryOrderModel> acceptOffer(int attemptId) => _service.acceptOffer(attemptId);

  @override
  Future<void> rejectOffer(int attemptId, String reason) => _service.rejectOffer(attemptId, reason);

  @override
  Future<DeliveryOrderModel?> getCurrentOrder() => _service.getCurrentOrder();

  @override
  Future<DeliveryOrderModel> startOrder(int orderId) => _service.startOrder(orderId);

  @override
  Future<DeliveryOrderModel> pickupOrder(int orderId) => _service.pickupOrder(orderId);

  @override
  Future<DeliveryOrderModel> deliverOrder(int orderId) => _service.deliverOrder(orderId);

  @override
  Future<DeliveryFinancialSummaryModel> getFinancialSummary() => _service.getFinancialSummary();

  @override
  Future<List<UserNotificationModel>> getNotifications({int perPage = 20, bool unreadOnly = false}) {
    return _service.getNotifications(perPage: perPage, unreadOnly: unreadOnly);
  }

  @override
  Future<void> markNotificationRead(String id) => _service.markNotificationRead(id);

  @override
  Future<List<DeliveryDisputeModel>> getDisputes({int perPage = 20}) => _service.getDisputes(perPage: perPage);

  @override
  String userFacingError(Object error) => _service.userFacingError(error);

  @override
  bool isUnauthorized(Object error) => _service.isUnauthorized(error);
}
