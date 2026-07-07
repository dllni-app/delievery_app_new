import 'package:dio/dio.dart';

import '../../../../common/helper/src/app_varibles.dart';
import '../../../../common/helper/src/typedef.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/use_case/use_case.dart';
import '../../data/models/auth_response.dart';
import '../repositories/auth_repositories.dart';

@lazySingleton
class LoginUseCase implements UseCase<AuthResponse, LoginParams> {
  final AuthRepositories _authRepositories;

  LoginUseCase({required AuthRepositories authRepositories})
    : _authRepositories = authRepositories;

  @override
  DataResponse<AuthResponse> call(LoginParams params) async =>
      await _authRepositories.logIn(params.getBody());
}

class LoginParams with Params {
  final String phone;
  final String password;

  LoginParams({required this.phone, required this.password});

  @override
  BodyMap getBody() {
    return {
      "phone": phone,
      "password": password,
      "fcmToken": AppVariables.fcmToken,
    }..removeWhere((key, value) => value == null);
  }
}
