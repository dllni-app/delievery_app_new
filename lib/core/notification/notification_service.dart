import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../common/helper/src/app_varibles.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/notification/presentation/bloc/notification_bloc.dart';
import '../di/injection.dart';
import 'notification_navigator.dart';


/// ---------------- BACKGROUND HANDLER ----------------
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 Terminated message received: ${message.data}");

  // خزّن البيانات فقط
  getIt<HomeCubit>().setPendingNotification(message.data);
}

/// ---------------- AWESOME ACTION LISTENER ----------------
@pragma('vm:entry-point')
Future<void> onActionReceivedMethod(ReceivedAction action) async {
  print("🔔 Notification clicked: ${action.payload}");

  if (action.payload != null && action.payload!.isNotEmpty) {
    print('nav from sector 1');
    NotificationNavigator.navigateFromData(action.payload!);
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

  /// 🔢 عدّاد الإشعارات غير المقروءة (الحقيقة هنا)
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
      print("FCM Token: $token");
    }
  }

  /// ---------------- AWESOME INIT ----------------
  Future<void> _initAwesomeNotifications() async {
    await _awesome.initialize(
      // null,
        Platform.isAndroid ? 'resource://drawable/ic_stat_notify' : null,
        [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Basic Instant Notification',
        importance: NotificationImportance.High,
        defaultColor: const Color(0xFF2F4F46),
        onlyAlertOnce: true,
        channelShowBadge: true,
      ),
    ]);
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
    // Foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background (tap)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundTap);

    // Terminated
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// ---------------- FOREGROUND ----------------
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    getIt<NotificationBloc>().add(GetAllNotificationEvent(isReload: true));

    final args = jsonDecode(message.data['args']);
    getIt<NotificationBloc>().add(
      NewNotificationRevisedEvent(
        id: args['tracking_number'].toString(),
      ),
    );

    final payload = message.data.map(
      (k, v) => MapEntry(k.toString(), v.toString()),
    );

    _unreadCount++; // ✅ زيادة العداد الحقيقي

    await _awesome.createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'basic_channel',
        title: message.notification?.title ?? message.data['title'] ?? '',
        body: message.notification?.body ?? message.data['body'] ?? '',
        payload: payload,
        badge: _unreadCount, // ✅ إرسال العدد الحقيقي
        largeIcon: 'resource://mipmap/launcher_icon',
      ),
    );
  }

  /// ---------------- BACKGROUND TAP ----------------
  void _handleBackgroundTap(RemoteMessage message) {
    print("📩 Background notification tapped: ${message.data}");
    print('nav from sector 2');
    print(message.data);

    NotificationNavigator.navigateFromData(message.data);
  }

  /// ---------------- TERMINATED CHECK ----------------
  Future<void> _checkTerminatedNotification() async {
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print("📩 Terminated notification data: ${initialMessage.data}");

      // خزّن فقط – لا تنفّذ Navigation هنا
      getIt<HomeCubit>().setPendingNotification(initialMessage.data);
    }
  }

  /// ---------------- CLEAR BADGE ----------------
  /// استدعِها عند فتح التطبيق أو شاشة الإشعارات
  static Future<void> clearUnreadCount() async {
    _unreadCount = 0;
    await AwesomeNotifications().resetGlobalBadge();
  }
}
