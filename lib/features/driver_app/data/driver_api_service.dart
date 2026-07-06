import 'package:dio/dio.dart';

import '../../../common/helper/helper.dart';
import '../../../core/config/app_config.dart';
import '../../../core/unified_api/dio/api_client.dart';
import 'driver_models.dart';

class DriverApiService {
  DriverApiService(this._apiClient);

  final ApiClient _apiClient;

  String get baseUrl => AppConfig.driverApiBaseUrl;

  Future<LoginResult> login({required String phone, required String password, String? fcmToken}) async {
    final response = await _apiClient.post(
      Uri.parse('$baseUrl/auth/login'),
      data: <String, dynamic>{
        'phone': phone,
        'password': password,
        if (fcmToken != null && fcmToken.isNotEmpty) 'fcmToken': fcmToken,
      },
    );

    final body = _asMap(response.data);
    final data = _asMap(body['data']);
    return LoginResult(
      token: (body['token'] ?? data['token'])?.toString() ?? '',
      driver: DriverModel.fromJson(_asMap(data['driver'] ?? body['driver'])),
    );
  }

  Future<void> logout() async {
    await _apiClient.post(Uri.parse('$baseUrl/auth/logout'));
  }

  Future<DriverModel> getMe() async {
    final response = await _apiClient.get(Uri.parse('$baseUrl/me'));
    return DriverModel.fromJson(unwrapData(response.data));
  }

  Future<DriverModel> updateAvailability(String availabilityStatus) async {
    final response = await _apiClient.patch(
      Uri.parse('$baseUrl/availability'),
      data: <String, dynamic>{'availabilityStatus': availabilityStatus},
    );
    return DriverModel.fromJson(unwrapData(response.data));
  }

  Future<void> postLocation({
    required double latitude,
    required double longitude,
    double? accuracy,
    double? speed,
    double? heading,
  }) async {
    await _apiClient.post(
      Uri.parse('$baseUrl/location'),
      data: <String, dynamic>{
        'latitude': latitude,
        'longitude': longitude,
        if (accuracy != null) 'accuracy': accuracy,
        if (speed != null) 'speed': speed,
        if (heading != null) 'heading': heading,
      },
    );
  }

  Future<DeliveryAssignmentAttemptModel?> getCurrentOffer() async {
    final response = await _apiClient.get(Uri.parse('$baseUrl/offers/current'));
    final body = _asMap(response.data);
    final data = body['data'];
    if (data == null) return null;
    return DeliveryAssignmentAttemptModel.fromJson(_asMap(data));
  }

  Future<DeliveryOrderModel> acceptOffer(int attemptId) async {
    final response = await _apiClient.post(Uri.parse('$baseUrl/offers/$attemptId/accept'));
    return DeliveryOrderModel.fromJson(unwrapData(response.data));
  }

  Future<void> rejectOffer(int attemptId, String reason) async {
    await _apiClient.post(
      Uri.parse('$baseUrl/offers/$attemptId/reject'),
      data: <String, dynamic>{'reason': reason},
    );
  }

  Future<DeliveryOrderModel?> getCurrentOrder() async {
    final response = await _apiClient.get(Uri.parse('$baseUrl/orders/current'));
    final body = _asMap(response.data);
    final data = body['data'];
    if (data == null) return null;
    return DeliveryOrderModel.fromJson(_asMap(data));
  }

  Future<DeliveryOrderModel> startOrder(int orderId) async => _orderAction(orderId, 'start');

  Future<DeliveryOrderModel> pickupOrder(int orderId) async => _orderAction(orderId, 'pickup');

  Future<DeliveryOrderModel> deliverOrder(int orderId) async => _orderAction(orderId, 'deliver');

  Future<DeliveryOrderModel> _orderAction(int orderId, String action) async {
    final response = await _apiClient.post(Uri.parse('$baseUrl/orders/$orderId/$action'));
    return DeliveryOrderModel.fromJson(unwrapData(response.data));
  }

  Future<DeliveryFinancialSummaryModel> getFinancialSummary() async {
    final response = await _apiClient.get(Uri.parse('$baseUrl/financial/summary'));
    return DeliveryFinancialSummaryModel.fromJson(unwrapData(response.data));
  }

  Future<List<UserNotificationModel>> getNotifications({int perPage = 20, bool unreadOnly = false}) async {
    final uri = Uri.parse('$baseUrl/notifications').replace(
      queryParameters: <String, String>{
        'perPage': perPage.toString(),
        if (unreadOnly) 'filter[unread]': '1',
      },
    );
    final response = await _apiClient.get(uri);
    return unwrapDataList(response.data).map(UserNotificationModel.fromJson).toList();
  }

  Future<void> markNotificationRead(String id) async {
    await _apiClient.patch(Uri.parse('$baseUrl/notifications/$id/read'));
  }

  Future<List<DeliveryDisputeModel>> getDisputes({int perPage = 20}) async {
    final uri = Uri.parse('$baseUrl/disputes').replace(queryParameters: <String, String>{'perPage': perPage.toString()});
    final response = await _apiClient.get(uri);
    return unwrapDataList(response.data).map(DeliveryDisputeModel.fromJson).toList();
  }

  String userFacingError(Object error) {
    if (error is DioException) {
      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        final message = responseData['message'] ?? responseData['error'];
        if (message != null) return message.toString();
        final errors = responseData['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final first = errors.values.first;
          if (first is List && first.isNotEmpty) return first.first.toString();
          return first.toString();
        }
      }
      if (error.response?.statusCode == 401) return 'انتهت الجلسة، يرجى تسجيل الدخول مجدداً';
      if (error.response?.statusCode == 403) return 'لا تملك صلاحية الوصول كمندوب توصيل';
      if (error.response?.statusCode == 409) return 'لم يعد الطلب متاحاً، يرجى التحديث';
      if (error.response?.statusCode == 422) return 'الطلب غير صالح أو حالة الطلب لا تسمح بهذا الإجراء';
      return 'تعذر الاتصال بالخادم، تحقق من الإنترنت وحاول مرة أخرى';
    }
    return 'حدث خطأ غير متوقع';
  }
}

Map<String, dynamic> _asMap(Object? value) => value is Map<String, dynamic> ? value : <String, dynamic>{};
