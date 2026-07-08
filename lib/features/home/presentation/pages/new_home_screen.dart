import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/snck_bars.dart';
import '../../../delivery/data/models/delivery_offer_model.dart';
import '../../../delivery/presentation/cubit/delivery_cubit.dart';
import '../../../delivery/presentation/pages/delivery_dashboard_page.dart';
import '../../../delivery/presentation/widgets/delivery_widgets.dart';
import '../../../financial/presentation/cubit/financial_cubit.dart';
import '../../../user/domain/use_cases/update_availability_use_cases.dart';
import '../../../user/presentation/bloc/user_bloc.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({super.key});

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _AvailabilityStateRow extends StatelessWidget {
  final String value;
  final String currentValue;
  final IconData icon;
  final Color selectedColor;
  final String label;
  final String subtitle;
  final bool isUpdating;

  const _AvailabilityStateRow({
    required this.value,
    required this.currentValue,
    required this.icon,
    required this.selectedColor,
    required this.label,
    required this.subtitle,
    required this.isUpdating,
  });

  @override
  Widget build(BuildContext context) {
    final inactiveColor = const Color(0xFFE1E3E4);
    final inactiveIconColor = const Color(0xFFC6C5D3);
    final subtitleColor = const Color(0xFF454651);
    final isSelected = currentValue == value;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isUpdating
            ? null
            : () {
                context.read<UserBloc>().add(
                  UpdateAvailabilityEvent(
                    params: UpdateAvailabilityParams(availabilityStatus: value),
                  ),
                );
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? selectedColor : inactiveColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : inactiveIconColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? selectedColor : subtitleColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF454651),
                      ),
                    ),
                  ],
                ),
              ),
              Radio<String>(
                value: value,
                groupValue: currentValue,
                activeColor: selectedColor,
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return selectedColor;
                  }
                  return inactiveIconColor;
                }),
                onChanged: isUpdating
                    ? null
                    : (_) {
                        context.read<UserBloc>().add(
                          UpdateAvailabilityEvent(
                            params: UpdateAvailabilityParams(
                              availabilityStatus: value,
                            ),
                          ),
                        );
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceWideCard extends StatelessWidget {
  const _BalanceWideCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinancialCubit, FinancialState>(
      bloc: getIt<FinancialCubit>(),
      builder: (context, financialState) {
        final summary = financialState.summary;
        final value = formatDeliveryMoney(
          summary?.currentBalance ?? 0,
          summary?.currency ?? 'SYP',
        );

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.account_balance_wallet, color: Colors.white),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'الرصيد المستحق',
                style: TextStyle(fontSize: 14, color: Color(0xFFD9DBFF)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GpsRefreshButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _GpsRefreshButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.18),
            width: 0.8,
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.refresh_rounded, size: 16, color: AppColors.primary),
            SizedBox(width: 6),
            Text(
              'تحديث',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewAvailabilityCard extends StatelessWidget {
  const _NewAvailabilityCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        final currentStatus =
            state.driverGetMeData.data?.data?.availabilityStatus ?? 'offline';
        final isUpdating = state.updateAvailabilityData.isLoading;
        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _AvailabilityStateRow(
                    value: 'available',
                    currentValue: currentStatus,
                    icon: Icons.directions_car,
                    selectedColor: AppColors.primary,
                    label: 'متاح لاستقبال الطلبات',
                    subtitle: 'أنت متصل بالشبكة',
                    isUpdating: isUpdating,
                  ),
                  const SizedBox(height: 10),
                  _AvailabilityStateRow(
                    value: 'busy',
                    currentValue: currentStatus,
                    icon: Icons.local_activity,
                    selectedColor: AppColors.secondary,
                    label: 'مشغول',
                    subtitle: 'أنت مشغول حالياً',
                    isUpdating: isUpdating,
                  ),
                  const SizedBox(height: 10),
                  _AvailabilityStateRow(
                    value: 'offline',
                    currentValue: currentStatus,
                    icon: Icons.wifi_off_outlined,
                    selectedColor: Colors.redAccent,
                    label: 'غير متصل',
                    subtitle: 'أنت غير متصل بالشبكة',
                    isUpdating: isUpdating,
                  ),
                ],
              ),
            ),
            if (isUpdating)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _NewGpsStatusCard extends StatelessWidget {
  const _NewGpsStatusCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          right: BorderSide(color: Color(0xFF4CAF50), width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.my_location, color: Color(0xFF4CAF50)),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'تحديث موقعك الحالي',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            _GpsRefreshButton(
              onPressed: () async {
                showSnack(context, "يتم تحديث موقعك الحالي...");
                await postCurrentLocation(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NewHomeScreenState extends State<NewHomeScreen> {
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
                showSnack(
                  context,
                  state.errorMessage!,
                  type: SnackBarType.failure,
                );
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
                onFailed: () => showSnack(
                  context,
                  state.updateAvailabilityData.errorMessage,
                  type: SnackBarType.failure,
                ),
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
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                children: const [
                  _NewAvailabilityCard(),
                  SizedBox(height: 8),
                  _NewGpsStatusCard(),
                  SizedBox(height: 16),
                  _NewSummarySection(),
                  SizedBox(height: 16),
                  _NewNearbyOrdersSection(),
                ],
              ),
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

class _NewNearbyOrdersSection extends StatelessWidget {
  const _NewNearbyOrdersSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryCubit, DeliveryState>(
      bloc: getIt<DeliveryCubit>(),
      builder: (context, deliveryState) {
        final offer = deliveryState.currentOffer;
        final isActionLoading = deliveryState.isActionLoading;

        Future<void> refresh() async {
          await getIt<DeliveryCubit>().loadDashboard();
          await getIt<FinancialCubit>().loadSummary();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'طلبات قريبة منك',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                TextButton(
                  onPressed: isActionLoading
                      ? null
                      : () async {
                          showSnack(context, "يتم تحديث الطلبات...");
                          await refresh();
                        },
                  child: const Text(
                    'تحديث',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SizedBox(
                height: 220,
                width: double.infinity,
                child: offer == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Color(0xFFF3F4F5),
                            child: Icon(
                              Icons.location_off_outlined,
                              size: 32,
                              color: Color(0xFFC6C5D3),
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'لا يوجد طلبات حالياً',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28),
                            child: Text(
                              'نحن نبحث عن طلبات جديدة بالقرب منك، يرجى الانتظار.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF454651),
                              ),
                            ),
                          ),
                        ],
                      )
                    : _NewOfferPreview(
                        offer: offer,
                        isActionLoading: isActionLoading,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NewOfferPreview extends StatelessWidget {
  final DeliveryAssignmentAttemptModel offer;
  final bool isActionLoading;

  const _NewOfferPreview({required this.offer, required this.isActionLoading});

  @override
  Widget build(BuildContext context) {
    final order = offer.order;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'طلب توصيل جديد',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ),
              DeliveryStatusBadge(
                status: offer.isExpired ? 'expired' : offer.status,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DeliveryMetricCard(
                  icon: Icons.route,
                  value: offer.distanceToPickupLabel,
                  label: 'كم للاستلام',
                ),
              ),
              const SizedBox(width: 8),
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
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: DeliveryPrimaryButton(
                  label: 'رفض',
                  icon: Icons.close,
                  isDanger: true,
                  isOutlined: true,
                  onPressed: () => _showRejectSheet(context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DeliveryPrimaryButton(
                  label: 'قبول',
                  icon: Icons.check,
                  onPressed: offer.isExpired
                      ? null
                      : () => _showAcceptSheet(context),
                  isLoading: isActionLoading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAcceptSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'قبول طلب التوصيل؟',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              const Text('سيتم تعيين الطلب لك وتبدأ رحلة التوصيل.'),
              const SizedBox(height: 16),
              DeliveryPrimaryButton(
                label: 'تأكيد القبول',
                icon: Icons.check,
                onPressed: () {
                  Navigator.pop(context);
                  getIt<DeliveryCubit>().acceptOffer(offer);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRejectSheet(BuildContext context) {
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
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'اكتب السبب',
                  prefixIcon: const Icon(Icons.edit_note),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DeliveryPrimaryButton(
                label: 'إرسال الرفض',
                icon: Icons.close,
                isDanger: true,
                onPressed: () {
                  Navigator.pop(sheetContext);
                  getIt<DeliveryCubit>().rejectOffer(offer, controller.text);
                },
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(controller.dispose);
  }
}

class _NewSummarySection extends StatelessWidget {
  const _NewSummarySection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryCubit, DeliveryState>(
      bloc: getIt<DeliveryCubit>(),
      builder: (context, deliveryState) {
        final order = deliveryState.currentOrder;

        // "Active" mirrors the old dashboard logic: order exists => 1 else 0.
        final activeValue = order == null ? '0' : '1';

        // "Completed" uses the order's status (if API returns completed order).
        final completedValue =
            (order?.status == 'completed' || order?.completedAt != null)
            ? '1'
            : '0';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ملخص اليوم',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: .95,
              children: [
                _StatSquareCard(
                  icon: Icons.task_alt,
                  iconColor: AppColors.primary,
                  value: completedValue,
                  label: 'الطلبات المكتملة',
                ),
                _StatSquareCard(
                  icon: Icons.pending_actions,
                  iconColor: AppColors.accent,
                  value: activeValue,
                  label: 'الطلبات النشطة',
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _BalanceWideCard(),
            const SizedBox(height: 16),
            const _ReportsWideCard(),
          ],
        );
      },
    );
  }
}

class _ReportsWideCard extends StatelessWidget {
  const _ReportsWideCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryCubit, DeliveryState>(
      bloc: getIt<DeliveryCubit>(),
      builder: (context, deliveryState) {
        final count = deliveryState.disputes.length.toString();

        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              const Icon(
                Icons.report_problem_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'البلاغات المفتوحة',
                  style: TextStyle(fontSize: 14, color: Color(0xFF454651)),
                ),
              ),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatSquareCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatSquareCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF454651)),
          ),
        ],
      ),
    );
  }
}
