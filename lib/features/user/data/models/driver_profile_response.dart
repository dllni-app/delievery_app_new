import 'driver_profile_model.dart';

DriverProfileResponse driverProfileResponseFromJson(str) =>
    DriverProfileResponse.fromJson(str);

DriverProfileResponse driverProfileResponseFromJsonMap(
  Map<String, dynamic> json,
) =>
    DriverProfileResponse.fromJson(json);

class DriverProfileResponse {
  final DriverProfileModel? data;

  DriverProfileResponse({this.data});

  DriverProfileResponse copyWith({DriverProfileModel? data}) =>
      DriverProfileResponse(data: data ?? this.data);

  factory DriverProfileResponse.fromJson(Map<String, dynamic> json) =>
      DriverProfileResponse(
        data: json['data'] == null
            ? null
            : DriverProfileModel.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {'data': data?.toJson()};
}
