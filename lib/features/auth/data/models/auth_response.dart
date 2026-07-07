


import '../../../../common/models/user_model.dart';

AuthResponse authResponseFromJson( str) => AuthResponse.fromJson(str);


class AuthResponse {
  final bool? success;
  final String? message;
  final Data? data;

  AuthResponse({
    this.success,
    this.message,
    this.data,
  });

  AuthResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      AuthResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final String? tokenType;
  final String? accessToken;
  final UserModel? user;

  Data({
    this.tokenType,
    this.accessToken,
    this.user,
  });

  Data copyWith({
    String? tokenType,
    String? accessToken,
    UserModel? user,
  }) =>
      Data(
        tokenType: tokenType ?? this.tokenType,
        accessToken: accessToken ?? this.accessToken,
        user: user ?? this.user,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    tokenType: json["token_type"],
    accessToken: json["access_token"],
    user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token_type": tokenType,
    "access_token": accessToken,
    "user": user?.toJson(),
  };
}

