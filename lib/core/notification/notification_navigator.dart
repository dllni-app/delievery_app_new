import 'dart:convert';

import '../../common/helper/src/app_varibles.dart';
import '../../router/route_names.dart';

class NotificationNavigator {
  NotificationNavigator._();

  static void navigateFromData(Map<String, dynamic> data) {
    final payload = _normalizePayload(data);
    if (payload == null) {
      _goToDriverEntry();
      return;
    }

    final route = payload['route']?.toString();
    final type = payload['type']?.toString();
    final module = payload['module']?.toString();

    final isDeliveryPayload = module == 'delivery' ||
        type == 'delivery_order' ||
        type == 'driver_order' ||
        route == 'deliveryOrder' ||
        route == 'driverOrder' ||
        payload.containsKey('order_id') ||
        payload.containsKey('orderId');

    if (isDeliveryPayload) {
      _goToDriverEntry();
      return;
    }

    _goToDriverEntry();
  }

  static void navigateFromScreen(Map<String, dynamic> data) {
    navigateFromData(data);
  }

  static Map<String, dynamic>? _normalizePayload(Map<String, dynamic> data) {
    final args = data['args'];
    if (args is String && args.trim().isNotEmpty) {
      try {
        final decoded = json.decode(args);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) return decoded.map((key, value) => MapEntry(key.toString(), value));
      } catch (_) {
        return data.map((key, value) => MapEntry(key.toString(), value));
      }
    }

    if (args is Map<String, dynamic>) return args;
    if (args is Map) return args.map((key, value) => MapEntry(key.toString(), value));
    if (data.isEmpty) return null;
    return data.map((key, value) => MapEntry(key.toString(), value));
  }

  static void _goToDriverEntry() {
    final navigator = AppVariables.navigatorKey.currentState;
    if (navigator == null) return;
    navigator.pushNamedAndRemoveUntil(RouteName.splash, (_) => false);
  }
}
