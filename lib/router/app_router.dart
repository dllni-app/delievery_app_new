import 'package:flutter/material.dart';

import '../features/driver_app/presentation/pages/driver_pages.dart';
import 'route_names.dart';

export 'route_names.dart';

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
    return const Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    );
  }
}
