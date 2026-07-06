import 'package:flutter/material.dart';
import '../../../../helper/src/app_varibles.dart';
import 'package:injectable/injectable.dart';

import 'theme_collection.dart';
enum AppThemeType { light}

@lazySingleton
class AppThemeNotifier with ChangeNotifier {
  AppThemeNotifier() {
    _loadThemeFromPrefsOrUser();
  }

  AppThemeType _currentTheme = AppThemeType.light;

  AppThemeType get currentTheme => _currentTheme;

  ThemeData get themeData {
    switch (_currentTheme) {
      // case AppThemeType.female:
      //   return ThemeCollection.femaleTheme;
      // case AppThemeType.male:
      default:
        return ThemeCollection.lightTheme;
    }
  }

  // // ✅ التبديل اليدوي
  // void toggleTheme() {
  //
  //   setTheme(
  //     _currentTheme == AppThemeType.male
  //         ? AppThemeType.female
  //         : AppThemeType.male,
  //   );
  // }

  // ✅ ضبط نوع الثيم وتخزينه
  void setTheme(AppThemeType type) {

    _currentTheme = type;
    _saveThemeToPrefs(type);
    notifyListeners();
  }

  // ✅ التحميل: حسب الـ prefs أو المستخدم الحالي
  void _loadThemeFromPrefsOrUser() {
    final savedTheme = AppVariables.savedTheme;
    print('saved theme ');
    print(AppVariables.savedTheme);

    // if (savedTheme.isNotEmpty) {
    //   // يوجد ثيم محفوظ
    //   if (savedTheme == 'female') {
    //     _currentTheme = AppThemeType.female;
    //   } else if (savedTheme == 'custom') {
    //     _currentTheme = AppThemeType.custom;
    //   } else {
    //
    //     _currentTheme = AppThemeType.male;
    //   }
    // } else {
    //   // لا يوجد ثيم محفوظ ⇒ نستخدم الجندر
    //   final user = AppVariables.user;
    //   if (user.gender == 'female') {
    //     _currentTheme = AppThemeType.female;
    //   } else {
    //     _currentTheme = AppThemeType.male;
    //   }
    // }
  }

  void _saveThemeToPrefs(AppThemeType type) {
    AppVariables.savedTheme = type.name;
  }
}

