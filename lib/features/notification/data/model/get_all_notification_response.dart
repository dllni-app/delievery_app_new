
import '../../../../common/models/notification_model.dart';

GetAllNotificationResponse getAllNotificationResponseFromJson(str) =>
    GetAllNotificationResponse.fromJson(str);

class GetAllNotificationResponse {
  final bool? success;
  final String? message;
  final GetAllNotificationResponseData? data;

  GetAllNotificationResponse({this.success, this.message, this.data});

  GetAllNotificationResponse copyWith({
    bool? success,
    String? message,
    GetAllNotificationResponseData? data,
  }) => GetAllNotificationResponse(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory GetAllNotificationResponse.fromJson(Map<String, dynamic> json) =>
      GetAllNotificationResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : GetAllNotificationResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class GetAllNotificationResponseData {
  final List<NotificationModel>? items;

  GetAllNotificationResponseData({this.items});

  GetAllNotificationResponseData copyWith({List<NotificationModel>? items}) =>
      GetAllNotificationResponseData(items: items ?? this.items);

  factory GetAllNotificationResponseData.fromJson(Map<String, dynamic> json) =>
      GetAllNotificationResponseData(
        items: json["items"] == null
            ? []
            : List<NotificationModel>.from(
                json["items"]!.map((x) => NotificationModel.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}
