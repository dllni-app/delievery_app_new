class DriverProfileModel {
  final int id;
  final int userId;
  final int companyId;
  final String firstName;
  final String phone;
  final String vehicleType;
  final String plateNumber;
  final String availabilityStatus;
  final bool isActive;
  final bool isSuspended;
  final num trustScore;
  final int openDisputesCount;
  final DateTime? lastSeenAt;
  final DateTime? createdAt;

  DriverProfileModel({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.firstName,
    required this.phone,
    required this.vehicleType,
    required this.plateNumber,
    required this.availabilityStatus,
    required this.isActive,
    required this.isSuspended,
    required this.trustScore,
    required this.openDisputesCount,
    this.lastSeenAt,
    this.createdAt,
  });

  DriverProfileModel copyWith({
    int? id,
    int? userId,
    int? companyId,
    String? firstName,
    String? phone,
    String? vehicleType,
    String? plateNumber,
    String? availabilityStatus,
    bool? isActive,
    bool? isSuspended,
    num? trustScore,
    int? openDisputesCount,
    DateTime? lastSeenAt,
    DateTime? createdAt,
  }) =>
      DriverProfileModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        companyId: companyId ?? this.companyId,
        firstName: firstName ?? this.firstName,
        phone: phone ?? this.phone,
        vehicleType: vehicleType ?? this.vehicleType,
        plateNumber: plateNumber ?? this.plateNumber,
        availabilityStatus: availabilityStatus ?? this.availabilityStatus,
        isActive: isActive ?? this.isActive,
        isSuspended: isSuspended ?? this.isSuspended,
        trustScore: trustScore ?? this.trustScore,
        openDisputesCount: openDisputesCount ?? this.openDisputesCount,
        lastSeenAt: lastSeenAt ?? this.lastSeenAt,
        createdAt: createdAt ?? this.createdAt,
      );

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) =>
      DriverProfileModel(
        id: _asInt(json['id']),
        userId: _asInt(json['userId'] ?? json['user_id']),
        companyId: _asInt(json['companyId'] ?? json['company_id']),
        firstName: _asString(json['firstName'] ?? json['first_name']),
        phone: _asString(json['phone']),
        vehicleType: _asString(json['vehicleType'] ?? json['vehicle_type']),
        plateNumber: _asString(json['plateNumber'] ?? json['plate_number']),
        availabilityStatus: _asString(
          json['availabilityStatus'] ?? json['availability_status'],
          fallback: 'offline',
        ),
        isActive: _asBool(json['isActive'] ?? json['is_active']),
        isSuspended: _asBool(json['isSuspended'] ?? json['is_suspended']),
        trustScore: _asNum(json['trustScore'] ?? json['trust_score'], fallback: 0),
        openDisputesCount: _asInt(
          json['openDisputesCount'] ?? json['open_disputes_count'],
        ),
        lastSeenAt: _asDate(json['lastSeenAt'] ?? json['last_seen_at']),
        createdAt: _asDate(json['createdAt'] ?? json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'companyId': companyId,
        'firstName': firstName,
        'phone': phone,
        'vehicleType': vehicleType,
        'plateNumber': plateNumber,
        'availabilityStatus': availabilityStatus,
        'isActive': isActive,
        'isSuspended': isSuspended,
        'trustScore': trustScore,
        'openDisputesCount': openDisputesCount,
        'lastSeenAt': lastSeenAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
      };
}

String _asString(Object? value, {String fallback = ''}) =>
    value == null ? fallback : value.toString();

int _asInt(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;

num _asNum(Object? value, {num fallback = 0}) =>
    num.tryParse(value?.toString() ?? '') ?? fallback;

bool _asBool(Object? value) =>
    value == true ||
    value?.toString() == '1' ||
    value?.toString().toLowerCase() == 'true';

DateTime? _asDate(Object? value) =>
    value == null ? null : DateTime.tryParse(value.toString());
