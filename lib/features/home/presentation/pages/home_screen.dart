import 'package:dllne_deliver_app/core/utils/snck_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../delivery/presentation/cubit/delivery_cubit.dart';
import '../../../delivery/presentation/pages/delivery_dashboard_page.dart';
import '../../../delivery/presentation/widgets/delivery_widgets.dart';
import '../../../financial/presentation/cubit/financial_cubit.dart';
import '../../../user/presentation/bloc/user_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: userBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<DeliveryCubit, DeliveryState>(
            bloc: getIt<DeliveryCubit>(),
            listenWhen: (p, c) => p.errorMessage != c.errorMessage,
            listener: (context, state) {
              if (state.errorMessage != null) {
                showSnack(context, state.errorMessage!, type: SnackBarType.failure);
              }
            },
          ),
          BlocListener<UserBloc, UserState>(
            listenWhen: (p, c) =>
                p.updateAvailabilityData.status !=
                    c.updateAvailabilityData.status ||
                p.postLocationData.status != c.postLocationData.status,
            listener: (context, state) {
              state.updateAvailabilityData.listenerFunction(
                onSuccess: () => getIt<DeliveryCubit>().loadDashboard(),
              );
              state.postLocationData.listenerFunction(
                onSuccess: () => showSnack(
                  context,
                  'تم تحديث الموقع',
                  type: SnackBarType.success,
                ),
                onFailed: () => showSnack(
                  context,
                  state.postLocationData.errorMessage,
                  type: SnackBarType.failure,
                ),
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
    userBloc = getIt<UserBloc>()..add(DriverGetMeEvent());
    getIt<DeliveryCubit>().loadDashboard();
    getIt<FinancialCubit>().loadSummary();
    super.initState();
  }
}
