import 'package:equatable/equatable.dart';

import 'delivery_order_model.dart';

class DeliveryDisputesSummary extends Equatable {
  const DeliveryDisputesSummary({
    this.totalCount = 0,
    this.openCount = 0,
    this.resolvedCount = 0,
  });

  final int totalCount;
  final int openCount;
  final int resolvedCount;

  @override
  List<Object?> get props => [totalCount, openCount, resolvedCount];
}

class DeliveryDisputesResponse extends Equatable {
  const DeliveryDisputesResponse({
    this.disputes = const [],
    this.summary = const DeliveryDisputesSummary(),
  });

  final List<DeliveryDisputeModel> disputes;
  final DeliveryDisputesSummary summary;

  @override
  List<Object?> get props => [disputes, summary];
}

class DeliveryDisputeModel extends Equatable {
  const DeliveryDisputeModel({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.statusLabel,
    required this.category,
    required this.categoryLabel,
    required this.ticketNumber,
    required this.description,
    required this.trustImpactPoints,
    this.resolution,
    this.resolutionLabel,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int orderId;
  final String orderNumber;
  final String status;
  final String statusLabel;
  final String category;
  final String categoryLabel;
  final String ticketNumber;
  final String description;
  final int trustImpactPoints;
  final String? resolution;
  final String? resolutionLabel;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isResolved {
    final normalized = status.trim().toLowerCase();
    return normalized == 'resolved' ||
        normalized == 'closed' ||
        normalized == 'rejected';
  }

  factory DeliveryDisputeModel.fromJson(Map<String, dynamic> json) {
    return DeliveryDisputeModel(
      id: _asInt(json['id']),
      orderId: _asInt(json['orderId'] ?? json['order_id']),
      orderNumber: _asString(
        json['orderNumber'] ?? json['order_number'],
        fallback: '#${json['orderId'] ?? json['order_id'] ?? json['id'] ?? ''}',
      ),
      status: _asString(json['status']),
      statusLabel: _labelOrFallback(
        json['statusLabel'] ?? json['status_label'],
        _statusLabel(_asString(json['status'])),
      ),
      category: _asString(json['category']),
      categoryLabel: _labelOrFallback(
        json['categoryLabel'] ?? json['category_label'],
        _categoryLabel(_asString(json['category'])),
      ),
      ticketNumber: _asString(json['ticketNumber'] ?? json['ticket_number']),
      description: _asString(json['description']),
      trustImpactPoints: _asInt(
        json['trustImpactPoints'] ?? json['trust_impact_points'],
      ),
      resolution: _nullableString(json['resolution']),
      resolutionLabel: _nullableString(
        json['resolutionLabel'] ?? json['resolution_label'],
      ),
      createdAt: _asDate(json['createdAt'] ?? json['created_at']),
      updatedAt: _asDate(json['updatedAt'] ?? json['updated_at']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    orderId,
    orderNumber,
    status,
    statusLabel,
    category,
    categoryLabel,
    ticketNumber,
    description,
    trustImpactPoints,
    resolution,
    resolutionLabel,
    createdAt,
    updatedAt,
  ];
}

DeliveryDisputesResponse deliveryDisputesResponseFromJson(dynamic json) {
  final disputes = unwrapDataList(
    json,
  ).map(DeliveryDisputeModel.fromJson).toList();
  final summary = _asMap(json is Map<String, dynamic> ? json['summary'] : null);

  final computedOpenCount = disputes
      .where((dispute) => !dispute.isResolved)
      .length;
  final computedResolvedCount = disputes
      .where((dispute) => dispute.isResolved)
      .length;

  return DeliveryDisputesResponse(
    disputes: disputes,
    summary: DeliveryDisputesSummary(
      totalCount: _asInt(summary['totalCount'] ?? summary['total_count']) == 0
          ? disputes.length
          : _asInt(summary['totalCount'] ?? summary['total_count']),
      openCount: _asInt(summary['openCount'] ?? summary['open_count']) == 0
          ? computedOpenCount
          : _asInt(summary['openCount'] ?? summary['open_count']),
      resolvedCount:
          _asInt(summary['resolvedCount'] ?? summary['resolved_count']) == 0
          ? computedResolvedCount
          : _asInt(summary['resolvedCount'] ?? summary['resolved_count']),
    ),
  );
}

Map<String, dynamic> _asMap(Object? value) =>
    value is Map<String, dynamic> ? value : <String, dynamic>{};

String _asString(Object? value, {String fallback = ''}) =>
    value == null ? fallback : value.toString();

String _labelOrFallback(Object? value, String fallback) {
  final label = _asString(value, fallback: fallback).trim();
  if (label.isEmpty || label.startsWith('cleaning_admin.')) {
    return fallback;
  }
  return label;
}

String? _nullableString(Object? value) => value?.toString();

int _asInt(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;

DateTime? _asDate(Object? value) =>
    value == null ? null : DateTime.tryParse(value.toString());

String _statusLabel(String status) {
  switch (status.trim().toLowerCase()) {
    case 'open':
      return 'مفتوح';
    case 'under_review':
      return 'قيد المراجعة';
    case 'resolved':
      return 'محلول';
    case 'closed':
      return 'مغلق';
    case 'rejected':
      return 'مرفوض';
    default:
      return status.isEmpty ? 'غير محدد' : status;
  }
}

String _categoryLabel(String category) {
  switch (category.trim().toLowerCase()) {
    case 'poor_quality':
      return 'جودة الخدمة';
    case 'property_damage':
      return 'تلف بالممتلكات';
    case 'unprofessional':
      return 'سلوك غير مهني';
    case 'billing_issue':
      return 'مشكلة مالية';
    case 'customer_terms_violation':
      return 'مخالفة شروط العميل';
    case 'financial_or_verbal_dispute':
      return 'خلاف مالي أو لفظي';
    case 'force_majeure':
      return 'ظرف طارئ';
    case 'other':
      return 'بلاغ عام';
    default:
      return category.isEmpty ? 'بلاغ' : category;
  }
}
