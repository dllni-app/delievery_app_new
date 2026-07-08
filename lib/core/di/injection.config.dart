// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../common/design/src/theme/theme/theme_notifier.dart' as _i291;
import '../../features/auth/data/data_sources/auth_remote_data.dart' as _i653;
import '../../features/auth/data/repositories/auth_repositories_imp.dart'
    as _i855;
import '../../features/auth/domain/repositories/auth_repositories.dart'
    as _i962;
import '../../features/auth/domain/use_cases/log_out_use_case.dart' as _i446;
import '../../features/auth/domain/use_cases/login_use_case.dart' as _i1038;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/delivery/data/data_sources/delivery_remote_data.dart'
    as _i183;
import '../../features/delivery/data/repositories/delivery_repositories_imp.dart'
    as _i299;
import '../../features/delivery/domain/repositories/delivery_repositories.dart'
    as _i234;
import '../../features/delivery/domain/use_cases/accept_offer_use_case.dart'
    as _i12;
import '../../features/delivery/domain/use_cases/get_current_offer_use_case.dart'
    as _i978;
import '../../features/delivery/domain/use_cases/get_current_order_use_case.dart'
    as _i394;
import '../../features/delivery/domain/use_cases/get_disputes_use_case.dart'
    as _i594;
import '../../features/delivery/domain/use_cases/load_delivery_dashboard_use_case.dart'
    as _i900;
import '../../features/delivery/domain/use_cases/perform_order_action_use_case.dart'
    as _i340;
import '../../features/delivery/domain/use_cases/reject_offer_use_case.dart'
    as _i852;
import '../../features/delivery/presentation/cubit/delivery_cubit.dart'
    as _i348;
import '../../features/financial/data/data_sources/financial_remote_data.dart'
    as _i693;
import '../../features/financial/data/repositories/financial_repositories_imp.dart'
    as _i833;
import '../../features/financial/domain/repositories/financial_repositories.dart'
    as _i1008;
import '../../features/financial/domain/use_cases/get_financial_summary_use_case.dart'
    as _i309;
import '../../features/financial/presentation/cubit/financial_cubit.dart'
    as _i758;
import '../../features/home/presentation/cubit/home_cubit.dart' as _i9;
import '../../features/notification/data/data_sources/notification_remote_data.dart'
    as _i71;
import '../../features/notification/data/repositories/notification_repositories_imp.dart'
    as _i212;
import '../../features/notification/domain/repositories/notification_repositories.dart'
    as _i530;
import '../../features/notification/domain/use_cases/get_all_notification_use_case.dart'
    as _i687;
import '../../features/notification/domain/use_cases/mark_notification_read_use_case.dart'
    as _i635;
import '../../features/notification/presentation/bloc/notification_bloc.dart'
    as _i29;
import '../../features/splash/data/data_sources/version_remote_data.dart'
    as _i328;
import '../../features/splash/data/repositories/version_repositories_imp.dart'
    as _i837;
import '../../features/splash/domain/repositories/version_repositories.dart'
    as _i16;
import '../../features/splash/domain/use_cases/get_version_use_case.dart'
    as _i1023;
import '../../features/splash/page/cubit/splash_cubit.dart' as _i547;
import '../../features/user/data/data_sources/user_remote_data.dart' as _i15;
import '../../features/user/data/repositories/user_repositories_imp.dart'
    as _i990;
import '../../features/user/domain/repositories/user_repositories.dart' as _i91;
import '../../features/user/domain/use_cases/driver_get_me_use_cases.dart'
    as _i243;
import '../../features/user/domain/use_cases/post_location_use_cases.dart'
    as _i1014;
import '../../features/user/domain/use_cases/update_availability_use_cases.dart'
    as _i933;
import '../../features/user/domain/use_cases/user_delete_me_use_cases.dart'
    as _i657;
import '../../features/user/domain/use_cases/user_get_me_use_cases.dart'
    as _i827;
import '../../features/user/domain/use_cases/user_update_me_use_cases.dart'
    as _i584;
import '../../features/user/domain/use_cases/user_update_profile_use_cases.dart'
    as _i743;
import '../../features/user/presentation/bloc/user_bloc.dart' as _i747;
import '../permissions/cubit/permissions_cubit.dart' as _i463;
import '../permissions/permission_service.dart' as _i271;
import '../unified_api/dio/api_client.dart' as _i357;
import '../unified_api/dio/logger_interceptor.dart' as _i614;
import 'injection.dart' as _i464;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final injectableModule = _$InjectableModule();
  gh.singleton<_i361.Dio>(() => injectableModule.dio);
  gh.lazySingleton<_i291.AppThemeNotifier>(() => _i291.AppThemeNotifier());
  gh.lazySingleton<_i271.PermissionManager>(() => _i271.PermissionManager());
  gh.lazySingleton<_i614.LoggerInterceptor>(() => _i614.LoggerInterceptor());
  gh.lazySingleton<_i9.HomeCubit>(() => _i9.HomeCubit());
  gh.lazySingleton<_i357.ApiClient>(
    () => _i357.ApiClient(
      gh<_i361.Dio>(),
      loggingInterceptor: gh<_i614.LoggerInterceptor>(),
    ),
  );
  gh.factory<_i463.PermissionCubit>(
    () => _i463.PermissionCubit(gh<_i271.PermissionManager>()),
  );
  gh.lazySingleton<_i653.AuthRemoteData>(
    () => _i653.AuthRemoteData(apiClient: gh<_i357.ApiClient>()),
  );
  gh.lazySingleton<_i183.DeliveryRemoteData>(
    () => _i183.DeliveryRemoteData(apiClient: gh<_i357.ApiClient>()),
  );
  gh.lazySingleton<_i693.FinancialRemoteData>(
    () => _i693.FinancialRemoteData(apiClient: gh<_i357.ApiClient>()),
  );
  gh.lazySingleton<_i71.NotificationRemoteData>(
    () => _i71.NotificationRemoteData(apiClient: gh<_i357.ApiClient>()),
  );
  gh.lazySingleton<_i328.VersionRemoteData>(
    () => _i328.VersionRemoteData(apiClient: gh<_i357.ApiClient>()),
  );
  gh.lazySingleton<_i15.UserRemoteData>(
    () => _i15.UserRemoteData(apiClient: gh<_i357.ApiClient>()),
  );
  gh.lazySingleton<_i1008.FinancialRepositories>(
    () => _i833.FinancialRepositoriesImp(
      remoteData: gh<_i693.FinancialRemoteData>(),
    ),
  );
  gh.lazySingleton<_i234.DeliveryRepositories>(
    () => _i299.DeliveryRepositoriesImp(
      remoteData: gh<_i183.DeliveryRemoteData>(),
    ),
  );
  gh.lazySingleton<_i962.AuthRepositories>(
    () => _i855.AuthRepositoriesImp(remoteData: gh<_i653.AuthRemoteData>()),
  );
  gh.lazySingleton<_i16.VersionRepositories>(
    () =>
        _i837.VersionRepositoriesImp(remoteData: gh<_i328.VersionRemoteData>()),
  );
  gh.lazySingleton<_i12.AcceptOfferUseCase>(
    () =>
        _i12.AcceptOfferUseCase(repositories: gh<_i234.DeliveryRepositories>()),
  );
  gh.lazySingleton<_i978.GetCurrentOfferUseCase>(
    () => _i978.GetCurrentOfferUseCase(
      repositories: gh<_i234.DeliveryRepositories>(),
    ),
  );
  gh.lazySingleton<_i394.GetCurrentOrderUseCase>(
    () => _i394.GetCurrentOrderUseCase(
      repositories: gh<_i234.DeliveryRepositories>(),
    ),
  );
  gh.lazySingleton<_i594.GetDisputesUseCase>(
    () => _i594.GetDisputesUseCase(
      repositories: gh<_i234.DeliveryRepositories>(),
    ),
  );
  gh.lazySingleton<_i900.LoadDeliveryDashboardUseCase>(
    () => _i900.LoadDeliveryDashboardUseCase(
      repositories: gh<_i234.DeliveryRepositories>(),
    ),
  );
  gh.lazySingleton<_i340.PerformOrderActionUseCase>(
    () => _i340.PerformOrderActionUseCase(
      repositories: gh<_i234.DeliveryRepositories>(),
    ),
  );
  gh.lazySingleton<_i852.RejectOfferUseCase>(
    () => _i852.RejectOfferUseCase(
      repositories: gh<_i234.DeliveryRepositories>(),
    ),
  );
  gh.lazySingleton<_i348.DeliveryCubit>(
    () => _i348.DeliveryCubit(
      gh<_i900.LoadDeliveryDashboardUseCase>(),
      gh<_i12.AcceptOfferUseCase>(),
      gh<_i852.RejectOfferUseCase>(),
      gh<_i340.PerformOrderActionUseCase>(),
      gh<_i594.GetDisputesUseCase>(),
    ),
  );
  gh.lazySingleton<_i446.LogOutUseCase>(
    () => _i446.LogOutUseCase(authRepositories: gh<_i962.AuthRepositories>()),
  );
  gh.lazySingleton<_i1038.LoginUseCase>(
    () => _i1038.LoginUseCase(authRepositories: gh<_i962.AuthRepositories>()),
  );
  gh.lazySingleton<_i91.UserRepositories>(
    () => _i990.UserRepositoriesImp(remoteData: gh<_i15.UserRemoteData>()),
  );
  gh.lazySingleton<_i1023.GetVersionUseCase>(
    () => _i1023.GetVersionUseCase(
      authRepositories: gh<_i16.VersionRepositories>(),
    ),
  );
  gh.lazySingleton<_i243.DriverGetMeUseCases>(
    () => _i243.DriverGetMeUseCases(repositories: gh<_i91.UserRepositories>()),
  );
  gh.lazySingleton<_i1014.PostLocationUseCases>(
    () =>
        _i1014.PostLocationUseCases(repositories: gh<_i91.UserRepositories>()),
  );
  gh.lazySingleton<_i933.UpdateAvailabilityUseCases>(
    () => _i933.UpdateAvailabilityUseCases(
      repositories: gh<_i91.UserRepositories>(),
    ),
  );
  gh.lazySingleton<_i657.UserDeleteMeUseCases>(
    () => _i657.UserDeleteMeUseCases(repositories: gh<_i91.UserRepositories>()),
  );
  gh.lazySingleton<_i827.UserGetMeUseCases>(
    () => _i827.UserGetMeUseCases(repositories: gh<_i91.UserRepositories>()),
  );
  gh.lazySingleton<_i584.UserUpdateMeUseCases>(
    () => _i584.UserUpdateMeUseCases(repositories: gh<_i91.UserRepositories>()),
  );
  gh.lazySingleton<_i743.UserUpdateProfileImageUseCases>(
    () => _i743.UserUpdateProfileImageUseCases(
      repositories: gh<_i91.UserRepositories>(),
    ),
  );
  gh.lazySingleton<_i309.GetFinancialSummaryUseCase>(
    () => _i309.GetFinancialSummaryUseCase(
      repositories: gh<_i1008.FinancialRepositories>(),
    ),
  );
  gh.lazySingleton<_i530.NotificationRepositories>(
    () => _i212.NotificationRepositoriesImp(
      remoteData: gh<_i71.NotificationRemoteData>(),
    ),
  );
  gh.lazySingleton<_i687.GetAllNotificationUseCase>(
    () => _i687.GetAllNotificationUseCase(
      repositories: gh<_i530.NotificationRepositories>(),
    ),
  );
  gh.lazySingleton<_i635.MarkNotificationReadUseCase>(
    () => _i635.MarkNotificationReadUseCase(
      repositories: gh<_i530.NotificationRepositories>(),
    ),
  );
  gh.factory<_i747.UserBloc>(
    () => _i747.UserBloc(
      gh<_i657.UserDeleteMeUseCases>(),
      gh<_i827.UserGetMeUseCases>(),
      gh<_i243.DriverGetMeUseCases>(),
      gh<_i933.UpdateAvailabilityUseCases>(),
      gh<_i1014.PostLocationUseCases>(),
      gh<_i743.UserUpdateProfileImageUseCases>(),
      gh<_i584.UserUpdateMeUseCases>(),
    ),
  );
  gh.factory<_i797.AuthBloc>(
    () => _i797.AuthBloc(gh<_i1038.LoginUseCase>(), gh<_i446.LogOutUseCase>()),
  );
  gh.lazySingleton<_i29.NotificationBloc>(
    () => _i29.NotificationBloc(
      gh<_i687.GetAllNotificationUseCase>(),
      gh<_i635.MarkNotificationReadUseCase>(),
    ),
  );
  gh.lazySingleton<_i758.FinancialCubit>(
    () => _i758.FinancialCubit(gh<_i309.GetFinancialSummaryUseCase>()),
  );
  gh.factory<_i547.SplashCubit>(
    () => _i547.SplashCubit(gh<_i1023.GetVersionUseCase>()),
  );
  return getIt;
}

class _$InjectableModule extends _i464.InjectableModule {}
