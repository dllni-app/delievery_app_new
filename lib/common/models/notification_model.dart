class NotificationModel {
  final String? id;
  final String? module;
  final String? icon;
  final String? type;
  final String? canonicalType;
  final String? datumCanonicalType;
  final String? category;
  final String? priority;
  final String? title;
  final String? body;
  final String? message;
  final Data? data;
  final DateTime? readAt;
  final DateTime? datumReadAt;
  final DateTime? createdAt;
  final DateTime? datumCreatedAt;

  NotificationModel({
    this.id,
    this.module,
    this.icon,
    this.type,
    this.canonicalType,
    this.datumCanonicalType,
    this.category,
    this.priority,
    this.title,
    this.body,
    this.message,
    this.data,
    this.readAt,
    this.datumReadAt,
    this.createdAt,
    this.datumCreatedAt,
  });

  NotificationModel copyWith({
    String? id,
    String? module,
    String? icon,
    String? type,
    String? canonicalType,
    String? datumCanonicalType,
    String? category,
    String? priority,
    String? title,
    String? body,
    String? message,
    Data? data,
    DateTime? readAt,
    DateTime? datumReadAt,
    DateTime? createdAt,
    DateTime? datumCreatedAt,
  }) =>
      NotificationModel(
        id: id ?? this.id,
        module: module ?? this.module,
        icon: icon ?? this.icon,
        type: type ?? this.type,
        canonicalType: canonicalType ?? this.canonicalType,
        datumCanonicalType: datumCanonicalType ?? this.datumCanonicalType,
        category: category ?? this.category,
        priority: priority ?? this.priority,
        title: title ?? this.title,
        body: body ?? this.body,
        message: message ?? this.message,
        data: data ?? this.data,
        readAt: readAt ?? this.readAt,
        datumReadAt: datumReadAt ?? this.datumReadAt,
        createdAt: createdAt ?? this.createdAt,
        datumCreatedAt: datumCreatedAt ?? this.datumCreatedAt,
      );

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json["id"],
    module: json["module"],
    icon: json["icon"],
    type: json["type"],
    canonicalType: json["canonicalType"],
    datumCanonicalType: json["canonical_type"],
    category: json["category"],
    priority: json["priority"],
    title: json["title"],
    body: json["body"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    readAt: json["readAt"] == null ? null : DateTime.parse(json["readAt"]),
    datumReadAt: json["read_at"] == null ? null : DateTime.parse(json["read_at"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    datumCreatedAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "module": module,
    "icon": icon,
    "type": type,
    "canonicalType": canonicalType,
    "canonical_type": datumCanonicalType,
    "category": category,
    "priority": priority,
    "title": title,
    "body": body,
    "message": message,
    "data": data?.toJson(),
    "readAt": readAt?.toIso8601String(),
    "read_at": datumReadAt?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "created_at": datumCreatedAt?.toIso8601String(),
  };
}

class Data {
  final int? orderId;
  final String? orderNumber;
  final String? deepLinkTarget;
  final String? dataDeepLinkTarget;
  final String? args;
  final int? driverId;

  Data({
    this.orderId,
    this.orderNumber,
    this.deepLinkTarget,
    this.dataDeepLinkTarget,
    this.args,
    this.driverId,
  });

  Data copyWith({
    int? orderId,
    String? orderNumber,
    String? deepLinkTarget,
    String? dataDeepLinkTarget,
    String? args,
    int? driverId,
  }) =>
      Data(
        orderId: orderId ?? this.orderId,
        orderNumber: orderNumber ?? this.orderNumber,
        deepLinkTarget: deepLinkTarget ?? this.deepLinkTarget,
        dataDeepLinkTarget: dataDeepLinkTarget ?? this.dataDeepLinkTarget,
        args: args ?? this.args,
        driverId: driverId ?? this.driverId,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    orderId: json["orderId"],
    orderNumber: json["orderNumber"],
    deepLinkTarget: json["deepLinkTarget"],
    dataDeepLinkTarget: json["deep_link_target"],
    args: json["args"],
    driverId: json["driverId"],
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "orderNumber": orderNumber,
    "deepLinkTarget": deepLinkTarget,
    "deep_link_target": dataDeepLinkTarget,
    "args": args,
    "driverId": driverId,
  };
}