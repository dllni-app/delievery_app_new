import 'package:equatable/equatable.dart';

class DriverModel extends Equatable {
  const DriverModel({
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

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: _asInt(json['id']),
      userId: _asInt(json['userId'] ?? json['user_id']),
      companyId: _asInt(json['companyId'] ?? json['company_id']),
      firstName: _asString(json['firstName'] ?? json['first_name']),
      phone: _asString(json['phone']),
      vehicleType: _asString(json['vehicleType'] ?? json['vehicle_type']),
      plateNumber: _asString(json['plateNumber'] ?? json['plate_number']),
      availabilityStatus: _asString(json['availabilityStatus'] ?? json['availability_status'], fallback: 'offline'),
      isActive: _asBool(json['isActive'] ?? json['is_active']),
      isSuspended: _asBool(json['isSuspended'] ?? json['is_suspended']),
      trustScore: _asNum(json['trustScore'] ?? json['trust_score'], fallback: 0),
      openDisputesCount: _asInt(json['openDisputesCount'] ?? json['open_disputes_count']),
      lastSeenAt: _asDate(json['lastSeenAt'] ?? json['last_seen_at']),
      createdAt: _asDate(json['createdAt'] ?? json['created_at']),
    );
  }

  DriverModel copyWith({String? availabilityStatus}) {
    return DriverModel(
      id: id,
      userId: userId,
      companyId: companyId,
      firstName: firstName,
      phone: phone,
      vehicleType: vehicleType,
      plateNumber: plateNumber,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      isActive: isActive,
      isSuspended: isSuspended,
      trustScore: trustScore,
      openDisputesCount: openDisputesCount,
      lastSeenAt: lastSeenAt,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, companyId, firstName, phone, vehicleType, plateNumber, availabilityStatus, isActive, isSuspended, trustScore, openDisputesCount, lastSeenAt, createdAt];
}

class DeliveryAssignmentAttemptModel extends Equatable {
  const DeliveryAssignmentAttemptModel({
    required this.id,
    required this.orderId,
    required this.driverId,
    required this.attemptNo,
    required this.status,
    required this.distanceToPickupKm,
    this.offeredAt,
    this.expiresAt,
    this.respondedAt,
    this.order,
  });

  final int id;
  final int orderId;
  final int driverId;
  final int attemptNo;
  final String status;
  final num distanceToPickupKm;
  final DateTime? offeredAt;
  final DateTime? expiresAt;
  final DateTime? respondedAt;
  final DeliveryOrderModel? order;

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  factory DeliveryAssignmentAttemptModel.fromJson(Map<String, dynamic> json) {
    return DeliveryAssignmentAttemptModel(
      id: _asInt(json['id']),
      orderId: _asInt(json['orderId'] ?? json['order_id']),
      driverId: _asInt(json['driverId'] ?? json['driver_id']),
      attemptNo: _asInt(json['attemptNo'] ?? json['attempt_no']),
      status: _asString(json['status']),
      distanceToPickupKm: _asNum(json['distanceToPickupKm'] ?? json['distance_to_pickup_km'], fallback: 0),
      offeredAt: _asDate(json['offeredAt'] ?? json['offered_at']),
      expiresAt: _asDate(json['expiresAt'] ?? json['expires_at']),
      respondedAt: _asDate(json['respondedAt'] ?? json['responded_at']),
      order: json['order'] is Map<String, dynamic> ? DeliveryOrderModel.fromJson(json['order'] as Map<String, dynamic>) : null,
    );
  }

  @override
  List<Object?> get props => [id, orderId, driverId, attemptNo, status, distanceToPickupKm, offeredAt, expiresAt, respondedAt, order];
}

class DeliveryOrderModel extends Equatable {
  const DeliveryOrderModel({
    required this.id,
    required this.orderNumber,
    required this.companyId,
    required this.driverId,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffAddress,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    required this.distanceKm,
    required this.deliveryFee,
    required this.currency,
    required this.events,
    this.acceptedAt,
    this.startedAt,
    this.pickedUpAt,
    this.deliveredAt,
    this.completedAt,
  });

  final int id;
  final String orderNumber;
  final int companyId;
  final int driverId;
  final String status;
  final String customerName;
  final String customerPhone;
  final String pickupAddress;
  final num pickupLatitude;
  final num pickupLongitude;
  final String dropoffAddress;
  final num dropoffLatitude;
  final num dropoffLongitude;
  final num distanceKm;
  final num deliveryFee;
  final String currency;
  final List<DeliveryOrderEventModel> events;
  final DateTime? acceptedAt;
  final DateTime? startedAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;
  final DateTime? completedAt;

  factory DeliveryOrderModel.fromJson(Map<String, dynamic> json) {
    final eventsJson = json['events'];
    return DeliveryOrderModel(
      id: _asInt(json['id']),
      orderNumber: _asString(json['orderNumber'] ?? json['order_number'], fallback: '#${json['id'] ?? ''}'),
      companyId: _asInt(json['companyId'] ?? json['company_id']),
      driverId: _asInt(json['driverId'] ?? json['driver_id']),
      status: _asString(json['status'], fallback: 'unknown'),
      customerName: _asString(json['customerName'] ?? json['customer_name']),
      customerPhone: _asString(json['customerPhone'] ?? json['customer_phone']),
      pickupAddress: _asString(json['pickupAddress'] ?? json['pickup_address']),
      pickupLatitude: _asNum(json['pickupLatitude'] ?? json['pickup_latitude'], fallback: 0),
      pickupLongitude: _asNum(json['pickupLongitude'] ?? json['pickup_longitude'], fallback: 0),
      dropoffAddress: _asString(json['dropoffAddress'] ?? json['dropoff_address']),
      dropoffLatitude: _asNum(json['dropoffLatitude'] ?? json['dropoff_latitude'], fallback: 0),
      dropoffLongitude: _asNum(json['dropoffLongitude'] ?? json['dropoff_longitude'], fallback: 0),
      distanceKm: _asNum(json['distanceKm'] ?? json['distance_km'], fallback: 0),
      deliveryFee: _asNum(json['deliveryFee'] ?? json['delivery_fee'], fallback: 0),
      currency: _asString(json['currency'], fallback: 'SYP'),
      acceptedAt: _asDate(json['acceptedAt'] ?? json['accepted_at']),
      startedAt: _asDate(json['startedAt'] ?? json['started_at']),
      pickedUpAt: _asDate(json['pickedUpAt'] ?? json['picked_up_at']),
      deliveredAt: _asDate(json['deliveredAt'] ?? json['delivered_at']),
      completedAt: _asDate(json['completedAt'] ?? json['completed_at']),
      events: eventsJson is List ? eventsJson.whereType<Map<String, dynamic>>().map(DeliveryOrderEventModel.fromJson).toList() : const [],
    );
  }

  String get nextActionLabel {
    switch (status) {
      case 'accepted':
      case 'offered':
        return 'بدء الطلب';
      case 'in_progress':
        return 'تأكيد الاستلام';
      case 'picked_up':
        return 'تأكيد التسليم';
      default:
        return '';
    }
  }

  bool get hasLifecycleAction => nextActionLabel.isNotEmpty;

  @override
  List<Object?> get props => [id, orderNumber, companyId, driverId, status, customerName, customerPhone, pickupAddress, pickupLatitude, pickupLongitude, dropoffAddress, dropoffLatitude, dropoffLongitude, distanceKm, deliveryFee, currency, events, acceptedAt, startedAt, pickedUpAt, deliveredAt, completedAt];
}

class DeliveryOrderEventModel extends Equatable {
  const DeliveryOrderEventModel({required this.id, required this.status, this.createdAt});

  final int id;
  final String status;
  final DateTime? createdAt;

  factory DeliveryOrderEventModel.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderEventModel(
      id: _asInt(json['id']),
      status: _asString(json['status'] ?? json['event'] ?? json['type']),
      createdAt: _asDate(json['createdAt'] ?? json['created_at']),
    );
  }

  @override
  List<Object?> get props => [id, status, createdAt];
}

class DeliveryFinancialSummaryModel extends Equatable {
  const DeliveryFinancialSummaryModel({required this.currentBalance, required this.financialLimit, required this.isSuspended, required this.currency, this.suspensionReason});

  final num currentBalance;
  final num financialLimit;
  final bool isSuspended;
  final String currency;
  final String? suspensionReason;

  factory DeliveryFinancialSummaryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryFinancialSummaryModel(
      currentBalance: _asNum(json['currentBalance'] ?? json['current_balance'], fallback: 0),
      financialLimit: _asNum(json['financialLimit'] ?? json['financial_limit'], fallback: 0),
      isSuspended: _asBool(json['isSuspended'] ?? json['is_suspended']),
      suspensionReason: _nullableString(json['suspensionReason'] ?? json['suspension_reason']),
      currency: _asString(json['currency'], fallback: 'SYP'),
    );
  }

  @override
  List<Object?> get props => [currentBalance, financialLimit, isSuspended, currency, suspensionReason];
}

class UserNotificationModel extends Equatable {
  const UserNotificationModel({required this.id, required this.title, required this.body, required this.isRead, this.createdAt});

  final String id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime? createdAt;

  factory UserNotificationModel.fromJson(Map<String, dynamic> json) {
    return UserNotificationModel(
      id: _asString(json['id']),
      title: _asString(json['title'] ?? json['data']?['title'], fallback: 'إشعار'),
      body: _asString(json['body'] ?? json['message'] ?? json['data']?['body']),
      isRead: json['readAt'] != null || json['read_at'] != null || _asBool(json['isRead'] ?? json['is_read']),
      createdAt: _asDate(json['createdAt'] ?? json['created_at']),
    );
  }

  UserNotificationModel markRead() => UserNotificationModel(id: id, title: title, body: body, isRead: true, createdAt: createdAt);

  @override
  List<Object?> get props => [id, title, body, isRead, createdAt];
}

class DeliveryDisputeModel extends Equatable {
  const DeliveryDisputeModel({required this.id, required this.orderId, required this.status, required this.category, required this.ticketNumber, required this.description, this.resolution, this.createdAt, this.updatedAt});

  final int id;
  final int orderId;
  final String status;
  final String category;
  final String ticketNumber;
  final String description;
  final String? resolution;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory DeliveryDisputeModel.fromJson(Map<String, dynamic> json) {
    return DeliveryDisputeModel(
      id: _asInt(json['id']),
      orderId: _asInt(json['orderId'] ?? json['order_id']),
      status: _asString(json['status']),
      category: _asString(json['category']),
      ticketNumber: _asString(json['ticketNumber'] ?? json['ticket_number']),
      description: _asString(json['description']),
      resolution: _nullableString(json['resolution']),
      createdAt: _asDate(json['createdAt'] ?? json['created_at']),
      updatedAt: _asDate(json['updatedAt'] ?? json['updated_at']),
    );
  }

  @override
  List<Object?> get props => [id, orderId, status, category, ticketNumber, description, resolution, createdAt, updatedAt];
}

class LoginResult {
  const LoginResult({required this.token, required this.driver});
  final String token;
  final DriverModel driver;
}

Map<String, dynamic> unwrapData(Object? responseData) {
  if (responseData is Map<String, dynamic>) {
    final data = responseData['data'];
    if (data is Map<String, dynamic>) return data;
    return responseData;
  }
  return <String, dynamic>{};
}

List<Map<String, dynamic>> unwrapDataList(Object? responseData) {
  if (responseData is Map<String, dynamic>) {
    final data = responseData['data'];
    if (data is List) return data.whereType<Map<String, dynamic>>().toList();
    if (data is Map<String, dynamic>) {
      final nested = data['data'];
      if (nested is List) return nested.whereType<Map<String, dynamic>>().toList();
    }
  }
  if (responseData is List) return responseData.whereType<Map<String, dynamic>>().toList();
  return const [];
}

String _asString(Object? value, {String fallback = ''}) => value == null ? fallback : value.toString();
String? _nullableString(Object? value) => value == null ? null : value.toString();
int _asInt(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;
num _asNum(Object? value, {num fallback = 0}) => num.tryParse(value?.toString() ?? '') ?? fallback;
bool _asBool(Object? value) => value == true || value?.toString() == '1' || value?.toString().toLowerCase() == 'true';
DateTime? _asDate(Object? value) => value == null ? null : DateTime.tryParse(value.toString());
