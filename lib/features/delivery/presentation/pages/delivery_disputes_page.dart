import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/design/src/theme/const.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../cubit/delivery_cubit.dart';
import '../widgets/delivery_widgets.dart';

class DeliveryDisputesPage extends StatefulWidget {
  const DeliveryDisputesPage({super.key});
  @override
  State<DeliveryDisputesPage> createState() => _DeliveryDisputesPageState();
}

class _DeliveryDisputesPageState extends State<DeliveryDisputesPage> {
  late final DeliveryCubit deliveryCubit;

  @override
  void initState() {
    deliveryCubit = getIt<DeliveryCubit>();
    deliveryCubit.loadDisputes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryCubit, DeliveryState>(
      bloc: deliveryCubit,
      builder: (context, state) {
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: deliveryCubit.loadDisputes,
          child: ListView(
            padding: PEdgeInsets.all,
            children: [
              if (state.isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 48),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              else if (state.disputes.isEmpty)
                const DeliveryEmptyState(
                  title: 'لا توجد بلاغات',
                  message: 'أي بلاغات مرتبطة بالطلبات ستظهر هنا.',
                  icon: Icons.report_gmailerrorred_outlined,
                )
              else
                ...state.disputes.map(
                  (dispute) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: DeliveryCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  dispute.ticketNumber,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              DeliveryStatusBadge(status: dispute.status),
                            ],
                          ),
                          Space.vS3,
                          Text(
                            dispute.category,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Space.vS3,
                          Text(dispute.description),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
