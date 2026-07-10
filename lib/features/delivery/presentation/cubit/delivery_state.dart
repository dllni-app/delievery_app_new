part of 'delivery_cubit.dart';

class DeliveryState extends Equatable {
  const DeliveryState({
    this.isLoading = false,
    this.isActionLoading = false,
    this.errorMessage,
    this.currentOffer,
    this.currentOrder,
    this.disputes = const [],
    this.disputesSummary = const DeliveryDisputesSummary(),
  });

  final bool isLoading;
  final bool isActionLoading;
  final String? errorMessage;
  final DeliveryAssignmentAttemptModel? currentOffer;
  final DeliveryOrderModel? currentOrder;
  final List<DeliveryDisputeModel> disputes;
  final DeliveryDisputesSummary disputesSummary;

  DeliveryState copyWith({
    bool? isLoading,
    bool? isActionLoading,
    String? errorMessage,
    bool clearError = false,
    DeliveryAssignmentAttemptModel? currentOffer,
    bool clearOffer = false,
    DeliveryOrderModel? currentOrder,
    bool clearOrder = false,
    List<DeliveryDisputeModel>? disputes,
    DeliveryDisputesSummary? disputesSummary,
  }) {
    return DeliveryState(
      isLoading: isLoading ?? this.isLoading,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      currentOffer: clearOffer ? null : currentOffer ?? this.currentOffer,
      currentOrder: clearOrder ? null : currentOrder ?? this.currentOrder,
      disputes: disputes ?? this.disputes,
      disputesSummary: disputesSummary ?? this.disputesSummary,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isActionLoading,
    errorMessage,
    currentOffer,
    currentOrder,
    disputes,
    disputesSummary,
  ];
}
