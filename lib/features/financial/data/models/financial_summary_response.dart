import 'package:equatable/equatable.dart';

FinancialSummaryModel financialSummaryModelFromJson(dynamic json) {
  if (json is Map<String, dynamic>) {
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      return FinancialSummaryModel.fromJson(data);
    }
    return FinancialSummaryModel.fromJson(json);
  }
  return const FinancialSummaryModel(
    currentBalance: 0,
    financialLimit: 0,
    isSuspended: false,
    currency: 'SYP',
  );
}

class FinancialSummaryModel extends Equatable {
  const FinancialSummaryModel({
    required this.currentBalance,
    required this.financialLimit,
    required this.isSuspended,
    required this.currency,
    this.suspensionReason,
  });

  final num currentBalance;
  final num financialLimit;
  final bool isSuspended;
  final String currency;
  final String? suspensionReason;

  factory FinancialSummaryModel.fromJson(Map<String, dynamic> json) {
    return FinancialSummaryModel(
      currentBalance: _asNum(
        json['currentBalance'] ?? json['current_balance'],
        fallback: 0,
      ),
      financialLimit: _asNum(
        json['financialLimit'] ?? json['financial_limit'],
        fallback: 0,
      ),
      isSuspended: _asBool(json['isSuspended'] ?? json['is_suspended']),
      suspensionReason: _nullableString(
        json['suspensionReason'] ?? json['suspension_reason'],
      ),
      currency: _asString(json['currency'], fallback: 'SYP'),
    );
  }

  @override
  List<Object?> get props => [
        currentBalance,
        financialLimit,
        isSuspended,
        currency,
        suspensionReason,
      ];
}

String _asString(Object? value, {String fallback = ''}) =>
    value == null ? fallback : value.toString();

String? _nullableString(Object? value) =>
    value == null ? null : value.toString();

num _asNum(Object? value, {num fallback = 0}) =>
    num.tryParse(value?.toString() ?? '') ?? fallback;

bool _asBool(Object? value) =>
    value == true ||
    value?.toString() == '1' ||
    value?.toString().toLowerCase() == 'true';
