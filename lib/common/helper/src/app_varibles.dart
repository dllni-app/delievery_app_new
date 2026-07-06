import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/di/injection.dart';
import '../../../core/unified_api/dio/api_client.dart';
import '../../models/user_model.dart';
import '../helper.dart';

class AppVariables {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final SharedPreferences _pref = getIt<SharedPreferences>();
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static String? _tokenCache;

  static Future<void> initializeSession() async {
    final secureToken = await _secureStorage.read(key: PrefsKeys.token);
    if (secureToken != null && secureToken.isNotEmpty) {
      _tokenCache = secureToken;
      return;
    }

    final legacyToken = _pref.getString(PrefsKeys.token);
    if (legacyToken == null || legacyToken.isEmpty) {
      _tokenCache = null;
      return;
    }

    await _secureStorage.write(key: PrefsKeys.token, value: legacyToken);
    await _pref.remove(PrefsKeys.token);
    _tokenCache = legacyToken;
  }

  static String? get token => _tokenCache;

  static set token(String? token) {
    _tokenCache = token;
    if (token == null || token.isEmpty) {
      unawaited(_secureStorage.delete(key: PrefsKeys.token));
      unawaited(_pref.remove(PrefsKeys.token));
      return;
    }
    unawaited(_secureStorage.write(key: PrefsKeys.token, value: token));
    unawaited(_pref.remove(PrefsKeys.token));
  }

  static Future<void> clearSession() async {
    _tokenCache = null;
    await _secureStorage.delete(key: PrefsKeys.token);
    await _pref.remove(PrefsKeys.token);
    await _pref.remove(PrefsKeys.userInfo);
    getIt<ApiClient>().resetHeader();
  }

  static String? get fcmToken => _pref.getString(PrefsKeys.fcmToken);

  static set fcmToken(String? fcmToken) => fcmToken == null ? null : _pref.setString(PrefsKeys.fcmToken, fcmToken);

  static UserModel get user => UserModel.fromJson(
        jsonDecode(_pref.getString(PrefsKeys.userInfo) ?? ''),
      );

  static set user(UserModel user) {
    _pref.setString(
      PrefsKeys.userInfo,
      jsonEncode(user.toJson()),
    );
  }

  static void setCurrentLang(BuildContext context) {
    String val = context.locale.languageCode;
    _pref.setString(PrefsKeys.lang, val);
    getIt<ApiClient>().resetHeader();
  }

  static String getCurrentLang() {
    return _pref.getString(PrefsKeys.lang) ??
        EasyLocalization.of(
          AppVariables.navigatorKey.currentContext!,
        )!.locale.languageCode;
  }

  static String checkLanguage(BuildContext context) {
    final currentLocale = context.locale;

    if (currentLocale.languageCode == 'en') {
      return 'en';
    } else if (currentLocale.languageCode == 'ar') {
      return 'ar';
    } else {
      return 'en';
    }
  }

  static String get savedTheme => _pref.getString(PrefsKeys.appTheme) ?? 'light';

  static set savedTheme(String theme) => _pref.setString(PrefsKeys.appTheme, theme);
}
