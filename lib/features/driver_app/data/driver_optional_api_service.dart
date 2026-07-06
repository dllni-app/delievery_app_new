import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';
import '../../../core/unified_api/dio/api_client.dart';
import 'driver_dashboard_models.dart';
import 'driver_models.dart';

class DriverOptionalApiService {
  DriverOptionalApiService(this._apiClient);

  final ApiClient _apiClient;

  String get baseUrl => AppConfig.driverApiBaseUrl;

  Future<List<DeliveryOrderModel>> getOrders({int perPage = 20, String? status}) async {
    final uri = Uri.parse('$baseUrl/orders').replace(
      queryParameters: <String, String>{
        'perPage': perPage.toString(),
        if (status != null && status.isNotEmpty) 'filter[status]': status,
      },
    );

    try {
      final response = await _apiClient.get(uri);
      return unwrapDataList(response.data).map(DeliveryOrderModel.fromJson).toList();
    } on DioException catch (error) {
      if (_isMissingOptionalEndpoint(error)) return const [];
      rethrow;
    }
  }

  Future<DeliveryDashboardSummaryModel?> getDashboardSummary() async {
    try {
      final response = await _apiClient.get(Uri.parse('$baseUrl/dashboard/summary'));
      return DeliveryDashboardSummaryModel.fromJson(unwrapData(response.data));
    } on DioException catch (error) {
      if (_isMissingOptionalEndpoint(error)) return null;
      rethrow;
    }
  }

  bool _isMissingOptionalEndpoint(DioException error) {
    final statusCode = error.response?.statusCode;
    return statusCode == 404 || statusCode == 405;
  }
}
