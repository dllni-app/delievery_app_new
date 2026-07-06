import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/helper/helper.dart';
import '../../../core/di/injection.dart';
import '../../../core/unified_api/dio/api_client.dart';
import '../domain/driver_data_source.dart';
import 'driver_api_service.dart';
import 'driver_models.dart';

class DriverDataSourceImpl implements DriverDataSource {
  const DriverDataSourceImpl(this._service);

  final DriverApiService _service;

  @override
  Future<LoginResult> login({required String phone, required String password, String? fcmToken}) {
    return _guard(() => _service.login(phone: phone, password: password, fcmToken: fcmToken));
  }

  @override
  Future<void> logout() => _guard(_service.logout);

  @override
  Future<DriverModel> getMe() => _guard(_service.getMe);

  @override
  Future<DriverModel> updateAvailability(String availabilityStatus) => _guard(() => _service.updateAvailability(availabilityStatus));

  @override
  Future<void> postLocation({required double latitude, required double longitude, double? accuracy, double? speed, double? heading}) {
    return _guard(() => _service.postLocation(latitude: latitude, longitude: longitude, accuracy: accuracy, speed: speed, heading: heading));
  }

  @override
  Future<DeliveryAssignmentAttemptModel?> getCurrentOffer() => _guard(_service.getCurrentOffer);

  @override
  Future<DeliveryOrderModel> acceptOffer(int attemptId) => _guard(() => _service.acceptOffer(attemptId));

  @override
  Future<void> rejectOffer(int attemptId, String reason) => _guard(() => _service.rejectOffer(attemptId, reason));

  @override
  Future<DeliveryOrderModel?> getCurrentOrder() => _guard(_service.getCurrentOrder);

  @override
  Future<DeliveryOrderModel> startOrder(int orderId) => _guard(() => _service.startOrder(orderId));

  @override
  Future<DeliveryOrderModel> pickupOrder(int orderId) => _guard(() => _service.pickupOrder(orderId));

  @override
  Future<DeliveryOrderModel> deliverOrder(int orderId) => _guard(() => _service.deliverOrder(orderId));

  @override
  Future<DeliveryFinancialSummaryModel> getFinancialSummary() => _guard(_service.getFinancialSummary);

  @override
  Future<List<UserNotificationModel>> getNotifications({int perPage = 20, bool unreadOnly = false}) {
    return _guard(() => _service.getNotifications(perPage: perPage, unreadOnly: unreadOnly));
  }

  @override
  Future<void> markNotificationRead(String id) => _guard(() => _service.markNotificationRead(id));

  @override
  Future<List<DeliveryDisputeModel>> getDisputes({int perPage = 20}) => _guard(() => _service.getDisputes(perPage: perPage));

  @override
  String userFacingError(Object error) => _service.userFacingError(error);

  @override
  bool isUnauthorized(Object error) => _service.isUnauthorized(error);

  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } catch (error) {
      if (isUnauthorized(error)) {
        await _clearLocalSession();
      }
      rethrow;
    }
  }

  Future<void> _clearLocalSession() async {
    final preferences = getIt<SharedPreferences>();
    await preferences.remove(PrefsKeys.token);
    await preferences.remove(PrefsKeys.userInfo);
    getIt<ApiClient>().resetHeader();
  }
}
