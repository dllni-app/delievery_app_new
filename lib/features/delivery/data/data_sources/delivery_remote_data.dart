import 'package:injectable/injectable.dart';

import '../../../../common/helper/src/typedef.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../../../../core/unified_api/dio/api_client.dart';
import '../../../../core/unified_api/error/api_handeler_manager.dart';
import '../models/delivery_dispute_model.dart';
import '../models/delivery_offer_model.dart';
import '../models/delivery_order_model.dart';

@lazySingleton
class DeliveryRemoteData with HandlingApiManager {
  DeliveryRemoteData({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<DeliveryAssignmentAttemptModel?> getCurrentOffer() async =>
      wrapHandlingApi(
        tryCall: () => _apiClient.get(ApiVariables.getCurrentOffer()),
        jsonConvert: deliveryOfferModelFromNullableJson,
      );

  Future<DeliveryOrderModel> acceptOffer(int attemptId) async =>
      wrapHandlingApi(
        tryCall: () => _apiClient.post(ApiVariables.acceptOffer(attemptId)),
        jsonConvert: deliveryOrderModelFromJson,
      );

  Future<void> rejectOffer(int attemptId, String reason) async =>
      wrapHandlingApi(
        tryCall: () => _apiClient.post(
          ApiVariables.rejectOffer(attemptId),
          data: <String, dynamic>{'reason': reason},
        ),
        jsonConvert: (_) {},
      );

  Future<DeliveryOrderModel?> getCurrentOrder() async => wrapHandlingApi(
    tryCall: () => _apiClient.get(ApiVariables.getCurrentDeliveryOrder()),
    jsonConvert: deliveryOrderModelFromNullableJson,
  );

  Future<DeliveryOrderModel> startOrder(int orderId) async => wrapHandlingApi(
    tryCall: () => _apiClient.post(ApiVariables.startDeliveryOrder(orderId)),
    jsonConvert: deliveryOrderModelFromJson,
  );

  Future<DeliveryOrderModel> pickupOrder(int orderId) async => wrapHandlingApi(
    tryCall: () => _apiClient.post(ApiVariables.pickupDeliveryOrder(orderId)),
    jsonConvert: deliveryOrderModelFromJson,
  );

  Future<DeliveryOrderModel> deliverOrder(int orderId) async => wrapHandlingApi(
    tryCall: () => _apiClient.post(ApiVariables.deliverDeliveryOrder(orderId)),
    jsonConvert: deliveryOrderModelFromJson,
  );

  Future<DeliveryDisputesResponse> getDisputes(QueryParams params) async =>
      wrapHandlingApi(
        tryCall: () => _apiClient.get(ApiVariables.getDisputes(params)),
        jsonConvert: deliveryDisputesResponseFromJson,
      );
}
