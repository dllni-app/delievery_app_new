import 'package:bot_toast/bot_toast.dart';
import 'package:dllne_deliver_app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'common/design/src/theme/theme/theme_notifier.dart';
import 'common/helper/helper.dart';
import 'core/di/injection.dart';
import 'core/notification/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await configureInjection();
  await NotificationUtils().initAllNotifications();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      // startLocale: const Locale('ar'),
      child: ChangeNotifierProvider<AppThemeNotifier>(
        create: (_) => getIt<AppThemeNotifier>(),
        child: MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppVariables.navigatorKey,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: context
          .watch<AppThemeNotifier>()
          .themeData,
      useInheritedMediaQuery: true,

      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),

      navigatorObservers: [BotToastNavigatorObserver()],
      initialRoute: RouteName.splash,
      onGenerateRoute: RouteManager.onGenerateRoute,
    );
  }
}