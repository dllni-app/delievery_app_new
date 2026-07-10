import 'package:injectable/injectable.dart';

import '../../../../common/helper/src/typedef.dart';
import '../../../../core/unified_api/error/error_handeler.dart';
import '../../domain/repositories/delivery_repositories.dart';
import '../data_sources/delivery_remote_data.dart';
import '../models/delivery_dispute_model.dart';
import '../models/delivery_offer_model.dart';
import '../models/delivery_order_model.dart';

@LazySingleton(as: DeliveryRepositories)
class DeliveryRepositoriesImp
    with HandlingException
    implements DeliveryRepositories {
  DeliveryRepositoriesImp({required DeliveryRemoteData remoteData})
    : _remoteData = remoteData;

  final DeliveryRemoteData _remoteData;

  @override
  DataResponse<DeliveryAssignmentAttemptModel?> getCurrentOffer() async =>
      wrapHandlingException(tryCall: () => _remoteData.getCurrentOffer());

  @override
  DataResponse<DeliveryOrderModel> acceptOffer(int attemptId) async =>
      wrapHandlingException(tryCall: () => _remoteData.acceptOffer(attemptId));

  @override
  DataResponse<void> rejectOffer(int attemptId, String reason) async =>
      wrapHandlingException(
        tryCall: () => _remoteData.rejectOffer(attemptId, reason),
      );

  @override
  DataResponse<DeliveryOrderModel?> getCurrentOrder() async =>
      wrapHandlingException(tryCall: () => _remoteData.getCurrentOrder());

  @override
  DataResponse<DeliveryOrderModel> startOrder(int orderId) async =>
      wrapHandlingException(tryCall: () => _remoteData.startOrder(orderId));

  @override
  DataResponse<DeliveryOrderModel> pickupOrder(int orderId) async =>
      wrapHandlingException(tryCall: () => _remoteData.pickupOrder(orderId));

  @override
  DataResponse<DeliveryOrderModel> deliverOrder(int orderId) async =>
      wrapHandlingException(tryCall: () => _remoteData.deliverOrder(orderId));

  @override
  DataResponse<DeliveryDisputesResponse> getDisputes(
    QueryParams params,
  ) async =>
      wrapHandlingException(tryCall: () => _remoteData.getDisputes(params));
}
