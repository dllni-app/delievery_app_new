import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../common/helper/src/app_varibles.dart';
import 'notification_navigator.dart';

/// ---------------- BACKGROUND HANDLER ----------------
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

/// ---------------- AWESOME ACTION LISTENER ----------------
@pragma('vm:entry-point')
Future<void> onActionReceivedMethod(ReceivedAction action) async {
  final payload = action.payload;
  if (payload != null && payload.isNotEmpty) {
    NotificationNavigator.navigateFromData(payload);
  }
}

/// =====================================================
/// ================= Notification Utils =================
/// =====================================================
class NotificationUtils {
  NotificationUtils._();

  static final NotificationUtils _instance = NotificationUtils._();

  factory NotificationUtils() => _instance;

  static final AwesomeNotifications _awesome = AwesomeNotifications();

  static int _unreadCount = 0;

  /// ---------------- INIT ALL ----------------
  Future<void> initAllNotifications() async {
    await _initFirebase();
    await _initAwesomeNotifications();
    await _ensurePermission();
    _registerListeners();
    await _checkTerminatedNotification();
    _startAwesomeListeners();
  }

  /// ---------------- FIREBASE INIT ----------------
  Future<void> _initFirebase() async {
    await Firebase.initializeApp();

    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      AppVariables.fcmToken = token;
    }
  }

  /// ---------------- AWESOME INIT ----------------
  Future<void> _initAwesomeNotifications() async {
    await _awesome.initialize(
      Platform.isAndroid ? 'resource://drawable/ic_stat_notify' : null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Delivery driver notifications',
          importance: NotificationImportance.High,
          defaultColor: const Color(0xFF021064),
          onlyAlertOnce: true,
          channelShowBadge: true,
        ),
      ],
    );
  }

  /// ---------------- PERMISSION ----------------
  Future<void> _ensurePermission() async {
    final allowed = await _awesome.isNotificationAllowed();
    if (!allowed) {
      await _awesome.requestPermissionToSendNotifications();
    }
  }

  /// ---------------- LISTENERS ----------------
  void _startAwesomeListeners() {
    _awesome.setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  void _registerListeners() {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundTap);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// ---------------- FOREGROUND ----------------
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final payload = message.data.map((key, value) => MapEntry(key.toString(), value.toString()));
    _unreadCount++;

    await _awesome.createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'basic_channel',
        title: message.notification?.title ?? message.data['title'] ?? 'إشعار جديد',
        body: message.notification?.body ?? message.data['body'] ?? '',
        payload: payload,
        badge: _unreadCount,
        largeIcon: 'asset://assets/images/png/notification_logo.png',
      ),
    );
  }

  /// ---------------- BACKGROUND TAP ----------------
  void _handleBackgroundTap(RemoteMessage message) {
    NotificationNavigator.navigateFromData(message.data);
  }

  /// ---------------- TERMINATED CHECK ----------------
  Future<void> _checkTerminatedNotification() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      NotificationNavigator.navigateFromData(initialMessage.data);
    }
  }

  /// ---------------- CLEAR BADGE ----------------
  static Future<void> clearUnreadCount() async {
    _unreadCount = 0;
    await AwesomeNotifications().resetGlobalBadge();
  }
}
