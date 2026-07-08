import 'package:equatable/equatable.dart';

import 'delivery_order_model.dart';

class DeliveryDisputeModel extends Equatable {
  const DeliveryDisputeModel({
    required this.id,
    required this.orderId,
    required this.status,
    required this.category,
    required this.ticketNumber,
    required this.description,
    this.resolution,
    this.createdAt,
    this.updatedAt,
  });

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
  List<Object?> get props => [
        id,
        orderId,
        status,
        category,
        ticketNumber,
        description,
        resolution,
        createdAt,
        updatedAt,
      ];
}

List<DeliveryDisputeModel> deliveryDisputesFromJson(dynamic json) {
  return unwrapDataList(json)
      .map(DeliveryDisputeModel.fromJson)
      .toList();
}

String _asString(Object? value, {String fallback = ''}) =>
    value == null ? fallback : value.toString();

String? _nullableString(Object? value) =>
    value == null ? null : value.toString();

int _asInt(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;

DateTime? _asDate(Object? value) =>
    value == null ? null : DateTime.tryParse(value.toString());
