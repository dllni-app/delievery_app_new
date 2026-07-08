import 'package:dllne_deliver_app/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/design/src/theme/const.dart';
import '../../../../common/extensions/src/context_extensions.dart';
import '../cubit/delivery_cubit.dart';
import '../widgets/delivery_widgets.dart';

class DeliveryOrdersPage extends StatefulWidget {



  @override
  State<DeliveryOrdersPage> createState() => _DeliveryOrdersPageState();
}

class _DeliveryOrdersPageState extends State<DeliveryOrdersPage> {

  late final  DeliveryCubit  deliveryCubit;

  @override
  void initState() {

    deliveryCubit=getIt<DeliveryCubit>();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryCubit, DeliveryState>(
      bloc: deliveryCubit,
      builder: (context, state) {
        final order = state.currentOrder;

        return RefreshIndicator(
          color: context.primarySwatch,
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
              else
                DeliveryOrderCard(
                  order: order,
                  isActionLoading: state.isActionLoading,
                  onAction: () =>
                      deliveryCubit.performOrderAction(order),
                ),
            ],
          ),
        );
      },
    );
  }
}
