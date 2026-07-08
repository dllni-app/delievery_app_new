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
    thresholdRatio: 0,
    warningLevel: 'NORMAL',
    isSuspended: false,
    currency: 'SYP',
  );
}

class FinancialSummaryModel extends Equatable {
  const FinancialSummaryModel({
    required this.currentBalance,
    required this.financialLimit,
    required this.thresholdRatio,
    required this.warningLevel,
    required this.isSuspended,
    required this.currency,
    this.suspensionReason,
  });

  final num currentBalance;
  final num financialLimit;
  final num thresholdRatio;
  final String warningLevel;
  final bool isSuspended;
  final String currency;
  final String? suspensionReason;

  int get thresholdPercent {
    final rawPercent = thresholdRatio <= 1 ? thresholdRatio * 100 : thresholdRatio;
    return rawPercent.clamp(0, 100).round();
  }

  bool get shouldShowWarning =>
      isSuspended || warningLevel == 'NEAR_STOP' || warningLevel == 'STOP';

  factory FinancialSummaryModel.fromJson(Map<String, dynamic> json) {
    final balance = _asNum(
      json['currentBalance'] ?? json['current_balance'],
      fallback: 0,
    );
    final limit = _asNum(
      json['financialLimit'] ?? json['financial_limit'],
      fallback: 0,
    );
    final providedRatio = json['thresholdRatio'] ?? json['threshold_ratio'];
    final calculatedRatio = limit > 0 ? balance / limit : 0;

    return FinancialSummaryModel(
      currentBalance: balance,
      financialLimit: limit,
      thresholdRatio: _asNum(providedRatio, fallback: calculatedRatio),
      warningLevel: _asString(
        json['warningLevel'] ?? json['warning_level'],
        fallback: limit > 0 && balance >= limit
            ? 'STOP'
            : (limit > 0 && balance / limit >= .8 ? 'NEAR_STOP' : 'NORMAL'),
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
        thresholdRatio,
        warningLevel,
        isSuspended,
        suspensionReason,
        currency,
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
