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
import '../../features/home/presentation/cubit/home_cubit.dart' as _i9;
import '../../features/notification/data/data_source/notification_remote_data.dart'
    as _i842;
import '../../features/notification/data/repositories/notification_repositories_imp.dart'
    as _i212;
import '../../features/notification/domin/repositories/notification_repositories.dart'
    as _i417;
import '../../features/notification/domin/use_cases/get_all_notification_use_case.dart'
    as _i412;
import '../../features/notification/domin/use_cases/post_mark_all_use_case.dart'
    as _i730;
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
  gh.lazySingleton<_i842.NotificationRemoteData>(
    () => _i842.NotificationRemoteData(apiClient: gh<_i357.ApiClient>()),
  );
  gh.lazySingleton<_i328.VersionRemoteData>(
    () => _i328.VersionRemoteData(apiClient: gh<_i357.ApiClient>()),
  );
  gh.lazySingleton<_i15.UserRemoteData>(
    () => _i15.UserRemoteData(apiClient: gh<_i357.ApiClient>()),
  );
  gh.lazySingleton<_i417.NotificationRepositories>(
    () => _i212.NotificationRepositoriesImp(
      remoteData: gh<_i842.NotificationRemoteData>(),
    ),
  );
  gh.lazySingleton<_i412.GetAllNotificationUseCase>(
    () => _i412.GetAllNotificationUseCase(
      repositories: gh<_i417.NotificationRepositories>(),
    ),
  );
  gh.lazySingleton<_i730.GetMarkUseCase>(
    () => _i730.GetMarkUseCase(
      repositories: gh<_i417.NotificationRepositories>(),
    ),
  );
  gh.lazySingleton<_i962.AuthRepositories>(
    () => _i855.AuthRepositoriesImp(remoteData: gh<_i653.AuthRemoteData>()),
  );
  gh.lazySingleton<_i16.VersionRepositories>(
    () =>
        _i837.VersionRepositoriesImp(remoteData: gh<_i328.VersionRemoteData>()),
  );
  gh.lazySingleton<_i446.LogOutUseCase>(
    () => _i446.LogOutUseCase(authRepositories: gh<_i962.AuthRepositories>()),
  );
  gh.lazySingleton<_i1038.LoginUseCase>(
    () => _i1038.LoginUseCase(authRepositories: gh<_i962.AuthRepositories>()),
  );
  gh.lazySingleton<_i29.NotificationBloc>(
    () => _i29.NotificationBloc(
      gh<_i412.GetAllNotificationUseCase>(),
      gh<_i730.GetMarkUseCase>(),
    ),
  );
  gh.lazySingleton<_i91.UserRepositories>(
    () => _i990.UserRepositoriesImp(remoteData: gh<_i15.UserRemoteData>()),
  );
  gh.lazySingleton<_i1023.GetVersionUseCase>(
    () => _i1023.GetVersionUseCase(
      authRepositories: gh<_i16.VersionRepositories>(),
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
  gh.factory<_i797.AuthBloc>(
    () => _i797.AuthBloc(gh<_i1038.LoginUseCase>(), gh<_i446.LogOutUseCase>()),
  );
  gh.factory<_i747.UserBloc>(
    () => _i747.UserBloc(
      gh<_i657.UserDeleteMeUseCases>(),
      gh<_i827.UserGetMeUseCases>(),
      gh<_i743.UserUpdateProfileImageUseCases>(),
      gh<_i584.UserUpdateMeUseCases>(),
    ),
  );
  gh.factory<_i547.SplashCubit>(
    () => _i547.SplashCubit(gh<_i1023.GetVersionUseCase>()),
  );
  return getIt;
}

class _$InjectableModule extends _i464.InjectableModule {}
