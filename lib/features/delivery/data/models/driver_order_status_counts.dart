import 'package:equatable/equatable.dart';

/// All-time driver order counts supplied by GET /orders/status-counts.
/// The backend's totals are not daily statistics or driver earnings.
class DriverOrderStatusCounts extends Equatable {
  const DriverOrderStatusCounts({
    required this.active,
    required this.completed,
    required this.waitingAcceptance,
    required this.rejected,
  });

  final int active;
  final int completed;
  final int waitingAcceptance;
  final int rejected;

  static int _parseCount(Object? value) {
    if (value is int) return value < 0 ? 0 : value;
    final parsed = int.tryParse(value?.toString() ?? '');
    return parsed == null || parsed < 0 ? 0 : parsed;
  }

  factory DriverOrderStatusCounts.fromJson(dynamic response) {
    final object = response is Map ? response : const <String, dynamic>{};
    final data = object['data'];
    final counts = data is Map ? data : object;

    return DriverOrderStatusCounts(
      active: _parseCount(counts['ACTIVE']),
      completed: _parseCount(counts['COMPLETED']),
      waitingAcceptance: _parseCount(counts['WAITING_ACCEPTANCE']),
      rejected: _parseCount(counts['REJECTED']),
    );
  }

  @override
  List<Object?> get props => [
    active,
    completed,
    waitingAcceptance,
    rejected,
  ];
}
