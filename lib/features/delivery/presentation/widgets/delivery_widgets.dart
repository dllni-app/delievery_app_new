import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/design/src/theme/const.dart';
import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../data/models/delivery_order_model.dart';

class DeliveryCard extends StatelessWidget {
  const DeliveryCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(24),
      shadowColor: Colors.black.withOpacity(.08),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(padding: padding ?? PEdgeInsets.all, child: child),
      ),
    );
  }
}

class DeliveryPrimaryButton extends StatelessWidget {
  const DeliveryPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isDanger = false,
    this.isOutlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isDanger;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? Colors.red : AppColors.primary;
    final child = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: isOutlined ? color : Colors.white,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 20), Space.hS3],
              Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          );

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          foregroundColor: color,
          side: BorderSide(color: color, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: child,
      );
    }

    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: child,
    );
  }
}

class DeliveryStatusBadge extends StatelessWidget {
  const DeliveryStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'available' ||
      'completed' ||
      'delivered' ||
      'COMPLETED' =>
        const Color(0xFF15803D),
      'busy' ||
      'offered' ||
      'open' ||
      'accepted' ||
      'in_progress' ||
      'picked_up' ||
      'waiting_merchant_ready' ||
      'searching_for_driver' ||
      'dispatching' ||
      'WAITING_ACCEPTANCE' ||
      'ACTIVE' =>
        const Color(0xFFD97706),
      'offline' ||
      'cancelled' ||
      'rejected' ||
      'expired' ||
      'REJECTED' =>
        const Color(0xFFB91C1C),
      _ => AppColors.primary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        deliveryStatusLabel(status),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class DeliveryMetricCard extends StatelessWidget {
  const DeliveryMetricCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    var displayValue = value;
    if (label == 'كم للاستلام') {
      final distance = num.tryParse(value);
      if (distance == null || distance <= 0) {
        displayValue = 'غير متوفرة';
      }
    }

    return DeliveryCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color ?? AppColors.primary),
          Space.vL1,
          Text(
            displayValue,
            style: TextStyle(
              fontSize: displayValue.length > 8 ? 16 : 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          Space.vS2,
          const SizedBox.shrink(),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class DeliveryEmptyState extends StatelessWidget {
  const DeliveryEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.onRetry,
  });

  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return DeliveryCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: Colors.grey.shade300,
            child: Icon(icon, size: 34, color: Colors.black),
          ),
          Space.vM2,
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17),
          ),
          Space.vS3,
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black),
          ),
          if (onRetry != null) ...[
            Space.vM2,
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('تحديث'),
            ),
          ],
        ],
      ),
    );
  }
}

class DeliveryOrderCard extends StatelessWidget {
  const DeliveryOrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.onAction,
    this.isActionLoading = false,
  });

  final DeliveryOrderModel order;
  final VoidCallback? onTap;
  final VoidCallback? onAction;
  final bool isActionLoading;

  @override
  Widget build(BuildContext context) {
    return DeliveryCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .055),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.local_shipping_outlined,
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
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        order.statusUi?.isNotEmpty == true
                            ? order.statusUi!
                            : deliveryStatusLabel(order.status),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                DeliveryStatusBadge(status: order.status),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Column(
              children: [
                DeliveryRoutePoint(
                  icon: Icons.storefront_rounded,
                  label: 'نقطة الاستلام',
                  value: order.pickupAddress,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 19),
                  child: SizedBox(
                    height: 24,
                    child: VerticalDivider(
                      width: 2,
                      thickness: 1.5,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
                DeliveryRoutePoint(
                  icon: Icons.person_pin_circle_rounded,
                  label: 'موقع العميل',
                  value: order.dropoffAddress,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SmallInfo(
                  icon: Icons.route_outlined,
                  text: order.distanceKm <= 0
                      ? 'المسافة غير متوفرة'
                      : '${order.distanceKm} كم',
                ),
                _SmallInfo(
                  icon: Icons.payments_outlined,
                  text: formatDeliveryMoney(order.deliveryFee, order.currency),
                ),
                if (order.merchantPreparation != null)
                  _SmallInfo(
                    icon: order.merchantPreparation!.isReady
                        ? Icons.check_circle_outline
                        : Icons.schedule_outlined,
                    text: order.merchantPreparation!.displayLabel,
                  ),
              ],
            ),
          ),
          if (order.hasLifecycleAction && onAction != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: DeliveryPrimaryButton(
                label: order.nextActionLabel,
                icon: Icons.arrow_back,
                onPressed: onAction,
                isLoading: isActionLoading,
              ),
            ),
          ],
          if (onTap != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'عرض تفاصيل الطلب والمسار',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 15,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class DeliveryRoutePoint extends StatelessWidget {
  const DeliveryRoutePoint({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFFF1F5F9),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        Space.hM1,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
              Space.vS2,
              Text(
                value.isEmpty ? 'غير محدد' : value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class DeliveryLoadingOverlay extends StatelessWidget {
  const DeliveryLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black.withOpacity(.08),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          ),
      ],
    );
  }
}

class _SmallInfo extends StatelessWidget {
  const _SmallInfo({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          Space.hS2,
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}

String deliveryStatusLabel(String status) {
  switch (status) {
    case 'available':
      return 'متاح';
    case 'busy':
      return 'مشغول';
    case 'offline':
      return 'غير متصل';
    case 'waiting_merchant_ready':
      return 'بانتظار جاهزية المتجر';
    case 'searching_for_driver':
    case 'dispatching':
      return 'جاري البحث عن مندوب';
    case 'offered':
      return 'معروض';
    case 'accepted':
      return 'مقبول';
    case 'in_progress':
      return 'قيد التنفيذ';
    case 'picked_up':
      return 'تم الاستلام';
    case 'delivered':
      return 'تم التسليم';
    case 'completed':
      return 'مكتمل';
    case 'cancelled':
      return 'ملغي';
    case 'stopped':
      return 'متوقف';
    case 'rejected':
      return 'مرفوض';
    case 'expired':
      return 'منتهي';
    case 'open':
      return 'متاح حتى القبول أو الإلغاء';
    case 'resolved':
      return 'محلول';
    case 'WAITING_ACCEPTANCE':
      return 'بانتظار القبول';
    case 'ACTIVE':
      return 'نشط';
    case 'COMPLETED':
      return 'مكتمل';
    case 'REJECTED':
      return 'مرفوض';
    default:
      return status.isEmpty ? 'غير محدد' : status;
  }
}

String formatDeliveryMoney(num value, String currency) {
  final formatter = NumberFormat.decimalPattern('ar');
  return '${formatter.format(value)} $currency';
}

String formatDeliveryDate(DateTime? date) {
  if (date == null) return '';
  return DateFormat('yyyy/MM/dd - HH:mm', 'ar').format(date.toLocal());
}

Future<void> launchDeliveryPhoneCall(String phone) async {
  final uri = Uri(scheme: 'tel', path: phone);
  if (await canLaunchUrl(uri)) await launchUrl(uri);
}

Future<void> launchDeliveryMap(num latitude, num longitude) async {
  if (latitude == 0 && longitude == 0) return;
  final uri = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
  );
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
