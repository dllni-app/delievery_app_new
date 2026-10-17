import 'dart:async';

import 'package:dllne_deliver_app/features/home/presentation/widgets/shell_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/exit_confirmation_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' as d;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart' as loc;

import '../../../../common/design/src/theme/theme/theme_collection.dart';
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
  StreamSubscription<UserState>? _availabilitySubscription;
  DateTime? _lastLocationSentAt;
  bool _isStartingLocationTracking = false;
  bool _backgroundLocationEnabled = false;
  bool _backgroundLocationWarningShown = false;
  static const _locationThrottle = Duration(seconds: 20);
  bool _isExitDialogVisible = false;

  // Use the same driver profile as the availability controls on the home page.
  // In particular, do not activate GPS for an offline driver.
  bool get _shouldTrackLocation {
    final status =
        userBloc.state.driverGetMeData.data?.data?.availabilityStatus;
    return status == 'available' || status == 'busy';
  }

  String _titleForIndex(int index, String driverName) {
    return switch (index) {
      1 => 'الطلبات',
      2 => 'المستحقات',
      3 => 'الإشعارات',
      4 => 'المزيد',
      _ => driverName,
    };
  }

  void _warnBackgroundLocationUnavailable() {
    if (_backgroundLocationWarningShown) return;
    _backgroundLocationWarningShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text(
            'تعذر تفعيل تتبع الموقع في الخلفية. تحقق من أذونات الموقع وإعدادات البطارية.',
          ),
        ),
      );
    });
  }

  Future<void> _enableBackgroundLocation() async {
    if (_backgroundLocationEnabled) return;
    try {
      // Android uses a location foreground service (with a persistent
      // notification) to keep collecting fixes after the app loses focus.
      _backgroundLocationEnabled =
          await _location.enableBackgroundMode(enable: true);
      if (!_backgroundLocationEnabled) {
        _warnBackgroundLocationUnavailable();
      }
    } catch (error) {
      debugPrint('Cannot enable background driver location: $error');
      _warnBackgroundLocationUnavailable();
    }
  }

  Future<void> _startLocationTracking() async {
    if (!mounted ||
        !_shouldTrackLocation ||
        _isStartingLocationTracking ||
        _locationSubscription != null) {
      return;
    }

    _isStartingLocationTracking = true;
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

      // Do not silently swallow failure: a foreground-only stream would stop
      // delivering reliable updates once the app is backgrounded.
      await _enableBackgroundLocation();
      if (!mounted || !_shouldTrackLocation) {
        await _stopLocationTracking();
        return;
      }

      _locationSubscription = _location.onLocationChanged.listen(
        (data) => unawaited(_pushLocation(data)),
        onError: (Object error) =>
            debugPrint('Driver location stream error: $error'),
      );

      final initial = await _location.getLocation();
      await _pushLocation(initial, force: true);
    } catch (error) {
      debugPrint('Unable to start driver location tracking: $error');
      if (_locationSubscription == null) {
        await _stopLocationTracking();
      }
    } finally {
      _isStartingLocationTracking = false;
    }
  }

  Future<void> _stopLocationTracking() async {
    final subscription = _locationSubscription;
    _locationSubscription = null;
    await subscription?.cancel();
    _lastLocationSentAt = null;
    if (_backgroundLocationEnabled) {
      _backgroundLocationEnabled = false;
      try {
        await _location.enableBackgroundMode(enable: false);
      } catch (error) {
        debugPrint('Unable to stop background driver location: $error');
      }
    }
  }

  Future<void> _refreshLocationOnResume() async {
    if (!_shouldTrackLocation) return;
    if (_locationSubscription == null) {
      await _startLocationTracking();
      return;
    }

    // Retry if the user has since enabled the necessary OS permissions.
    if (!_backgroundLocationEnabled) {
      await _enableBackgroundLocation();
    }
    try {
      await _pushLocation(await _location.getLocation(), force: true);
    } catch (error) {
      debugPrint('Unable to refresh driver location: $error');
    }
  }

  Future<void> _pushLocation(
    loc.LocationData data, {
    bool force = false,
  }) async {
    if (!mounted ||
        !_shouldTrackLocation ||
        data.latitude == null ||
        data.longitude == null) {
      return;
    }

    final now = DateTime.now();
    if (!force &&
        _lastLocationSentAt != null &&
        now.difference(_lastLocationSentAt!) < _locationThrottle) {
      return;
    }

    // A failed transmission should not suppress the following GPS fix.
    final result = await getIt<PostLocationUseCases>()(
      PostLocationParams(
        latitude: data.latitude!,
        longitude: data.longitude!,
        accuracy: data.accuracy,
        speed: data.speed,
        heading: data.heading,
      ),
    );
    result.fold(
      (failure) => debugPrint('Driver location upload failed: ${failure.message}'),
      (_) => _lastLocationSentAt = now,
    );
  }

  Future<void> _handleBackPressed() async {
    if (homeCubit.state.selectedIndex != 0) {
      homeCubit.changeIndex(0);
      return;
    }

    if (_isExitDialogVisible) return;
    _isExitDialogVisible = true;
    try {
      final shouldExit = await showExitConfirmationDialog(context);
      if (shouldExit && mounted) {
        await SystemNavigator.pop();
      }
    } finally {
      _isExitDialogVisible = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _handleBackPressed();
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
              children: [
                NewHomeScreen(sharedUserBloc: userBloc),
                const DeliveryOrdersPage(),
                const DriverFinancialPage(),
                const NotificationScreen(),
                const NewMoreScreen(),
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
    unawaited(_availabilitySubscription?.cancel() ?? Future<void>.value());
    unawaited(_stopLocationTracking());
    pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_refreshLocationOnResume());
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
    _availabilitySubscription = userBloc.stream.listen((_) {
      if (_shouldTrackLocation) {
        unawaited(_startLocationTracking());
      } else {
        unawaited(_stopLocationTracking());
      }
    });
    userBloc.add(DriverGetMeEvent());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (homeCubit.state.pendingNotificationData != null) {
        homeCubit.processPendingNotification();
      }
    });
  }
}
