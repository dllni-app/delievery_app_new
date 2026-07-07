part of 'auth_bloc.dart';

class AuthState {
  final DataStateModel<AuthResponse?> loginData;
  final DataStateModel<LogOutResponse?> logOutData;


  AuthState({
    this.loginData = const DataStateModel.setDefultValue(defultValue: null),
    this.logOutData = const DataStateModel.setDefultValue(defultValue: null),

  });

  AuthState copyWith({
    DataStateModel<AuthResponse?>? loginData,
    final DataStateModel<LogOutResponse?>? logOutData,
  }) {
    return AuthState(
      loginData: loginData ?? this.loginData,
      logOutData: logOutData ?? this.logOutData,
    );
  }
}
