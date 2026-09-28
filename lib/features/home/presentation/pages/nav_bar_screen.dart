import 'dart:async';

import 'package:dllne_deliver_app/features/home/presentation/widgets/shell_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' as d;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart' as loc;

import '../../../../common/design/src/theme/theme/theme_collection.dart';
import '../../../../common/helper/src/locale_keys.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../delivery/presentation/pages/delivery_orders_page.dart';
import '../../../financial/presentation/pages/driver_financial_page.dart';
import '../../../user/domain/use_cases/post_location_use_cases.dart';
import '../../../notification/presentation/bloc/notification_bloc.dart';
import '../../../notification/presentation/pages/notification_screen.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../user/presentation/pages/new_more_screen.dart';
import '../cubit/home_cubit.dart';
import 'new_home_screen.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _DriverTopAppBar extends StatelessWidget {
  final String title;
  final String avatarName;
  final VoidCallback onNotificationPressed;

  const _DriverTopAppBar({
    required this.title,
    required this.avatarName,
    required this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return d.Directionality(
      textDirection: d.TextDirection.ltr,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.paddingOf(context).top + 16,
          16,
          8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<NotificationBloc, NotificationState>(
              bloc: getIt<NotificationBloc>(),
              builder: (context, notificationState) {
                return InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: onNotificationPressed,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: Badge(
                        isLabelVisible: notificationState.isNew,
                        child: Icon(
                          Icons.notifications_none,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    _initial(avatarName),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _initial(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '-';
    return trimmed[0];
  }
}

// I make it global for new_more_screen.dart
late final HomeCubit homeCubit;

class _NavBarScreenState extends State<NavBarScreen>
    with WidgetsBindingObserver {
  late final PageController pageController;
  late final UserBloc userBloc;
  final loc.Location _location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  DateTime? _lastLocationSentAt;
  static const _locationThrottle = Duration(seconds: 20);

  String _titleForIndex(int index, String driverName) {
    return switch (index) {
      1 => 'الطلبات',
      2 => 'المستحقات',
      3 => 'الإشعارات',
      4 => 'المزيد',
      _ => driverName,
    };
  }

  Future<void> _startLocationTracking() async {
    try {
      var serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
      }
      if (!serviceEnabled) return;

      var permission = await _location.hasPermission();
      if (permission == loc.PermissionStatus.denied) {
        permission = await _location.requestPermission();
      }
      if (permission != loc.PermissionStatus.granted) return;

      await _location.changeSettings(
        accuracy: loc.LocationAccuracy.high,
        interval: 30000,
        distanceFilter: 20,
      );

      try {
        await _location.enableBackgroundMode(enable: true);
      } catch (_) {
        // Foreground tracking remains active when background mode is unavailable.
      }

      final initial = await _location.getLocation();
      await _pushLocation(initial, force: true);

      await _locationSubscription?.cancel();
      _locationSubscription = _location.onLocationChanged.listen((data) {
        _pushLocation(data);
      });
    } catch (_) {
      // Location failures must not block the driver from using the app.
    }
  }

  Future<void> _pushLocation(
    loc.LocationData data, {
    bool force = false,
  }) async {
    if (data.latitude == null || data.longitude == null) return;

    final availability =
        userBloc.state.driverGetMeData.data?.data?.availabilityStatus;
    if (availability == 'offline') return;

    final now = DateTime.now();
    if (!force &&
        _lastLocationSentAt != null &&
        now.difference(_lastLocationSentAt!) < _locationThrottle) {
      return;
    }
    _lastLocationSentAt = now;

    await getIt<PostLocationUseCases>()(
      PostLocationParams(
        latitude: data.latitude!,
        longitude: data.longitude!,
        accuracy: data.accuracy,
        speed: data.speed,
        heading: data.heading,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (homeCubit.state.selectedIndex != 0) {
          homeCubit.changeIndex(0);
          return false;
        }

        final shouldExit = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              contentPadding: const EdgeInsets.all(24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LocaleKeys.exitConfirmationTitle.tr(),
                    style: TextStyle(fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: Text(
                      LocaleKeys.exitConfirmationMessage.tr(),
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(LocaleKeys.ratingNo.tr()),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(
                            LocaleKeys.ratingYes.tr(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );

        return shouldExit ?? false;
      },
      child: BlocConsumer<HomeCubit, HomeState>(
        bloc: homeCubit,
        listenWhen: (pre, next) => pre.selectedIndex != next.selectedIndex,
        listener: (context, state) {
          pageController.jumpToPage(state.selectedIndex);
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(64),
              child: BlocBuilder<UserBloc, UserState>(
                bloc: userBloc,
                builder: (context, userState) {
                  final driverName =
                      userState.driverGetMeData.data?.data?.firstName ?? '-';
                  return _DriverTopAppBar(
                    title: _titleForIndex(state.selectedIndex, driverName),
                    avatarName: driverName,
                    onNotificationPressed: () => homeCubit.changeIndex(3),
                  );
                },
              ),
            ),
            body: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                NewHomeScreen(),
                DeliveryOrdersPage(),
                DriverFinancialPage(),
                NotificationScreen(),
                NewMoreScreen(),
              ],
            ),
            bottomNavigationBar: ShellBottomNavBar(
              selectedIndex: state.selectedIndex,
              onTap: homeCubit.changeIndex,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_locationSubscription?.cancel() ?? Future<void>.value());
    unawaited(_location.enableBackgroundMode(enable: false));
    pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_startLocationTracking());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: ThemeCollection.lightTheme.scaffoldBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    pageController = PageController();
    homeCubit = getIt<HomeCubit>();
    userBloc = getIt<UserBloc>();
    userBloc.add(DriverGetMeEvent());
    unawaited(_startLocationTracking());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (homeCubit.state.pendingNotificationData != null) {
        homeCubit.processPendingNotification();
      }
    });
  }
}
