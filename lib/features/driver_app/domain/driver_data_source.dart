import '../data/driver_models.dart';

abstract class DriverDataSource {
  Future<LoginResult> login({required String phone, required String password, String? fcmToken});
  Future<void> logout();
  Future<DriverModel> getMe();
  Future<DriverModel> updateAvailability(String availabilityStatus);
  Future<void> postLocation({required double latitude, required double longitude, double? accuracy, double? speed, double? heading});
  Future<DeliveryAssignmentAttemptModel?> getCurrentOffer();
  Future<DeliveryOrderModel> acceptOffer(int attemptId);
  Future<void> rejectOffer(int attemptId, String reason);
  Future<DeliveryOrderModel?> getCurrentOrder();
  Future<DeliveryOrderModel> startOrder(int orderId);
  Future<DeliveryOrderModel> pickupOrder(int orderId);
  Future<DeliveryOrderModel> deliverOrder(int orderId);
  Future<DeliveryFinancialSummaryModel> getFinancialSummary();
  Future<List<UserNotificationModel>> getNotifications({int perPage = 20, bool unreadOnly = false});
  Future<void> markNotificationRead(String id);
  Future<List<DeliveryDisputeModel>> getDisputes({int perPage = 20});
  String userFacingError(Object error);
  bool isUnauthorized(Object error);
}
