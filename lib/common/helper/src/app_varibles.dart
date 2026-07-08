import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/di/injection.dart';
import '../../../core/unified_api/dio/api_client.dart';
import '../../models/user_model.dart';
import '../helper.dart';

class AppVariables {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final SharedPreferences _pref = getIt<SharedPreferences>();

  static String? get token => _pref.getString(PrefsKeys.token);

  static set token(String? token) =>
      token == null ? null : _pref.setString(PrefsKeys.token, token);

  static String? get fcmToken => _pref.getString(PrefsKeys.fcmToken);

  static set fcmToken(String? fcmToken) =>
      fcmToken == null ? null : _pref.setString(PrefsKeys.fcmToken, fcmToken);



  static UserModel? get user {
    final userJson = _pref.getString(PrefsKeys.userInfo);

    if (userJson == null || userJson.isEmpty) {
      return null;
    }

    try {
      return UserModel.fromJson(jsonDecode(userJson));
    } catch (_) {
      return null;
    }
  }

  static set user(UserModel? user) {
    if (user == null) {
      _pref.remove(PrefsKeys.userInfo);
      return;
    }

    _pref.setString(
      PrefsKeys.userInfo,
      jsonEncode(user.toJson()),
    );
  }

  static void setCurrentLang(BuildContext context) {
    String val=context.locale.languageCode;
    _pref.setString(PrefsKeys.lang, val);
    getIt<ApiClient>().resetHeader();
  }

  static String getCurrentLang() {
    return _pref.getString(PrefsKeys.lang) ??
        EasyLocalization.of(
          AppVariables.navigatorKey.currentContext!,
        )!.locale.languageCode; // أو قيمة افتراضية
  }


 static String checkLanguage(BuildContext context) {
    final currentLocale = context.locale;

    if (currentLocale.languageCode == 'en') {
      return 'en';
      // إذا كانت اللغة إنجليزية
     // print('The current language is English');
    } else
      if (currentLocale.languageCode == 'ar') {
      // إذا كانت اللغة عربية
    //  print('اللغة الحالية هي العربية');
        return 'ar';

    } else {
        return 'en';
    //  print('Language: ${currentLocale.languageCode}');
    }
  }



  // getter لقراءة الثيم المحفوظ
  static String get savedTheme =>
      _pref.getString(PrefsKeys.appTheme) ?? 'light';

  // setter لحفظ الثيم
  static set savedTheme(String theme) =>
      _pref.setString(PrefsKeys.appTheme, theme);







}



// static List<Chat?> get chats {
//   final val = _pref.getString(PrefsKeys.chats);
//
//   if (val != null) {
//     List value = json.decode(val);
//
//     final list = List<Chat>.from(value.map((e) => Chat.fromJson(e))).toList();
//
//     return list;
//   } else {
//     return [];
//   }
//
//
//
// }
//
// static set chats(List<Chat?> chats) =>
//     chats == [] ? null :
//     _pref.setString(
//         PrefsKeys.chats, jsonEncode(chats.map((e) => e!.toJson()).toList()));
