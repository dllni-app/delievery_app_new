import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/use_case/use_case.dart';
import '../../data/models/delivery_dispute_model.dart';
import '../../data/models/delivery_offer_model.dart';
import '../../data/models/delivery_order_model.dart';
import '../../domain/use_cases/accept_offer_use_case.dart';
import '../../domain/use_cases/get_disputes_use_case.dart';
import '../../domain/use_cases/load_delivery_dashboard_use_case.dart';
import '../../domain/use_cases/perform_order_action_use_case.dart';
import '../../domain/use_cases/reject_offer_use_case.dart';

part 'delivery_state.dart';

@lazySingleton
class DeliveryCubit extends Cubit<DeliveryState> {
  DeliveryCubit(
    this._loadDeliveryDashboardUseCase,
    this._acceptOfferUseCase,
    this._rejectOfferUseCase,
    this._performOrderActionUseCase,
    this._getDisputesUseCase,
  ) : super(const DeliveryState());

  final LoadDeliveryDashboardUseCase _loadDeliveryDashboardUseCase;
  final AcceptOfferUseCase _acceptOfferUseCase;
  final RejectOfferUseCase _rejectOfferUseCase;
  final PerformOrderActionUseCase _performOrderActionUseCase;
  final GetDisputesUseCase _getDisputesUseCase;

  Timer? _readinessTimer;
  Timer? _offerExpiryTimer;
  bool _dashboardRequestInFlight = false;

  Future<void> loadDashboard() async {
    if (_dashboardRequestInFlight || isClosed) return;
    _dashboardRequestInFlight = true;
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _loadDeliveryDashboardUseCase(NoParams());
    _dashboardRequestInFlight = false;
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (snapshot) {
        emit(
          state.copyWith(
            isLoading: false,
            // Do not keep a stale expired offer when the dashboard responds.
            currentOffer: snapshot.currentOffer != null &&
                    !snapshot.currentOffer!.isExpired
                ? snapshot.currentOffer
                : null,
            clearOffer: snapshot.currentOffer == null ||
                snapshot.currentOffer!.isExpired,
            currentOrder: snapshot.currentOrder,
            clearOrder: snapshot.currentOrder == null,
          ),
        );
        _syncReadinessPolling(snapshot.currentOrder);
        _syncOfferExpiry(snapshot.currentOffer);
      },
    );
  }

  Future<void> refreshAfterNotification() => loadDashboard();

  Future<void> acceptOffer(DeliveryAssignmentAttemptModel offer) async {
    if (offer.isExpired) {
      emit(state.copyWith(errorMessage: 'انتهت صلاحية العرض، يرجى التحديث'));
      await loadDashboard();
      return;
    }

    emit(state.copyWith(isActionLoading: true, clearError: true));

    final result = await _acceptOfferUseCase(
      AcceptOfferParams(attemptId: offer.id),
    );

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(isActionLoading: false, errorMessage: failure.message),
        );
        await loadDashboard();
      },
      (order) async {
        emit(
          state.copyWith(
            isActionLoading: false,
            currentOrder: order,
            clearOffer: true,
          ),
        );
        _syncReadinessPolling(order);
        await loadDashboard();
      },
    );
  }

  Future<void> rejectOffer(
    DeliveryAssignmentAttemptModel offer,
    String reason,
  ) async {
    if (reason.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'اكتب سبب رفض الطلب'));
      return;
    }

    emit(state.copyWith(isActionLoading: true, clearError: true));

    final result = await _rejectOfferUseCase(
      RejectOfferParams(attemptId: offer.id, reason: reason.trim()),
    );

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(isActionLoading: false, errorMessage: failure.message),
        );
        await loadDashboard();
      },
      (_) async {
        emit(state.copyWith(isActionLoading: false, clearOffer: true));
        await loadDashboard();
      },
    );
  }

  Future<void> performOrderAction(DeliveryOrderModel order) async {
    if (!order.hasLifecycleAction) {
      if (order.isPickupBlocked) {
        emit(state.copyWith(errorMessage: 'الطلب لم يصبح جاهزاً للاستلام بعد'));
      }
      return;
    }

    emit(state.copyWith(isActionLoading: true, clearError: true));

    final result = await _performOrderActionUseCase(
      PerformOrderActionParams(order: order),
    );

    await result.fold(
      (failure) async {
        final message = failure.statusCode == 409
            ? 'الطلب لم يصبح جاهزاً للاستلام بعد. تم تحديث حالة التجهيز.'
            : failure.message;
        emit(state.copyWith(isActionLoading: false, errorMessage: message));
        await loadDashboard();
      },
      (updatedOrder) async {
        emit(
          state.copyWith(isActionLoading: false, currentOrder: updatedOrder),
        );
        _syncReadinessPolling(updatedOrder);
        await loadDashboard();
      },
    );
  }

  Future<void> reportDeliveryFailure(
    DeliveryOrderModel order,
    String reasonCode,
    String? reason,
  ) async {
    if (reasonCode == 'OTHER' && (reason == null || reason.trim().isEmpty)) {
      emit(state.copyWith(errorMessage: 'اكتب سبب تعذر التسليم'));
      return;
    }

    emit(state.copyWith(isActionLoading: true, clearError: true));
    final result = await _performOrderActionUseCase(
      PerformOrderActionParams(
        order: order,
        action: 'delivery_failed',
        reasonCode: reasonCode,
        reason: reason,
      ),
    );

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(isActionLoading: false, errorMessage: failure.message),
        );
        await loadDashboard();
      },
      (updatedOrder) async {
        emit(
          state.copyWith(isActionLoading: false, currentOrder: updatedOrder),
        );
        await loadDashboard();
      },
    );
  }

  Future<void> loadDisputes({int perPage = 10}) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _getDisputesUseCase(
      GetDisputesParams(perPage: perPage),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (response) => emit(
        state.copyWith(
          isLoading: false,
          disputes: response.disputes,
          disputesSummary: response.summary,
        ),
      ),
    );
  }

  void _syncOfferExpiry(DeliveryAssignmentAttemptModel? offer) {
    _offerExpiryTimer?.cancel();
    _offerExpiryTimer = null;
    if (offer == null || offer.expiresAt == null || isClosed) return;
    if (offer.isExpired) return;

    final delay = offer.expiresAt!.difference(DateTime.now());
    _offerExpiryTimer = Timer(delay + const Duration(milliseconds: 50), () {
      if (isClosed || state.currentOffer?.id != offer.id) return;
      // Remove it from the UI immediately, then sync from the backend.
      emit(state.copyWith(clearOffer: true));
      loadDashboard();
    });
  }

  void _syncReadinessPolling(DeliveryOrderModel? order) {
    _readinessTimer?.cancel();
    _readinessTimer = null;

    if (order == null || !order.isWaitingForMerchantReadiness || isClosed) {
      return;
    }

    _readinessTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => loadDashboard(),
    );
  }

  @override
  Future<void> close() {
    _readinessTimer?.cancel();
    _offerExpiryTimer?.cancel();
    return super.close();
  }
}
