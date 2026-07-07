import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../../common/helper/src/app_varibles.dart';
import '../../../../common/helper/src/data_state_model.dart';
import '../../../../common/helper/src/helper_func.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/unified_api/dio/api_client.dart';
import '../../../../core/use_case/use_case.dart';
import '../../data/models/auth_response.dart';
import '../../data/models/log_out_response.dart';
import 'package:injectable/injectable.dart';
import '../../domain/use_cases/log_out_use_case.dart';
import '../../domain/use_cases/login_use_case.dart';

part 'auth_event.dart';

part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogOutUseCase _logOutUseCase;

  AuthBloc(
    this._loginUseCase,
    this._logOutUseCase,
  ) : super(AuthState()) {
    on<LoginEvent>(_login);
    on<LogOutEvent>(_logOut);
  }

  FutureOr<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loginData: state.loginData.setLoading()));

    final val = await _loginUseCase(event.params);

    val.fold(
      (l) {
        emit(
          state.copyWith(
            loginData: state.loginData.setFaild(errorMessage: l.message),
          ),
        );
      },
      (r) {
        emit(state.copyWith(loginData: state.loginData.setSuccess(data: r)));
        AppVariables.token = r.data!.accessToken;
        AppVariables.user = r.data!.user!;
        getIt<ApiClient>().resetHeader();

      },
    );
    if (emit.isDone) return;

    emit(state.copyWith( loginData: state.loginData.resetData()));
  }

  FutureOr<void> _logOut(LogOutEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(logOutData: state.logOutData.setLoading()));

    final val = await _logOutUseCase(NoParams());

    val.fold(
      (l) {
        emit(
          state.copyWith(
            logOutData: state.logOutData.setFaild(errorMessage: l.message),
          ),
        );
      },
      (r) {
        emit(state.copyWith(logOutData: state.logOutData.setSuccess()));
        HelperFunc.logout();
      },
    );
    if (emit.isDone) return;

    emit(state.copyWith( logOutData: state.logOutData.resetData()));
  }




}
