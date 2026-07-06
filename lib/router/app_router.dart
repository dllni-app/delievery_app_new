import 'package:flutter/material.dart';

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
      // case RouteName.splash:
      //   return MaterialPageRoute(builder: (_) => const SplashScreen());
      // case RouteName.productDetails:
      //   return MaterialPageRoute(
      //     builder: (_) => ProductDetailsScreen(
      //       arg: routeSettings.arguments as ProductDetailsScreenParams,
      //     ),
      //   );
      //   case RouteName.productDetailsTrackScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => ProductDetailsTrackScreen(
      //       arg: routeSettings.arguments as ProductDetailsTrackScreenParams,
      //     ),
      //   );
      // case RouteName.confirm:
      //   return MaterialPageRoute(
      //     builder: (_) => ConfirmScreen(
      //       arg: routeSettings.arguments as ConfirmScreenParams,
      //     ),
      //   );
      //
      // case RouteName.onBoard:
      //   return MaterialPageRoute(builder: (_) => OnBoardScreen());
      // case RouteName.search:
      //   return MaterialPageRoute(
      //     builder: (_) =>
      //         SearchScreen(arg: routeSettings.arguments as SearchScreenParams),
      //   );
      // case RouteName.login:
      //   return MaterialPageRoute(builder: (_) => const LoginScreen());
      // case RouteName.signup:
      //   return MaterialPageRoute(builder: (_) => SignUpScreen());
      //
      // case RouteName.homeNav:
      //   return MaterialPageRoute(builder: (_) => NavBarScreen());
      // case RouteName.forgetPassword:
      //   return MaterialPageRoute(builder: (_) => ForgetPasswordEmailScreen());
      // case RouteName.forgetPasswordReset:
      //   return MaterialPageRoute(
      //     builder: (_) => ForgetPasswordResetScreen(
      //       arg: routeSettings.arguments as ForgetPasswordResetScreenParams,
      //     ),
      //   );

      default:
        return MaterialPageRoute(builder: (_) => Container());
    }
  }
}
