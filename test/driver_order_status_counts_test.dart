import 'package:flutter_test/flutter_test.dart';
import 'package:dllne_deliver_app/features/delivery/data/models/driver_order_status_counts.dart';

void main() {
  test('parses the existing backend status-counts contract', () {
    final counts = DriverOrderStatusCounts.fromJson({
      'data': {
        'WAITING_ACCEPTANCE': 1,
        'ACTIVE': 2,
        'COMPLETED': 17,
        'REJECTED': 3,
      },
    });

    expect(counts.waitingAcceptance, 1);
    expect(counts.active, 2);
    expect(counts.completed, 17);
    expect(counts.rejected, 3);
  });

  test('does not turn missing or malformed totals into false earnings', () {
    final counts = DriverOrderStatusCounts.fromJson({
      'data': {
        'ACTIVE': '-8',
        'COMPLETED': '9',
        'REJECTED': null,
      },
    });

    expect(counts.active, 0);
    expect(counts.completed, 9);
    expect(counts.rejected, 0);
  });

  test('supports direct map responses for compatibility', () {
    final counts = DriverOrderStatusCounts.fromJson({'COMPLETED': 4});
    expect(counts.completed, 4);
    expect(counts.active, 0);
  });
}
