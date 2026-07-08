import 'package:equatable/equatable.dart';

import '../../../delivery/data/models/delivery_order_model.dart';

class FinancialTransactionModel extends Equatable {
  const FinancialTransactionModel({
    required this.id,
    required this.transactionType,
    required this.direction,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.referenceType,
    required this.referenceId,
    required this.note,
    required this.metadata,
    this.createdAt,
  });

  final int id;
  final String transactionType;
  final String direction;
  final num amount;
  final num balanceBefore;
  final num balanceAfter;
  final String referenceType;
  final int referenceId;
  final String note;
  final Map<String, dynamic> metadata;
  final DateTime? createdAt;

  bool get isCredit => direction == 'credit';

  String get title {
    final orderNumber = _nullableString(
      metadata['orderNumber'] ?? metadata['order_number'] ?? metadata['orderNo'],
    );
    final referenceLabel = orderNumber ?? (referenceId > 0 ? '#$referenceId' : '');

    return switch (transactionType) {
      'order_fee_debit' => referenceLabel.isEmpty
          ? 'تحصيل نقدي'
          : 'تحصيل نقدي (طلب $referenceLabel)',
      'collection_credit' => 'تسديد رصيد',
      'manual_adjustment_debit' => 'تسوية مالية - خصم',
      'manual_adjustment_credit' => 'تسوية مالية - تعويض',
      'dispute_penalty_debit' => 'غرامة بلاغ',
      'dispute_reversal_credit' => 'عكس غرامة بلاغ',
      _ => note.isNotEmpty ? note : 'حركة مالية',
    };
  }

  factory FinancialTransactionModel.fromJson(Map<String, dynamic> json) {
    return FinancialTransactionModel(
      id: _asInt(json['id']),
      transactionType: _asString(
        json['transactionType'] ?? json['transaction_type'],
      ),
      direction: _asString(json['direction']),
      amount: _asNum(json['amount']),
      balanceBefore: _asNum(json['balanceBefore'] ?? json['balance_before']),
      balanceAfter: _asNum(json['balanceAfter'] ?? json['balance_after']),
      referenceType: _asString(json['referenceType'] ?? json['reference_type']),
      referenceId: _asInt(json['referenceId'] ?? json['reference_id']),
      note: _asString(json['note']),
      metadata: _asMap(json['metadata']),
      createdAt: _asDate(json['createdAt'] ?? json['created_at']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        transactionType,
        direction,
        amount,
        balanceBefore,
        balanceAfter,
        referenceType,
        referenceId,
        note,
        metadata,
        createdAt,
      ];
}

List<FinancialTransactionModel> financialTransactionsFromJson(dynamic json) {
  return unwrapDataList(json).map(FinancialTransactionModel.fromJson).toList();
}

Map<String, dynamic> _asMap(Object? value) =>
    value is Map<String, dynamic> ? value : <String, dynamic>{};

String _asString(Object? value, {String fallback = ''}) =>
    value == null ? fallback : value.toString();

String? _nullableString(Object? value) =>
    value == null ? null : value.toString();

int _asInt(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;

num _asNum(Object? value, {num fallback = 0}) =>
    num.tryParse(value?.toString() ?? '') ?? fallback;

DateTime? _asDate(Object? value) =>
    value == null ? null : DateTime.tryParse(value.toString());
