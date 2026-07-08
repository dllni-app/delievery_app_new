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

  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _loadDeliveryDashboardUseCase(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: failure.message),
      ),
      (snapshot) => emit(
        state.copyWith(
          isLoading: false,
          currentOffer: snapshot.currentOffer,
          clearOffer: snapshot.currentOffer == null,
          currentOrder: snapshot.currentOrder,
          clearOrder: snapshot.currentOrder == null,
        ),
      ),
    );
  }

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
          state.copyWith(
            isActionLoading: false,
            errorMessage: failure.message,
          ),
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
          state.copyWith(
            isActionLoading: false,
            errorMessage: failure.message,
          ),
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
    if (!order.hasLifecycleAction) return;

    emit(state.copyWith(isActionLoading: true, clearError: true));

    final result = await _performOrderActionUseCase(
      PerformOrderActionParams(order: order),
    );

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            isActionLoading: false,
            errorMessage: failure.message,
          ),
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

    final result = await _getDisputesUseCase(GetDisputesParams(perPage: perPage));

    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: failure.message),
      ),
      (disputes) => emit(
        state.copyWith(isLoading: false, disputes: disputes),
      ),
    );
  }
}
