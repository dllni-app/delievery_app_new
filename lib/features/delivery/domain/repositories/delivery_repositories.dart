import '../../../../common/helper/src/typedef.dart';
import '../../data/models/delivery_dispute_model.dart';
import '../../data/models/driver_order_status_counts.dart';
import '../../data/models/delivery_offer_model.dart';
import '../../data/models/delivery_order_model.dart';

abstract class DeliveryRepositories {
  DataResponse<DeliveryAssignmentAttemptModel?> getCurrentOffer();

  DataResponse<DeliveryOrderModel> acceptOffer(int attemptId);

  DataResponse<void> rejectOffer(int attemptId, String reason);

  DataResponse<DeliveryOrderModel?> getCurrentOrder();

  DataResponse<DriverOrderStatusCounts> getOrderStatusCounts();

  DataResponse<DeliveryOrderModel> startOrder(int orderId);

  DataResponse<DeliveryOrderModel> arrivedPickup(int orderId);

  DataResponse<DeliveryOrderModel> pickupOrder(int orderId);

  DataResponse<DeliveryOrderModel> arrivedDropoff(int orderId);

  DataResponse<DeliveryOrderModel> reportDeliveryFailure(
    int orderId,
    String reasonCode,
    String? reason,
  );

  DataResponse<DeliveryOrderModel> returnedToMerchant(int orderId);

  DataResponse<DeliveryOrderModel> deliverOrder(int orderId);

  DataResponse<DeliveryDisputesResponse> getDisputes(QueryParams params);
}
