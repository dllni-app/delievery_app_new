import 'package:flutter/material.dart';

import '../features/driver_app/presentation/pages/driver_pages.dart';

class RouteName {
  RouteName._();

  static const splash = 'splash';
  static const onBoard = 'onBoard';
  static const login = 'login';
  static const signup = 'signup';
  static const homeNav = 'homeNav';
  static const confirm = 'confirm';
  static const forgetPassword = 'forgetPassword';
  static const forgetPasswordReset = 'forgetPasswordReset';
  static const notification = 'notification';
  static const personalInformation = 'personalInformation';
  static const changePhoto = 'changePhoto';
  static const search = 'search';
  static const productDetails = 'productDetails';
  static const productDetailsTrackScreen = 'productDetailsTrackScreen';
}

class RouteManager {
  RouteManager._();

  static Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RouteName.splash:
        return MaterialPageRoute(builder: (_) => const DriverSplashScreen());
      case RouteName.login:
        return MaterialPageRoute(builder: (_) => const DriverLoginScreen());
      case RouteName.homeNav:
        return MaterialPageRoute(builder: (_) => const DriverShellScreen());
      default:
        return MaterialPageRoute(builder: (_) => const _RouteNotFoundScreen());
    }
  }
}

class _RouteNotFoundScreen extends StatelessWidget {
  const _RouteNotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Center(
          child: Text('الصفحة غير موجودة'),
        ),
      ),
    );
  }
}
