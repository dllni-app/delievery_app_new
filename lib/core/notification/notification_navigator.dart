import 'dart:convert';
import '../../common/helper/src/app_varibles.dart';
import '../../router/app_router.dart';
import '../di/injection.dart';

class NotificationNavigator {
  NotificationNavigator._();

  static void navigateFromData(Map<String, dynamic> data) {
    print('enter fun');

    if (data['args'] == null) {
      return;
    } else {
      if (data['args'] == null) {
        print('args is null or empty');
        _goToNotification();
        return;
      }

      final val = json.decode(data['args']);

      print(val);
      print(val);
      print(val);

      if ((val['route'] == 'productDetails')) {
        if (val['tracking_number'] != null) {
          // AppVariables.navigatorKey.currentState!.pushNamed(
          //   RouteName.productDetails,
          //   arguments: ProductDetailsScreenParams(id: val["tracking_number"]),
          // );
        } else {
          print('order_id service_name null');
          _goToNotification();
        }
      } else {
        print('enter else nav');
        _goToNotification();
      }
    }
  }



  static void navigateFromScreen(Map<String, dynamic> val) {
    print('enter fun');




      print(val);
      print(val);
      print(val);

      if ((val['route'] == 'productDetails')) {
        if (val['tracking_number'] != null) {
          // AppVariables.navigatorKey.currentState!.pushNamed(
          //   RouteName.productDetails,
          //   arguments: ProductDetailsScreenParams(id: val["tracking_number"]),
          // );
        } else {
          print('order_id service_name null');
          _goToNotification();
        }
      } else {
        print('enter else nav');
        _goToNotification();
      }
    }


  static void _goToNotification() {
    final navigator = AppVariables.navigatorKey.currentState;

    if (navigator == null) return;

    // رجع للصفحة الأولى ثم غير التاب
    navigator.popUntil((route) => route.isFirst);
    // getIt<HomeCubit>().changeIndex(2);
  }
}
