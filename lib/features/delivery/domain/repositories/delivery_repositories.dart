import '../../../../common/helper/src/typedef.dart';
import '../../data/models/delivery_dispute_model.dart';
import '../../data/models/delivery_offer_model.dart';
import '../../data/models/delivery_order_model.dart';

abstract class DeliveryRepositories {
  DataResponse<DeliveryAssignmentAttemptModel?> getCurrentOffer();

  DataResponse<DeliveryOrderModel> acceptOffer(int attemptId);

  DataResponse<void> rejectOffer(int attemptId, String reason);

  DataResponse<DeliveryOrderModel?> getCurrentOrder();

  DataResponse<DeliveryOrderModel> startOrder(int orderId);

  DataResponse<DeliveryOrderModel> pickupOrder(int orderId);

  DataResponse<DeliveryOrderModel> deliverOrder(int orderId);

  DataResponse<DeliveryDisputesResponse> getDisputes(QueryParams params);
}
