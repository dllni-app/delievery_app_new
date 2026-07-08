class UserModel {
  final int? id;
  final int? userId;
  final int? companyId;
  final String? firstName;
  final String? displayName;
  final String? phone;
  final String? vehicleType;
  final String? plateNumber;
  final String? availabilityStatus;
  final bool? isActive;
  final bool? isSuspended;
  final int? trustScore;
  final int? openDisputesCount;
  final DateTime? lastSeenAt;
  final dynamic latestLocation;
  final DateTime? createdAt;

  UserModel({
    this.id,
    this.userId,
    this.companyId,
    this.firstName,
    this.displayName,
    this.phone,
    this.vehicleType,
    this.plateNumber,
    this.availabilityStatus,
    this.isActive,
    this.isSuspended,
    this.trustScore,
    this.openDisputesCount,
    this.lastSeenAt,
    this.latestLocation,
    this.createdAt,
  });

  UserModel copyWith({
    int? id,
    int? userId,
    int? companyId,
    String? firstName,
    String? displayName,
    String? phone,
    String? vehicleType,
    String? plateNumber,
    String? availabilityStatus,
    bool? isActive,
    bool? isSuspended,
    int? trustScore,
    int? openDisputesCount,
    DateTime? lastSeenAt,
    dynamic latestLocation,
    DateTime? createdAt,
  }) =>
      UserModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        companyId: companyId ?? this.companyId,
        firstName: firstName ?? this.firstName,
        displayName: displayName ?? this.displayName,
        phone: phone ?? this.phone,
        vehicleType: vehicleType ?? this.vehicleType,
        plateNumber: plateNumber ?? this.plateNumber,
        availabilityStatus: availabilityStatus ?? this.availabilityStatus,
        isActive: isActive ?? this.isActive,
        isSuspended: isSuspended ?? this.isSuspended,
        trustScore: trustScore ?? this.trustScore,
        openDisputesCount: openDisputesCount ?? this.openDisputesCount,
        lastSeenAt: lastSeenAt ?? this.lastSeenAt,
        latestLocation: latestLocation ?? this.latestLocation,
        createdAt: createdAt ?? this.createdAt,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    userId: json["userId"],
    companyId: json["companyId"],
    firstName: json["firstName"],
    displayName: json["displayName"],
    phone: json["phone"],
    vehicleType: json["vehicleType"],
    plateNumber: json["plateNumber"],
    availabilityStatus: json["availabilityStatus"],
    isActive: json["isActive"],
    isSuspended: json["isSuspended"],
    trustScore: json["trustScore"],
    openDisputesCount: json["openDisputesCount"],
    lastSeenAt: json["lastSeenAt"] == null ? null : DateTime.parse(json["lastSeenAt"]),
    latestLocation: json["latestLocation"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "companyId": companyId,
    "firstName": firstName,
    "displayName": displayName,
    "phone": phone,
    "vehicleType": vehicleType,
    "plateNumber": plateNumber,
    "availabilityStatus": availabilityStatus,
    "isActive": isActive,
    "isSuspended": isSuspended,
    "trustScore": trustScore,
    "openDisputesCount": openDisputesCount,
    "lastSeenAt": lastSeenAt?.toIso8601String(),
    "latestLocation": latestLocation,
    "createdAt": createdAt?.toIso8601String(),
  };
}
