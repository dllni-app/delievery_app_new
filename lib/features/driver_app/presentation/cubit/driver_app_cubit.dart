import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/helper/helper.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/unified_api/dio/api_client.dart';
import '../../data/driver_api_service.dart';
import '../../data/driver_dashboard_models.dart';
import '../../data/driver_data_source_impl.dart';
import '../../data/driver_models.dart';
import '../../data/driver_optional_api_service.dart';
import '../../domain/driver_data_source.dart';
import '../../domain/usecases/driver_optional_usecases.dart';
import '../../domain/usecases/driver_usecases.dart';

class DriverAppState extends Equatable {
  const DriverAppState({
    this.isBootstrapping = false,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.isActionLoading = false,
    this.errorMessage,
    this.driver,
    this.currentOffer,
    this.currentOrder,
    this.financialSummary,
    this.dashboardSummary,
    this.notifications = const [],
    this.disputes = const [],
    this.unreadOnly = false,
    this.currentTab = 0,
  });

  final bool isBootstrapping;
  final bool isAuthenticated;
  final bool isLoading;
  final bool isActionLoading;
  final String? errorMessage;
  final DriverModel? driver;
  final DeliveryAssignmentAttemptModel? currentOffer;
  final DeliveryOrderModel? currentOrder;
  final DeliveryFinancialSummaryModel? financialSummary;
  final DeliveryDashboardSummaryModel? dashboardSummary;
  final List<UserNotificationModel> notifications;
  final List<DeliveryDisputeModel> disputes;
  final bool unreadOnly;
  final int currentTab;

  DriverAppState copyWith({
    bool? isBootstrapping,
    bool? isAuthenticated,
    bool? isLoading,
    bool? isActionLoading,
    String? errorMessage,
    bool clearError = false,
    DriverModel? driver,
    bool clearDriver = false,
    DeliveryAssignmentAttemptModel? currentOffer,
    bool clearOffer = false,
    DeliveryOrderModel? currentOrder,
    bool clearOrder = false,
    DeliveryFinancialSummaryModel? financialSummary,
    DeliveryDashboardSummaryModel? dashboardSummary,
    bool clearDashboardSummary = false,
    List<UserNotificationModel>? notifications,
    List<DeliveryDisputeModel>? disputes,
    bool? unreadOnly,
    int? currentTab,
  }) {
    return DriverAppState(
      isBootstrapping: isBootstrapping ?? this.isBootstrapping,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      driver: clearDriver ? null : driver ?? this.driver,
      currentOffer: clearOffer ? null : currentOffer ?? this.currentOffer,
      currentOrder: clearOrder ? null : currentOrder ?? this.currentOrder,
      financialSummary: financialSummary ?? this.financialSummary,
      dashboardSummary: clearDashboardSummary ? null : dashboardSummary ?? this.dashboardSummary,
      notifications: notifications ?? this.notifications,
      disputes: disputes ?? this.disputes,
      unreadOnly: unreadOnly ?? this.unreadOnly,
      currentTab: currentTab ?? this.currentTab,
    );
  }

  @override
  List<Object?> get props => [
        isBootstrapping,
        isAuthenticated,
        isLoading,
        isActionLoading,
        errorMessage,
        driver,
        currentOffer,
        currentOrder,
        financialSummary,
        dashboardSummary,
        notifications,
        disputes,
        unreadOnly,
        currentTab,
      ];
}

class DriverAppCubit extends Cubit<DriverAppState> {
  DriverAppCubit({DriverDataSource? dataSource})
      : _dataSource = dataSource ?? DriverDataSourceImpl(DriverApiService(getIt<ApiClient>())),
        super(const DriverAppState()) {
    _loginUseCase = DriverLoginUseCase(_dataSource);
    _loadDashboardUseCase = LoadDriverDashboardUseCase(_dataSource);
    _updateAvailabilityUseCase = UpdateDriverAvailabilityUseCase(_dataSource);
    _respondToOfferUseCase = RespondToOfferUseCase(_dataSource);
    _orderLifecycleUseCase = PerformOrderLifecycleActionUseCase(_dataSource);
    _dashboardSummaryUseCase = LoadDriverDashboardSummaryUseCase(DriverOptionalApiService(getIt<ApiClient>()));
  }

  final DriverDataSource _dataSource;
  late final DriverLoginUseCase _loginUseCase;
  late final LoadDriverDashboardUseCase _loadDashboardUseCase;
  late final UpdateDriverAvailabilityUseCase _updateAvailabilityUseCase;
  late final RespondToOfferUseCase _respondToOfferUseCase;
  late final PerformOrderLifecycleActionUseCase _orderLifecycleUseCase;
  late final LoadDriverDashboardSummaryUseCase _dashboardSummaryUseCase;

  Future<void> bootstrap() async {
    emit(state.copyWith(isBootstrapping: true, clearError: true));
    if (AppVariables.token == null || AppVariables.token!.isEmpty) {
      emit(state.copyWith(isBootstrapping: false, isAuthenticated: false));
      return;
    }
    try {
      final driver = await _dataSource.getMe();
      emit(state.copyWith(isBootstrapping: false, isAuthenticated: true, driver: driver));
    } catch (error) {
      await _clearSession();
      emit(state.copyWith(isBootstrapping: false, isAuthenticated: false, errorMessage: _dataSource.userFacingError(error), clearDriver: true));
    }
  }

  Future<void> login({required String phone, required String password}) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final result = await _loginUseCase(phone: phone, password: password, fcmToken: AppVariables.fcmToken);
      AppVariables.token = result.token;
      getIt<ApiClient>().resetHeader();
      emit(state.copyWith(isLoading: false, isAuthenticated: true, driver: result.driver));
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _dataSource.userFacingError(error)));
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(isActionLoading: true, clearError: true));
    try {
      await _dataSource.logout();
    } catch (_) {
      // Logout should clear the local session even if the network request fails.
    }
    await _clearSession();
    emit(const DriverAppState(isAuthenticated: false));
  }

  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final snapshot = await _loadDashboardUseCase();
      final dashboardSummary = await _loadOptionalDashboardSummary();
      emit(state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        driver: snapshot.driver,
        currentOffer: snapshot.currentOffer,
        clearOffer: snapshot.currentOffer == null,
        currentOrder: snapshot.currentOrder,
        clearOrder: snapshot.currentOrder == null,
        financialSummary: snapshot.financialSummary,
        dashboardSummary: dashboardSummary,
        clearDashboardSummary: dashboardSummary == null,
      ));
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _dataSource.userFacingError(error)));
    }
  }

  Future<void> updateAvailability(String availabilityStatus) async {
    emit(state.copyWith(isActionLoading: true, clearError: true));
    try {
      final driver = await _updateAvailabilityUseCase(availabilityStatus);
      emit(state.copyWith(isActionLoading: false, driver: driver));
    } catch (error) {
      emit(state.copyWith(isActionLoading: false, errorMessage: _dataSource.userFacingError(error)));
    }
  }

  Future<void> postLocation({required double latitude, required double longitude, double? accuracy, double? speed, double? heading}) async {
    try {
      await _dataSource.postLocation(latitude: latitude, longitude: longitude, accuracy: accuracy, speed: speed, heading: heading);
    } catch (error) {
      emit(state.copyWith(errorMessage: _dataSource.userFacingError(error)));
    }
  }

  Future<void> acceptOffer(DeliveryAssignmentAttemptModel offer) async {
    if (offer.isExpired) {
      emit(state.copyWith(errorMessage: 'انتهت صلاحية العرض، يرجى التحديث'));
      await loadDashboard();
      return;
    }
    emit(state.copyWith(isActionLoading: true, clearError: true));
    try {
      final order = await _respondToOfferUseCase.accept(offer.id);
      emit(state.copyWith(isActionLoading: false, currentOrder: order, clearOffer: true));
    } catch (error) {
      emit(state.copyWith(isActionLoading: false, errorMessage: _dataSource.userFacingError(error)));
      await loadDashboard();
    }
  }

  Future<void> rejectOffer(DeliveryAssignmentAttemptModel offer, String reason) async {
    if (reason.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'اكتب سبب رفض الطلب'));
      return;
    }
    emit(state.copyWith(isActionLoading: true, clearError: true));
    try {
      await _respondToOfferUseCase.reject(offer.id, reason.trim());
      emit(state.copyWith(isActionLoading: false, clearOffer: true));
    } catch (error) {
      emit(state.copyWith(isActionLoading: false, errorMessage: _dataSource.userFacingError(error)));
      await loadDashboard();
    }
  }

  Future<void> performOrderAction(DeliveryOrderModel order) async {
    if (!order.hasLifecycleAction) return;
    emit(state.copyWith(isActionLoading: true, clearError: true));
    try {
      final updatedOrder = await _orderLifecycleUseCase(order);
      emit(state.copyWith(isActionLoading: false, currentOrder: updatedOrder));
      await loadDashboard();
    } catch (error) {
      emit(state.copyWith(isActionLoading: false, errorMessage: _dataSource.userFacingError(error)));
    }
  }

  Future<void> loadNotifications({bool? unreadOnly}) async {
    final filter = unreadOnly ?? state.unreadOnly;
    emit(state.copyWith(isLoading: true, unreadOnly: filter, clearError: true));
    try {
      final notifications = await _dataSource.getNotifications(unreadOnly: filter);
      emit(state.copyWith(isLoading: false, notifications: notifications));
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _dataSource.userFacingError(error)));
    }
  }

  Future<void> markNotificationRead(UserNotificationModel notification) async {
    emit(state.copyWith(notifications: state.notifications.map((item) => item.id == notification.id ? item.markRead() : item).toList()));
    try {
      await _dataSource.markNotificationRead(notification.id);
    } catch (error) {
      emit(state.copyWith(errorMessage: _dataSource.userFacingError(error)));
      await loadNotifications();
    }
  }

  Future<void> loadDisputes() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final disputes = await _dataSource.getDisputes();
      emit(state.copyWith(isLoading: false, disputes: disputes));
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _dataSource.userFacingError(error)));
    }
  }

  void changeTab(int index) {
    emit(state.copyWith(currentTab: index, clearError: true));
    if (index == 0) loadDashboard();
    if (index == 2) loadNotifications();
    if (index == 3) loadDisputes();
  }

  Future<DeliveryDashboardSummaryModel?> _loadOptionalDashboardSummary() async {
    try {
      return await _dashboardSummaryUseCase();
    } catch (error) {
      if (_dataSource.isUnauthorized(error)) await _clearSession();
      return null;
    }
  }

  Future<void> _clearSession() async {
    final preferences = getIt<SharedPreferences>();
    await preferences.remove(PrefsKeys.token);
    await preferences.remove(PrefsKeys.userInfo);
    getIt<ApiClient>().resetHeader();
  }
}
