import 'package:equatable/equatable.dart';

class DeliveryDashboardSummaryModel extends Equatable {
  const DeliveryDashboardSummaryModel({
    required this.activeOrdersCount,
    required this.completedTodayCount,
    required this.rejectedOffersTodayCount,
    required this.missedOffersTodayCount,
    required this.currentBalance,
    required this.currency,
    required this.availabilityStatus,
  });

  final int activeOrdersCount;
  final int completedTodayCount;
  final int rejectedOffersTodayCount;
  final int missedOffersTodayCount;
  final num currentBalance;
  final String currency;
  final String availabilityStatus;

  factory DeliveryDashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryDashboardSummaryModel(
      activeOrdersCount: _asInt(json['activeOrdersCount'] ?? json['active_orders_count']),
      completedTodayCount: _asInt(json['completedTodayCount'] ?? json['completed_today_count']),
      rejectedOffersTodayCount: _asInt(json['rejectedOffersTodayCount'] ?? json['rejected_offers_today_count']),
      missedOffersTodayCount: _asInt(json['missedOffersTodayCount'] ?? json['missed_offers_today_count']),
      currentBalance: _asNum(json['currentBalance'] ?? json['current_balance']),
      currency: _asString(json['currency'], fallback: 'SYP'),
      availabilityStatus: _asString(json['availabilityStatus'] ?? json['availability_status'], fallback: 'offline'),
    );
  }

  @override
  List<Object?> get props => [
        activeOrdersCount,
        completedTodayCount,
        rejectedOffersTodayCount,
        missedOffersTodayCount,
        currentBalance,
        currency,
        availabilityStatus,
      ];
}

int _asInt(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;
num _asNum(Object? value) => num.tryParse(value?.toString() ?? '') ?? 0;
String _asString(Object? value, {String fallback = ''}) => value == null ? fallback : value.toString();
