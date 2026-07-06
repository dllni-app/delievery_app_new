class NotificationModel {
  final String? id;
  final String? readAt;
  final String? createdAt;
  final ItemData? data;

  NotificationModel({
    this.id,
    this.readAt,
    this.createdAt,
    this.data,
  });

  NotificationModel copyWith({
    String? id,
    String? readAt,
    String? createdAt,
    ItemData? data,
  }) =>
      NotificationModel(
        id: id ?? this.id,
        readAt: readAt ?? this.readAt,
        createdAt: createdAt ?? this.createdAt,
        data: data ?? this.data,
      );

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json["id"],
    readAt: json["read_at"],
    createdAt: json["created_at"],
    data: json["data"] == null ? null : ItemData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "read_at": readAt,
    "created_at": createdAt,
    "data": data?.toJson(),
  };
}

class ItemData {
  final String? title;
  final String? body;
  final String? type;
  final Map<String, dynamic>? args;

  ItemData({
    this.title,
    this.body,
    this.type,
    this.args,
  });

  ItemData copyWith({
    String? title,
    String? body,
    String? type,
    Map<String, dynamic>? args,
  }) =>
      ItemData(
        title: title ?? this.title,
        body: body ?? this.body,
        type: type ?? this.type,
        args: args ?? this.args,
      );

  factory ItemData.fromJson(Map<String, dynamic> json) => ItemData(
    title: json["title"],
    body: json["body"],
    type: json["type"],
    args: json["args"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "body": body,
    "type": type,
  };
}

