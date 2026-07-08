import 'package:equatable/equatable.dart';

import 'delivery_order_model.dart';

String _offerStatusLabel(String status, DateTime? expiresAt) {
  if (expiresAt == null && status == 'open') {
    return 'العرض متاح حتى يتم قبوله أو إلغاؤه';
  }
  return status;
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

  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);

  bool get hasExpiry => expiresAt != null;

  bool get hasUnknownDistance => distanceToPickupKm <= 0;

  String get distanceToPickupLabel => hasUnknownDistance
      ? 'المسافة غير متوفرة'
      : '$distanceToPickupKm كم';

  String get availabilityLabel => hasExpiry
      ? 'العرض محدد بوقت'
      : 'العرض متاح حتى يتم قبوله أو إلغاؤه';

  factory DeliveryAssignmentAttemptModel.fromJson(Map<String, dynamic> json) {
    final expiresAt = _asDate(json['expiresAt'] ?? json['expires_at']);
    final rawStatus = _asString(json['status']);
    return DeliveryAssignmentAttemptModel(
      id: _asInt(json['id']),
      orderId: _asInt(json['orderId'] ?? json['order_id']),
      driverId: _asInt(json['driverId'] ?? json['driver_id']),
      attemptNo: _asInt(json['attemptNo'] ?? json['attempt_no']),
      status: _offerStatusLabel(rawStatus, expiresAt),
      distanceToPickupKm: _asNum(
        json['distanceToPickupKm'] ?? json['distance_to_pickup_km'],
        fallback: 0,
      ),
      offeredAt: _asDate(json['offeredAt'] ?? json['offered_at']),
      expiresAt: expiresAt,
      respondedAt: _asDate(json['respondedAt'] ?? json['responded_at']),
      order: json['order'] is Map<String, dynamic>
          ? DeliveryOrderModel.fromJson(json['order'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        orderId,
        driverId,
        attemptNo,
        status,
        distanceToPickupKm,
        offeredAt,
        expiresAt,
        respondedAt,
        order,
      ];
}

DeliveryAssignmentAttemptModel? deliveryOfferModelFromNullableJson(
  dynamic json,
) {
  if (json is! Map<String, dynamic>) return null;
  final data = json['data'];
  if (data == null) return null;
  if (data is Map<String, dynamic>) {
    return DeliveryAssignmentAttemptModel.fromJson(data);
  }
  return null;
}

String _asString(Object? value, {String fallback = ''}) =>
    value == null ? fallback : value.toString();

int _asInt(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;

num _asNum(Object? value, {num fallback = 0}) =>
    num.tryParse(value?.toString() ?? '') ?? fallback;

DateTime? _asDate(Object? value) =>
    value == null ? null : DateTime.tryParse(value.toString());
