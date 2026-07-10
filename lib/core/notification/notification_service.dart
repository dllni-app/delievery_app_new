import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../common/helper/src/app_varibles.dart';
import '../../features/delivery/presentation/cubit/delivery_cubit.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/notification/presentation/bloc/notification_bloc.dart';
import '../di/injection.dart';
import 'notification_navigator.dart';

const String _notificationIcon = 'resource://drawable/notification_icon';
const String _notificationLargeIcon = 'resource://mipmap/launcher_icon';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📩 Terminated message received: ${message.data}');
  getIt<HomeCubit>().setPendingNotification(message.data);
}

@pragma('vm:entry-point')
Future<void> onActionReceivedMethod(ReceivedAction action) async {
  print('🔔 Notification clicked: ${action.payload}');

  if (action.payload != null && action.payload!.isNotEmpty) {
    NotificationNavigator.navigateFromData(action.payload!);
  }
}

class NotificationUtils {
  NotificationUtils._();

  static final NotificationUtils _instance = NotificationUtils._();

  factory NotificationUtils() => _instance;

  static final AwesomeNotifications _awesome = AwesomeNotifications();
  static int _unreadCount = 0;

  Future<void> initAllNotifications() async {
    await _initFirebase();
    await _initAwesomeNotifications();
    await _ensurePermission();
    _registerListeners();
    await _checkTerminatedNotification();
    _startAwesomeListeners();
  }

  Future<void> _initFirebase() async {
    await Firebase.initializeApp();

    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      AppVariables.fcmToken = token;
      print('FCM Token: $token');
    }
  }

  Future<void> _initAwesomeNotifications() async {
    await _awesome.initialize(
      Platform.isAndroid ? _notificationIcon : null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Basic Instant Notification',
          importance: NotificationImportance.High,
          defaultColor: const Color(0xFF1E2A78),
          onlyAlertOnce: true,
          channelShowBadge: true,
        ),
      ],
    );
  }

  Future<void> _ensurePermission() async {
    final allowed = await _awesome.isNotificationAllowed();
    if (!allowed) {
      await _awesome.requestPermissionToSendNotifications();
    }
  }

  void _startAwesomeListeners() {
    _awesome.setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  void _registerListeners() {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundTap);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    getIt<NotificationBloc>().add(GetAllNotificationEvent(isReload: true));

    if (_isDeliveryReadinessNotification(message.data)) {
      await getIt<DeliveryCubit>().refreshAfterNotification();
    }

    final rawArgs = message.data['args'];
    if (rawArgs is String && rawArgs.isNotEmpty) {
      final decoded = jsonDecode(rawArgs);
      if (decoded is Map && decoded['tracking_number'] != null) {
        getIt<NotificationBloc>().add(
          NewNotificationRevisedEvent(
            id: decoded['tracking_number'].toString(),
          ),
        );
      }
    }

    final payload = message.data.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );

    _unreadCount++;

    await _awesome.createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'basic_channel',
        title: message.notification?.title ?? message.data['title'] ?? '',
        body: message.notification?.body ?? message.data['body'] ?? '',
        payload: payload,
        badge: _unreadCount,
        largeIcon: _notificationLargeIcon,
      ),
    );
  }

  void _handleBackgroundTap(RemoteMessage message) {
    if (_isDeliveryReadinessNotification(message.data)) {
      getIt<DeliveryCubit>().refreshAfterNotification();
    }
    NotificationNavigator.navigateFromData(message.data);
  }

  Future<void> _checkTerminatedNotification() async {
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      getIt<HomeCubit>().setPendingNotification(initialMessage.data);
    }
  }

  bool _isDeliveryReadinessNotification(Map<String, dynamic> data) {
    final candidates = <String>[
      data['canonicalType']?.toString() ?? '',
      data['canonical_type']?.toString() ?? '',
      data['type']?.toString() ?? '',
      data['notificationType']?.toString() ?? '',
      data['notification_type']?.toString() ?? '',
    ];

    return candidates.any(
      (value) => value.contains('merchant_ready') ||
          value.contains('merchant_preparation_updated'),
    );
  }

  static Future<void> clearUnreadCount() async {
    _unreadCount = 0;
    await AwesomeNotifications().resetGlobalBadge();
  }
}
