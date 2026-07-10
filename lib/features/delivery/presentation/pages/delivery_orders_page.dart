import 'package:dllne_deliver_app/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/design/src/theme/const.dart';
import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../cubit/delivery_cubit.dart';
import '../widgets/delivery_widgets.dart';

class DeliveryOrdersPage extends StatefulWidget {
  const DeliveryOrdersPage({super.key});

  @override
  State<DeliveryOrdersPage> createState() => _DeliveryOrdersPageState();
}

class _DeliveryOrdersPageState extends State<DeliveryOrdersPage>
    with WidgetsBindingObserver {
  late final DeliveryCubit deliveryCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    deliveryCubit = getIt<DeliveryCubit>();
    deliveryCubit.loadDashboard();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      deliveryCubit.loadDashboard();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryCubit, DeliveryState>(
      bloc: deliveryCubit,
      builder: (context, state) {
        final order = state.currentOrder;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: deliveryCubit.loadDashboard,
          child: ListView(
            padding: PEdgeInsets.all,
            children: [
              if (order == null)
                const DeliveryEmptyState(
                  title: 'لا توجد طلبات نشطة',
                  message: 'عند قبول عرض توصيل سيظهر الطلب النشط هنا.',
                  icon: Icons.list_alt_outlined,
                )
              else ...[
                DeliveryOrderCard(
                  order: order,
                  isActionLoading: state.isActionLoading,
                  onAction: order.hasLifecycleAction
                      ? () => deliveryCubit.performOrderAction(order)
                      : null,
                ),
                if (order.isPickupBlocked) ...[
                  Space.vM2,
                  DeliveryPrimaryButton(
                    label: order.merchantPreparation?.displayLabel ??
                        'بانتظار جاهزية المتجر',
                    icon: Icons.lock_clock_outlined,
                    onPressed: null,
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}
