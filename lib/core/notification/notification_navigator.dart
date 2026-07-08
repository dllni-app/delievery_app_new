import 'dart:convert';

import 'package:flutter/material.dart';

import '../../common/helper/src/app_varibles.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../router/app_router.dart';
import '../di/injection.dart';

class NotificationNavigator {
  NotificationNavigator._();

  static void navigateFromData(Map<String, dynamic> data) {
    final payload = _normalizePayload(data);
    if (payload == null) {
      _goToNotification();
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
      _goToNotification();
      return;
    }

    if (route == 'productDetails') {
      if (payload['tracking_number'] != null) {
        // AppVariables.navigatorKey.currentState!.pushNamed(
        //   RouteName.productDetails,
        //   arguments: ProductDetailsScreenParams(id: payload["tracking_number"]),
        // );
      } else {
        _goToNotification();
      }
    } else {
      _goToNotification();
    }
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
        if (decoded is Map) {
          return decoded.map((key, value) => MapEntry(key.toString(), value));
        }
      } catch (_) {
        return data.map((key, value) => MapEntry(key.toString(), value));
      }
    }

    if (args is Map<String, dynamic>) return args;
    if (args is Map) {
      return args.map((key, value) => MapEntry(key.toString(), value));
    }
    if (data.isEmpty) return null;
    return data.map((key, value) => MapEntry(key.toString(), value));
  }

  static void _goToNotification() {
    final navigator = AppVariables.navigatorKey.currentState;
    if (navigator == null) return;

    final currentRoute = ModalRoute.of(AppVariables.navigatorKey.currentContext!);
    if (currentRoute?.settings.name != RouteName.homeNav) {
      navigator.pushNamedAndRemoveUntil(RouteName.homeNav, (_) => false);
    } else {
      navigator.popUntil((route) => route.isFirst);
    }

    getIt<HomeCubit>().changeIndex(2);
  }
}
