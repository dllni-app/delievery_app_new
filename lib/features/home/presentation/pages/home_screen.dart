import 'dart:async';

import 'package:dllne_deliver_app/core/utils/snck_bars.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../delivery/presentation/cubit/delivery_cubit.dart';
import '../../../delivery/presentation/pages/delivery_dashboard_page.dart';
import '../../../delivery/presentation/widgets/delivery_widgets.dart';
import '../../../financial/presentation/cubit/financial_cubit.dart';
import '../../../user/domain/use_cases/post_location_use_cases.dart';
import '../../../user/presentation/bloc/user_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late final UserBloc userBloc;
  final loc.Location _location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  DateTime? _lastLocationSentAt;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: userBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<DeliveryCubit, DeliveryState>(
            bloc: getIt<DeliveryCubit>(),
            listenWhen: (previous, current) =>
                previous.errorMessage != current.errorMessage,
            listener: (context, state) {
              if (state.errorMessage != null) {
                showSnack(
                  context,
                  state.errorMessage!,
                  type: SnackBarType.failure,
                );
              }
            },
          ),
          BlocListener<UserBloc, UserState>(
            listenWhen: (previous, current) =>
                previous.updateAvailabilityData.status !=
                current.updateAvailabilityData.status,
            listener: (context, state) {
              state.updateAvailabilityData.listenerFunction(
                onSuccess: () => getIt<DeliveryCubit>().loadDashboard(),
              );
            },
          ),
        ],
        child: BlocBuilder<DeliveryCubit, DeliveryState>(
          bloc: getIt<DeliveryCubit>(),
          builder: (context, state) {
            return DeliveryLoadingOverlay(
              isLoading: state.isActionLoading,
              child: const DeliveryDashboardPage(),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    userBloc = getIt<UserBloc>()..add(DriverGetMeEvent());
    getIt<DeliveryCubit>().loadDashboard();
    getIt<FinancialCubit>().loadSummary();
    unawaited(_startLocationTracking());
  }

  Future<void> _startLocationTracking() async {
    var serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
    }
    if (!serviceEnabled) return;

    var permission = await _location.hasPermission();
    if (permission == loc.PermissionStatus.denied) {
      permission = await _location.requestPermission();
    }
    if (permission != loc.PermissionStatus.granted &&
        permission != loc.PermissionStatus.grantedLimited) {
      return;
    }

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

    await _locationSubscription?.cancel();
    _locationSubscription = _location.onLocationChanged.listen(
      _sendLocationIfDue,
      onError: (_) {},
    );

    try {
      _sendLocationIfDue(await _location.getLocation(), force: true);
    } catch (_) {}
  }

  void _sendLocationIfDue(loc.LocationData data, {bool force = false}) {
    if (data.latitude == null || data.longitude == null) return;

    final now = DateTime.now();
    if (!force &&
        _lastLocationSentAt != null &&
        now.difference(_lastLocationSentAt!) < const Duration(seconds: 25)) {
      return;
    }
    _lastLocationSentAt = now;

    userBloc.add(
      PostLocationEvent(
        params: PostLocationParams(
          latitude: data.latitude!,
          longitude: data.longitude!,
          accuracy: data.accuracy,
          speed: data.speed,
          heading: data.heading,
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getIt<DeliveryCubit>().loadDashboard();
      unawaited(_startLocationTracking());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_locationSubscription?.cancel());
    unawaited(_location.enableBackgroundMode(enable: false));
    super.dispose();
  }
}
