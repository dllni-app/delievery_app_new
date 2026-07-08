import 'package:flutter/material.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/home/presentation/pages/nav_bar_screen.dart';
import '../features/notification/presentation/pages/notification_screen.dart';
import '../features/splash/page/splash_screen.dart';
import '../features/user/presentation/pages/personal_information_screen.dart';

class RouteName {
  RouteName._();

  static const splash = "splash";
  static const onBoard = "onBoard";
  static const login = "login";
  static const signup = "signup";
  static const homeNav = "homeNav";
  static const confirm = "confirm";
  static const forgetPassword = "forgetPassword";
  static const forgetPasswordReset = "forgetPasswordReset";
  static const notification = "notification";
  static const personalInformation = "personalInformation";
  static const changePhoto = "changePhoto";
  static const search = "search";
  static const productDetails = "productDetails";
  static const productDetailsTrackScreen = "productDetailsTrackScreen";
}

class RouteManager {
  RouteManager._();

  static Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RouteName.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteName.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RouteName.homeNav:
        return MaterialPageRoute(builder: (_) => NavBarScreen());

      case RouteName.notification:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());

      case RouteName.personalInformation:
        final args = routeSettings.arguments as PersonalInformationParams;
        return MaterialPageRoute(
          builder: (_) => PersonalInformationScreen(arg: args),
        );

      default:
        return MaterialPageRoute(builder: (_) => Container());
    }
  }
}
