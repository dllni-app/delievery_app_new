import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart' as loc;

import '../../../../common/design/src/theme/const.dart';
import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../financial/presentation/cubit/financial_cubit.dart';
import '../../../user/domain/use_cases/post_location_use_cases.dart';
import '../../../user/domain/use_cases/update_availability_use_cases.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../data/models/delivery_offer_model.dart';
import '../cubit/delivery_cubit.dart';
import '../widgets/delivery_widgets.dart';

InputDecoration _inputDecoration(
  BuildContext context,
  String label,
  IconData icon,
) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: AppColors.primary),
    filled: true,
    fillColor: Colors.grey.shade300,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  );
}

Future<void> postCurrentLocation(BuildContext context) async {
  final userBloc = context.read<UserBloc>();
  final location = loc.Location();
  var enabled = await location.serviceEnabled();
  if (!enabled) enabled = await location.requestService();
  if (!enabled) return;

  var permission = await location.hasPermission();
  if (permission == loc.PermissionStatus.denied) {
    permission = await location.requestPermission();
  }
  if (permission != loc.PermissionStatus.granted) return;

  final data = await location.getLocation();
  if (!context.mounted || data.latitude == null || data.longitude == null) {
    return;
  }

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

void _showAcceptSheet(
  BuildContext context,
  DeliveryAssignmentAttemptModel offer,
) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: PEdgeInsets.all,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'قبول طلب التوصيل؟',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Space.vS3,
            const Text(
              'يمكنك قبول الطلب والتوجه إلى المتجر قبل اكتمال التجهيز، '
              'لكن الاستلام يبقى مقفلاً حتى يحدد المتجر أن الطلب جاهز.',
            ),
            Space.vM3,
            DeliveryPrimaryButton(
              label: 'تأكيد القبول',
              icon: Icons.check,
              onPressed: () {
                Navigator.pop(context);
                context.read<DeliveryCubit>().acceptOffer(offer);
              },
            ),
          ],
        ),
      ),
    ),
  );
}

void _showRejectSheet(
  BuildContext context,
  DeliveryAssignmentAttemptModel offer,
) {
  final controller = TextEditingController();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 20 + MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'سبب رفض الطلب',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Space.vM1,
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: _inputDecoration(
                sheetContext,
                'اكتب السبب',
                Icons.edit_note,
              ),
            ),
            Space.vM3,
            DeliveryPrimaryButton(
              label: 'إرسال الرفض',
              icon: Icons.close,
              isDanger: true,
              onPressed: () {
                Navigator.pop(sheetContext);
                context.read<DeliveryCubit>().rejectOffer(
                      offer,
                      controller.text,
                    );
              },
            ),
          ],
        ),
      ),
    ),
  ).whenComplete(controller.dispose);
}

class DeliveryDashboardPage extends StatelessWidget {
  const DeliveryDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryCubit, DeliveryState>(
      bloc: getIt<DeliveryCubit>(),
      builder: (context, state) {
        final order = state.currentOrder;
        final offer = state.currentOffer;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await getIt<DeliveryCubit>().loadDashboard();
            getIt<FinancialCubit>().loadSummary();
            if (context.mounted) {
              context.read<UserBloc>().add(DriverGetMeEvent());
            }
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              const _DriverProfileCard(),
              Space.vM2,
              const _AvailabilityCard(),
              Space.vM2,
              const _GpsCard(),
              Space.vM2,
              Row(
                children: [
                  Expanded(
                    child: DeliveryMetricCard(
                      icon: Icons.pending_actions,
                      value: order == null ? '0' : '1',
                      label: 'طلبات نشطة',
                      color: Colors.yellow,
                    ),
                  ),
                  Space.hM1,
                  Expanded(
                    child: BlocBuilder<FinancialCubit, FinancialState>(
                      bloc: getIt<FinancialCubit>(),
                      builder: (context, financialState) {
                        final summary = financialState.summary;
                        return DeliveryMetricCard(
                          icon: Icons.account_balance_wallet,
                          value: formatDeliveryMoney(
                            summary?.currentBalance ?? 0,
                            summary?.currency ?? 'SYP',
                          ),
                          label: 'الرصيد',
                        );
                      },
                    ),
                  ),
                ],
              ),
              Space.vM3,
              Text(
                'طلبات قريبة منك',
                style: TextStyle(fontSize: 18),
              ),
              Space.vS3,
              if (offer != null)
                _OfferCard(offer: offer)
              else
                const DeliveryEmptyState(
                  title: 'لا توجد عروض حالياً',
                  message: 'عندما يصل طلب توصيل جديد سيظهر هنا مباشرة.',
                  icon: Icons.radar,
                ),
              if (order != null) ...[
                Space.vM3,
                Text('الطلب النشط', style: TextStyle(fontSize: 18)),
                Space.vS3,
                DeliveryOrderCard(
                  order: order,
                  isActionLoading: state.isActionLoading,
                  onAction: order.hasLifecycleAction
                      ? () => getIt<DeliveryCubit>().performOrderAction(order)
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

class _DriverProfileCard extends StatelessWidget {
  const _DriverProfileCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        final driver = state.driverGetMeData.data?.data;

        return DeliveryCard(
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade300,
                child: Icon(Icons.person, color: AppColors.primary),
              ),
              Space.hM1,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver?.firstName.isNotEmpty == true
                          ? driver!.firstName
                          : 'مندوب التوصيل',
                      style: TextStyle(fontSize: 18),
                    ),
                    Space.vS1,
                    Text(
                      driver?.phone ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              if (driver != null)
                DeliveryStatusBadge(status: driver.availabilityStatus),
            ],
          ),
        );
      },
    );
  }
}

class _AvailabilityCard extends StatelessWidget {
  const _AvailabilityCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        final status =
            state.driverGetMeData.data?.data?.availabilityStatus ?? 'offline';

        return DeliveryCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('حالة التوفر', style: TextStyle(fontSize: 17)),
              Space.vM1,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _StatusChoice(
                    label: 'متاح',
                    value: 'available',
                    current: status,
                  ),
                  _StatusChoice(
                    label: 'مشغول',
                    value: 'busy',
                    current: status,
                  ),
                  _StatusChoice(
                    label: 'غير متصل',
                    value: 'offline',
                    current: status,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusChoice extends StatelessWidget {
  const _StatusChoice({
    required this.label,
    required this.value,
    required this.current,
  });

  final String label;
  final String value;
  final String current;

  @override
  Widget build(BuildContext context) {
    final selected = current == value;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: Colors.grey.shade300,
      onSelected: (_) {
        context.read<UserBloc>().add(
              UpdateAvailabilityEvent(
                params: UpdateAvailabilityParams(availabilityStatus: value),
              ),
            );
      },
    );
  }
}

class _GpsCard extends StatelessWidget {
  const _GpsCard();

  @override
  Widget build(BuildContext context) {
    return DeliveryCard(
      child: Row(
        children: [
          Icon(Icons.my_location, color: Colors.green),
          Space.hM1,
          Expanded(
            child: Text(
              'تحديث موقعك الحالي',
              style: TextStyle(fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () => postCurrentLocation(context),
            child: Text(
              'تحديث',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.offer});

  final DeliveryAssignmentAttemptModel offer;

  @override
  Widget build(BuildContext context) {
    final order = offer.order;
    return DeliveryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'طلب توصيل جديد',
                  style: TextStyle(fontSize: 19),
                ),
              ),
              DeliveryStatusBadge(
                status: offer.isExpired ? 'expired' : offer.status,
              ),
            ],
          ),
          Space.vM1,
          Row(
            children: [
              Expanded(
                child: DeliveryMetricCard(
                  icon: Icons.route,
                  value: '${offer.distanceToPickupKm}',
                  label: 'كم للاستلام',
                ),
              ),
              Space.hS3,
              Expanded(
                child: DeliveryMetricCard(
                  icon: Icons.payments,
                  value: formatDeliveryMoney(
                    order?.deliveryFee ?? 0,
                    order?.currency ?? 'SYP',
                  ),
                  label: 'الأجرة',
                ),
              ),
            ],
          ),
          Space.vM1,
          DeliveryRoutePoint(
            icon: Icons.storefront,
            label: 'نقطة الاستلام',
            value: order?.pickupAddress ?? 'غير محدد',
          ),
          Space.vS3,
          DeliveryRoutePoint(
            icon: Icons.location_on,
            label: 'نقطة التسليم',
            value: order?.dropoffAddress ?? 'غير محدد',
          ),
          Space.vM2,
          Row(
            children: [
              Expanded(
                child: DeliveryPrimaryButton(
                  label: 'رفض',
                  icon: Icons.close,
                  isDanger: true,
                  isOutlined: true,
                  onPressed: () => _showRejectSheet(context, offer),
                ),
              ),
              Space.hM1,
              Expanded(
                child: DeliveryPrimaryButton(
                  label: 'قبول',
                  icon: Icons.check,
                  onPressed: offer.isExpired
                      ? null
                      : () => _showAcceptSheet(context, offer),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
