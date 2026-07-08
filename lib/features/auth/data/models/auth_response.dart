
import '../../../../common/models/user_model.dart';

AuthResponse authResponseFromJson( str) => AuthResponse.fromJson(str);


class AuthResponse {
  final Data? data;
  final String? token;

  AuthResponse({
    this.data,
    this.token,
  });

  AuthResponse copyWith({
    Data? data,
    String? token,
  }) =>
      AuthResponse(
        data: data ?? this.data,
        token: token ?? this.token,
      );

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "token": token,
  };
}

class Data {
  final UserModel? user;

  Data({
    this.user,
  });

  Data copyWith({
    UserModel? user,
  }) =>
      Data(
        user: user ?? this.user,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: json["driver"] == null ? null : UserModel.fromJson(json["driver"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
  };
}

