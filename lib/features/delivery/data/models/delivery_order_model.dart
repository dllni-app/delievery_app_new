import 'package:equatable/equatable.dart';

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
    if (data is List) {
      return data.whereType<Map<String, dynamic>>().toList();
    }
    if (data is Map<String, dynamic>) {
      final nested = data['data'];
      if (nested is List) {
        return nested.whereType<Map<String, dynamic>>().toList();
      }
    }
  }
  if (responseData is List) {
    return responseData.whereType<Map<String, dynamic>>().toList();
  }
  return const [];
}

Map<String, dynamic> _asMap(Object? value) =>
    value is Map<String, dynamic> ? value : <String, dynamic>{};

String _asString(Object? value, {String fallback = ''}) =>
    value == null ? fallback : value.toString();

String? _nullableString(Object? value) =>
    value == null ? null : value.toString();

int _asInt(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;

int? _nullableInt(Object? value) =>
    value == null ? null : int.tryParse(value.toString());

num _asNum(Object? value, {num fallback = 0}) =>
    num.tryParse(value?.toString() ?? '') ?? fallback;

bool _asBool(Object? value, {bool fallback = false}) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'true' || normalized == '1') return true;
    if (normalized == 'false' || normalized == '0') return false;
  }
  return fallback;
}

DateTime? _asDate(Object? value) =>
    value == null ? null : DateTime.tryParse(value.toString());

String _deliveryStatusUi(String status) {
  return switch (status) {
    'waiting_merchant_ready' => 'بانتظار جاهزية المتجر',
    'searching_for_driver' => 'جاري البحث عن مندوب',
    'dispatching' => 'جاري البحث عن مندوب',
    'offered' => 'تم إرسال العرض',
    'accepted' => 'مقبول',
    'in_progress' => 'قيد التنفيذ',
    'picked_up' => 'تم الاستلام',
    'completed' => 'مكتمل',
    'cancelled' => 'ملغي',
    _ => status,
  };
}

class MerchantPreparationModel extends Equatable {
  const MerchantPreparationModel({
    this.status,
    required this.isReady,
    this.estimatedPreparationMinutes,
    this.estimatedReadyAt,
    this.readyAt,
    required this.hasEstimate,
    required this.isEstimateOverdue,
  });

  final String? status;
  final bool isReady;
  final int? estimatedPreparationMinutes;
  final DateTime? estimatedReadyAt;
  final DateTime? readyAt;
  final bool hasEstimate;
  final bool isEstimateOverdue;

  factory MerchantPreparationModel.fromJson(Map<String, dynamic> json) {
    return MerchantPreparationModel(
      status: _nullableString(json['status']),
      isReady: _asBool(json['isReady'] ?? json['is_ready']),
      estimatedPreparationMinutes: _nullableInt(
        json['estimatedPreparationMinutes'] ??
            json['estimated_preparation_minutes'],
      ),
      estimatedReadyAt: _asDate(
        json['estimatedReadyAt'] ?? json['estimated_ready_at'],
      ),
      readyAt: _asDate(json['readyAt'] ?? json['ready_at']),
      hasEstimate: _asBool(json['hasEstimate'] ?? json['has_estimate']),
      isEstimateOverdue: _asBool(
        json['isEstimateOverdue'] ?? json['is_estimate_overdue'],
      ),
    );
  }

  String get displayLabel {
    if (isReady) return 'جاهز للاستلام';
    if (!hasEstimate || estimatedReadyAt == null) {
      return 'لا يوجد وقت تجهيز متوقع';
    }
    if (isEstimateOverdue) {
      return 'انتهى الوقت المتوقع — بانتظار المتجر';
    }

    final local = estimatedReadyAt!.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return 'الجاهزية المتوقعة $hour:$minute';
  }

  @override
  List<Object?> get props => [
        status,
        isReady,
        estimatedPreparationMinutes,
        estimatedReadyAt,
        readyAt,
        hasEstimate,
        isEstimateOverdue,
      ];
}

class DeliveryOrderEventModel extends Equatable {
  const DeliveryOrderEventModel({
    required this.id,
    required this.status,
    this.createdAt,
  });

  final int id;
  final String status;
  final DateTime? createdAt;

  factory DeliveryOrderEventModel.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderEventModel(
      id: _asInt(json['id']),
      status: _asString(
        json['toStatus'] ??
            json['to_status'] ??
            json['status'] ??
            json['event'] ??
            json['type'] ??
            json['payload']?['action'],
      ),
      createdAt: _asDate(json['createdAt'] ?? json['created_at']),
    );
  }

  @override
  List<Object?> get props => [id, status, createdAt];
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
    this.merchantPreparation,
    this.statusUi,
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
  final MerchantPreparationModel? merchantPreparation;
  final String? statusUi;
  final DateTime? acceptedAt;
  final DateTime? startedAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;
  final DateTime? completedAt;

  factory DeliveryOrderModel.fromJson(Map<String, dynamic> json) {
    final eventsJson = json['events'];
    final pickup = _asMap(json['pickup']);
    final dropoff = _asMap(json['dropoff']);
    final timestamps = _asMap(json['status_timestamps']);
    final rawStatus = _asString(json['status'], fallback: 'unknown');
    final merchantPreparationJson = _asMap(
      json['merchantPreparation'] ?? json['merchant_preparation'],
    );
    final merchantPreparation = merchantPreparationJson.isEmpty
        ? null
        : MerchantPreparationModel.fromJson(merchantPreparationJson);
    final normalStatusUi =
        _nullableString(json['statusUi'] ?? json['status_ui']) ??
            _deliveryStatusUi(rawStatus);
    final readinessStatusUi = merchantPreparation != null &&
            (rawStatus == 'accepted' || rawStatus == 'in_progress')
        ? merchantPreparation.displayLabel
        : normalStatusUi;

    return DeliveryOrderModel(
      id: _asInt(json['id']),
      orderNumber: _asString(
        json['orderNumber'] ??
            json['order_number'] ??
            json['order_id'],
        fallback: '#${json['id'] ?? ''}',
      ),
      companyId: _asInt(json['companyId'] ?? json['company_id']),
      driverId: _asInt(json['driverId'] ?? json['driver_id']),
      status: rawStatus,
      customerName: _asString(json['customerName'] ?? json['customer_name']),
      customerPhone: _asString(json['customerPhone'] ?? json['customer_phone']),
      pickupAddress: _asString(
        json['pickupAddress'] ?? json['pickup_address'] ?? pickup['address'],
      ),
      pickupLatitude: _asNum(
        json['pickupLatitude'] ?? json['pickup_latitude'] ?? pickup['lat'],
        fallback: 0,
      ),
      pickupLongitude: _asNum(
        json['pickupLongitude'] ?? json['pickup_longitude'] ?? pickup['lng'],
        fallback: 0,
      ),
      dropoffAddress: _asString(
        json['dropoffAddress'] ?? json['dropoff_address'] ?? dropoff['address'],
      ),
      dropoffLatitude: _asNum(
        json['dropoffLatitude'] ?? json['dropoff_latitude'] ?? dropoff['lat'],
        fallback: 0,
      ),
      dropoffLongitude: _asNum(
        json['dropoffLongitude'] ?? json['dropoff_longitude'] ?? dropoff['lng'],
        fallback: 0,
      ),
      distanceKm: _asNum(
        json['distanceKm'] ?? json['distance_km'],
        fallback: 0,
      ),
      deliveryFee: _asNum(
        json['deliveryFee'] ?? json['delivery_fee'],
        fallback: 0,
      ),
      currency: _asString(json['currency'], fallback: 'SYP'),
      merchantPreparation: merchantPreparation,
      statusUi: readinessStatusUi,
      acceptedAt: _asDate(
        json['acceptedAt'] ?? json['accepted_at'] ?? timestamps['accepted_at'],
      ),
      startedAt: _asDate(
        json['startedAt'] ?? json['started_at'] ?? timestamps['started_at'],
      ),
      pickedUpAt: _asDate(
        json['pickedUpAt'] ?? json['picked_up_at'] ?? timestamps['picked_up_at'],
      ),
      deliveredAt: _asDate(
        json['deliveredAt'] ??
            json['delivered_at'] ??
            timestamps['delivered_at'],
      ),
      completedAt: _asDate(
        json['completedAt'] ??
            json['completed_at'] ??
            timestamps['completed_at'],
      ),
      events: eventsJson is List
          ? eventsJson
              .whereType<Map<String, dynamic>>()
              .map(DeliveryOrderEventModel.fromJson)
              .toList()
          : const [],
    );
  }

  bool get isPickupBlocked =>
      status == 'in_progress' &&
      merchantPreparation != null &&
      !merchantPreparation!.isReady;

  bool get isWaitingForMerchantReadiness =>
      merchantPreparation != null &&
      !merchantPreparation!.isReady &&
      (status == 'accepted' || status == 'in_progress');

  String? get apiAction {
    switch (status) {
      case 'accepted':
      case 'offered':
        return 'start';
      case 'in_progress':
        return isPickupBlocked ? null : 'pickup';
      case 'picked_up':
        return 'deliver';
      default:
        return null;
    }
  }

  String get nextActionLabel {
    if (isPickupBlocked) return 'بانتظار جاهزية المتجر';
    switch (apiAction) {
      case 'start':
        return 'بدء التوجه إلى المتجر';
      case 'pickup':
        return 'تأكيد الاستلام';
      case 'deliver':
        return 'تأكيد التسليم';
      default:
        return '';
    }
  }

  bool get hasLifecycleAction => apiAction != null;

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        companyId,
        driverId,
        status,
        customerName,
        customerPhone,
        pickupAddress,
        pickupLatitude,
        pickupLongitude,
        dropoffAddress,
        dropoffLatitude,
        dropoffLongitude,
        distanceKm,
        deliveryFee,
        currency,
        events,
        merchantPreparation,
        statusUi,
        acceptedAt,
        startedAt,
        pickedUpAt,
        deliveredAt,
        completedAt,
      ];
}

DeliveryOrderModel? deliveryOrderModelFromNullableJson(dynamic json) {
  if (json is! Map<String, dynamic>) return null;
  final data = json['data'];
  if (data == null) return null;
  if (data is Map<String, dynamic>) {
    return DeliveryOrderModel.fromJson(data);
  }
  return null;
}

DeliveryOrderModel deliveryOrderModelFromJson(dynamic json) {
  if (json is Map<String, dynamic>) {
    return DeliveryOrderModel.fromJson(unwrapData(json));
  }
  return DeliveryOrderModel.fromJson(<String, dynamic>{});
}
