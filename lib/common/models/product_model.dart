
class ProductModel {
  final Tracking? tracking;
  final Summary? summary;
  final List<EventModel>? events;
  final List<ItemModel>? items;

  ProductModel({
    this.tracking,
    this.summary,
    this.events,
    this.items,
  });

  ProductModel copyWith({
    Tracking? tracking,
    Summary? summary,
    List<EventModel>? events,
    List<ItemModel>? items,
  }) =>
      ProductModel(
        tracking: tracking ?? this.tracking,
        summary: summary ?? this.summary,
        events: events ?? this.events,
        items: items ?? this.items,
      );

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    tracking: json["tracking"] == null ? null : Tracking.fromJson(json["tracking"]),
    summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
    events: json["events"] == null ? [] : List<EventModel>.from(json["events"]!.map((x) => EventModel.fromJson(x))),
    items: json["items"] == null ? [] : List<ItemModel>.from(json["items"]!.map((x) => ItemModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "tracking": tracking?.toJson(),
    "summary": summary?.toJson(),
    "events": events == null ? [] : List<dynamic>.from(events!.map((x) => x.toJson())),
  };
}

class ItemModel {
  final String? name;
  final int? packagesCount;
  final double? weight;
  final String? description;

  ItemModel({
    this.name,
    this.packagesCount,
    this.weight,
    this.description,
  });

  ItemModel copyWith({
    String? name,
    int? packagesCount,
    double? weight,
    String? description,
  }) =>
      ItemModel(
        name: name ?? this.name,
        packagesCount: packagesCount ?? this.packagesCount,
        weight: weight ?? this.weight,
        description: description ?? this.description,
      );

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
    name: json["name"],
    packagesCount: json["packages_count"],
    weight: json["weight"]?.toDouble(),
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "packages_count": packagesCount,
    "weight": weight,
    "description": description,
  };
}



class EventModel {
  final Status? status;
  final String? location;
  final String? message;
  final DateTime? at;
  final bool? isCurrent;

  EventModel({
    this.status,
    this.location,
    this.message,
    this.at,
    this.isCurrent,
  });

  EventModel copyWith({
    Status? status,
    String? location,
    String? message,
    DateTime? at,
    bool? isCurrent,
  }) =>
      EventModel(
        status: status ?? this.status,
        location: location ?? this.location,
        message: message ?? this.message,
        at: at ?? this.at,
        isCurrent: isCurrent ?? this.isCurrent,
      );

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    status: json["status"] == null ? null : Status.fromJson(json["status"]),
    location: json["location"],
    message: json["message"],
    at: json["at"] == null ? null : DateTime.parse(json["at"]),
    isCurrent: json["is_current"],
  );

  Map<String, dynamic> toJson() => {
    "status": status?.toJson(),
    "location": location,
    "message": message,
    "at": at?.toIso8601String(),
    "is_current": isCurrent,
  };
}

class Status {
  final String? code;
  final String? label;
  final String? iconUrl;

  Status({
    this.code,
    this.label,
    this.iconUrl,
  });

  Status copyWith({
    String? code,
    String? label,
    String? iconUrl,
  }) =>
      Status(
        code: code ?? this.code,
        label: label ?? this.label,
        iconUrl: iconUrl ?? this.iconUrl,
      );

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    code: json["code"],
    label: json["label"],
    iconUrl: json["icon_url"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "label": label,
    "icon_url": iconUrl,
  };
}

class Summary {
  final Status? status;
  final String? currentLocation;
  final int? packagesCount;
  final String? estimatedDeliveryDate;
  final DateTime? lastUpdateAt;

  Summary({
    this.status,
    this.currentLocation,
    this.packagesCount,
    this.estimatedDeliveryDate,
    this.lastUpdateAt,
  });

  Summary copyWith({
    Status? status,
    String? currentLocation,
    int? packagesCount,
    String? estimatedDeliveryDate,
    DateTime? lastUpdateAt,
  }) =>
      Summary(
        status: status ?? this.status,
        currentLocation: currentLocation ?? this.currentLocation,
        packagesCount: packagesCount ?? this.packagesCount,
        estimatedDeliveryDate: estimatedDeliveryDate ?? this.estimatedDeliveryDate,
        lastUpdateAt: lastUpdateAt ?? this.lastUpdateAt,
      );

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    status: json["status"] == null ? null : Status.fromJson(json["status"]),
    currentLocation: json["current_location"],
    packagesCount: json["packages_count"],
    estimatedDeliveryDate: json["estimated_delivery_date"] ,
    lastUpdateAt: json["last_update_at"] == null ? null : DateTime.parse(json["last_update_at"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status?.toJson(),
    "current_location": currentLocation,
    "packages_count": packagesCount,
   // "estimated_delivery_date": "${estimatedDeliveryDate!.year.toString().padLeft(4, '0')}-${estimatedDeliveryDate!.month.toString().padLeft(2, '0')}-${estimatedDeliveryDate!.day.toString().padLeft(2, '0')}",
    "last_update_at": lastUpdateAt?.toIso8601String(),
  };
}

class Tracking {
  final String? mode;
  final String? trackingNumber;
  final String? shipmentNumber;

  Tracking({
    this.mode,
    this.trackingNumber,
    this.shipmentNumber,
  });

  Tracking copyWith({
    String? mode,
    String? trackingNumber,
    String? shipmentNumber,
  }) =>
      Tracking(
        mode: mode ?? this.mode,
        trackingNumber: trackingNumber ?? this.trackingNumber,
        shipmentNumber: shipmentNumber ?? this.shipmentNumber,
      );

  factory Tracking.fromJson(Map<String, dynamic> json) => Tracking(
    mode: json["mode"],
    trackingNumber: json["tracking_number"],
    shipmentNumber: json["shipment_number"],
  );

  Map<String, dynamic> toJson() => {
    "mode": mode,
    "tracking_number": trackingNumber,
    "shipment_number": shipmentNumber,
  };
}