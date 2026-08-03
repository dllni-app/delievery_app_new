import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../data/models/delivery_order_model.dart';
import '../cubit/delivery_cubit.dart';
import '../widgets/delivery_order_map.dart';
import '../widgets/delivery_widgets.dart';

class DeliveryOrderDetailsArgs {
  const DeliveryOrderDetailsArgs({required this.order});

  final DeliveryOrderModel order;
}

class DeliveryOrderDetailsPage extends StatefulWidget {
  const DeliveryOrderDetailsPage({super.key, required this.initialOrder});

  final DeliveryOrderModel initialOrder;

  @override
  State<DeliveryOrderDetailsPage> createState() =>
      _DeliveryOrderDetailsPageState();
}

class _DeliveryOrderDetailsPageState extends State<DeliveryOrderDetailsPage> {
  late final DeliveryCubit _deliveryCubit;
  late DeliveryOrderModel _displayedOrder;

  @override
  void initState() {
    super.initState();
    _deliveryCubit = getIt<DeliveryCubit>();
    _displayedOrder = widget.initialOrder;
    _deliveryCubit.loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeliveryCubit, DeliveryState>(
      bloc: _deliveryCubit,
      listenWhen: (previous, current) =>
          previous.currentOrder != current.currentOrder ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        final updatedOrder = state.currentOrder;
        if (updatedOrder != null && updatedOrder.id == _displayedOrder.id) {
          setState(() => _displayedOrder = updatedOrder);
        }

        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red.shade700,
              ),
            );
        }
      },
      builder: (context, state) {
        final currentOrder = state.currentOrder;
        final order = currentOrder != null && currentOrder.id == _displayedOrder.id
            ? currentOrder
            : _displayedOrder;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FA),
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: const Text(
              'تفاصيل الطلب',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            centerTitle: true,
          ),
          body: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _deliveryCubit.loadDashboard,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              children: [
                _OrderStatusCard(order: order),
                const SizedBox(height: 14),
                DeliveryOrderMap(order: order),
                const SizedBox(height: 14),
                _CustomerCard(order: order),
                const SizedBox(height: 14),
                _RouteCard(order: order),
                const SizedBox(height: 14),
                _OrderSummaryCard(order: order),
                if (order.events.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  _OrderTimelineCard(events: order.events),
                ],
              ],
            ),
          ),
          bottomNavigationBar: _OrderActionBar(
            order: order,
            isLoading: state.isActionLoading,
            onPressed: order.hasLifecycleAction
                ? () => _confirmAndPerformAction(order)
                : null,
          ),
        );
      },
    );
  }

  Future<void> _confirmAndPerformAction(DeliveryOrderModel order) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(order.nextActionLabel),
          content: Text(_actionConfirmationMessage(order)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('تراجع'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('تأكيد'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _deliveryCubit.performOrderAction(order);
    }
  }

  String _actionConfirmationMessage(DeliveryOrderModel order) {
    return switch (order.apiAction) {
      'start' => 'سيتم تحديث حالة الطلب بأنك بدأت التوجه إلى نقطة الاستلام.',
      'pickup' => 'أكد أنك استلمت الطلب من المتجر وأصبح معك الآن.',
      'deliver' => 'أكد أنك سلّمت الطلب إلى العميل في موقع التسليم.',
      _ => 'هل تريد تحديث حالة الطلب؟',
    };
  }
}

class _OrderStatusCard extends StatelessWidget {
  const _OrderStatusCard({required this.order});

  final DeliveryOrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _statusIcon(order.status),
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'طلب ${order.orderNumber}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.statusUi?.isNotEmpty == true
                          ? order.statusUi!
                          : deliveryStatusLabel(order.status),
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              DeliveryStatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _statusHint(order),
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetricChip(
                icon: Icons.payments_outlined,
                text: formatDeliveryMoney(order.deliveryFee, order.currency),
              ),
              _MetricChip(
                icon: Icons.route_outlined,
                text: order.distanceKm > 0
                    ? '${order.distanceKm} كم'
                    : 'المسافة غير متوفرة',
              ),
              if (order.merchantPreparation != null)
                _MetricChip(
                  icon: order.merchantPreparation!.isReady
                      ? Icons.check_circle_outline
                      : Icons.schedule_outlined,
                  text: order.merchantPreparation!.displayLabel,
                ),
            ],
          ),
        ],
      ),
    );
  }

  static IconData _statusIcon(String status) {
    return switch (status) {
      'accepted' => Icons.task_alt_rounded,
      'in_progress' => Icons.near_me_rounded,
      'picked_up' => Icons.inventory_2_rounded,
      'delivered' || 'completed' => Icons.check_circle_rounded,
      'cancelled' || 'rejected' => Icons.cancel_rounded,
      'stopped' => Icons.pause_circle_rounded,
      _ => Icons.local_shipping_rounded,
    };
  }

  static String _statusHint(DeliveryOrderModel order) {
    if (order.isPickupBlocked) {
      return 'يمكنك التوجه إلى المتجر، لكن تأكيد الاستلام يبقى مقفلاً حتى يعلن المتجر أن الطلب جاهز.';
    }

    return switch (order.status) {
      'accepted' => 'ابدأ الرحلة إلى نقطة الاستلام ثم حدّث الحالة عند التحرك.',
      'in_progress' => 'أنت في الطريق إلى نقطة الاستلام. أكد الاستلام بعد استلام الطلب من المتجر.',
      'picked_up' => 'الطلب معك الآن. اتبع الطريق إلى موقع العميل ثم أكد التسليم.',
      'delivered' => 'تم تسجيل تسليم الطلب إلى العميل.',
      'completed' => 'اكتملت دورة التوصيل لهذا الطلب.',
      'cancelled' => 'تم إلغاء الطلب ولا توجد إجراءات متاحة.',
      'stopped' => 'تم إيقاف الطلب ولا توجد إجراءات متاحة.',
      _ => 'تابع بيانات الطلب والمسار من هذه الشاشة.',
    };
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.order});

  final DeliveryOrderModel order;

  @override
  Widget build(BuildContext context) {
    return _DetailsCard(
      title: 'بيانات العميل',
      icon: Icons.person_outline_rounded,
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withValues(alpha: 0.08),
            child: const Icon(Icons.person, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.customerName.isEmpty
                      ? 'اسم العميل غير متوفر'
                      : order.customerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (order.customerPhone.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    order.customerPhone,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(color: Color(0xFF6B7280)),
                  ),
                ],
              ],
            ),
          ),
          if (order.customerPhone.isNotEmpty)
            IconButton.filledTonal(
              tooltip: 'اتصال بالعميل',
              onPressed: () => launchDeliveryPhoneCall(order.customerPhone),
              icon: const Icon(Icons.phone_rounded),
            ),
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.order});

  final DeliveryOrderModel order;

  @override
  Widget build(BuildContext context) {
    return _DetailsCard(
      title: 'عناوين الرحلة',
      icon: Icons.alt_route_rounded,
      child: Column(
        children: [
          DeliveryRoutePoint(
            icon: Icons.storefront_rounded,
            label: 'نقطة الاستلام',
            value: order.pickupAddress,
            trailing: IconButton(
              tooltip: 'فتح نقطة الاستلام في الخرائط',
              onPressed: order.pickupLatitude == 0 && order.pickupLongitude == 0
                  ? null
                  : () => launchDeliveryMap(
                        order.pickupLatitude,
                        order.pickupLongitude,
                      ),
              icon: const Icon(Icons.map_outlined),
            ),
          ),
          const Padding(
            padding: EdgeInsetsDirectional.only(start: 19),
            child: SizedBox(
              height: 26,
              child: VerticalDivider(width: 2, thickness: 1.5),
            ),
          ),
          DeliveryRoutePoint(
            icon: Icons.person_pin_circle_rounded,
            label: 'موقع العميل',
            value: order.dropoffAddress,
            trailing: IconButton(
              tooltip: 'فتح موقع العميل في الخرائط',
              onPressed: order.dropoffLatitude == 0 && order.dropoffLongitude == 0
                  ? null
                  : () => launchDeliveryMap(
                        order.dropoffLatitude,
                        order.dropoffLongitude,
                      ),
              icon: const Icon(Icons.map_outlined),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({required this.order});

  final DeliveryOrderModel order;

  @override
  Widget build(BuildContext context) {
    final timestamps = <({String label, DateTime? value})>[
      (label: 'وقت القبول', value: order.acceptedAt),
      (label: 'بدء التوجه', value: order.startedAt),
      (label: 'وقت الاستلام', value: order.pickedUpAt),
      (label: 'وقت التسليم', value: order.deliveredAt),
      (label: 'وقت الإكمال', value: order.completedAt),
    ].where((item) => item.value != null).toList();

    return _DetailsCard(
      title: 'ملخص الطلب',
      icon: Icons.receipt_long_outlined,
      child: Column(
        children: [
          _SummaryRow(
            label: 'أجرة التوصيل',
            value: formatDeliveryMoney(order.deliveryFee, order.currency),
          ),
          const Divider(height: 24),
          _SummaryRow(
            label: 'المسافة',
            value: order.distanceKm > 0
                ? '${order.distanceKm} كم'
                : 'غير متوفرة',
          ),
          for (final timestamp in timestamps) ...[
            const Divider(height: 24),
            _SummaryRow(
              label: timestamp.label,
              value: formatDeliveryDate(timestamp.value),
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF6B7280)),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class _OrderTimelineCard extends StatelessWidget {
  const _OrderTimelineCard({required this.events});

  final List<DeliveryOrderEventModel> events;

  @override
  Widget build(BuildContext context) {
    return _DetailsCard(
      title: 'سجل تحديثات الطلب',
      icon: Icons.history_rounded,
      child: Column(
        children: events.map((event) {
          final isLast = event == events.last;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 42,
                      color: const Color(0xFFE5E7EB),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deliveryStatusLabel(event.status),
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      if (event.createdAt != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          formatDeliveryDate(event.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 21),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _OrderActionBar extends StatelessWidget {
  const _OrderActionBar({
    required this.order,
    required this.isLoading,
    required this.onPressed,
  });

  final DeliveryOrderModel order;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    if (!order.hasLifecycleAction && !order.isPickupBlocked) {
      return const SizedBox.shrink();
    }

    final isBlocked = order.isPickupBlocked;
    return Material(
      color: Colors.white,
      elevation: 12,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: DeliveryPrimaryButton(
            label: isBlocked
                ? order.merchantPreparation?.displayLabel ??
                    'بانتظار جاهزية المتجر'
                : order.nextActionLabel,
            icon: isBlocked ? Icons.lock_clock_outlined : _actionIcon(order),
            onPressed: isBlocked || isLoading ? null : onPressed,
            isLoading: isLoading,
          ),
        ),
      ),
    );
  }

  IconData _actionIcon(DeliveryOrderModel order) {
    return switch (order.apiAction) {
      'start' => Icons.navigation_rounded,
      'pickup' => Icons.inventory_2_rounded,
      'deliver' => Icons.task_alt_rounded,
      _ => Icons.arrow_forward_rounded,
    };
  }
}
