import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/design/src/theme/const.dart';
import '../../../../common/extensions/src/context_extensions.dart';
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
      color: color ?? context.surfaceColor,
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
    final color = isDanger ? context.errorColor : context.primarySwatch;
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
        context.successColor,
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
        context.warningColor,
      'offline' ||
      'cancelled' ||
      'rejected' ||
      'expired' ||
      'REJECTED' =>
        context.errorColor,
      _ => context.primarySwatch,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        deliveryStatusLabel(status),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
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
          Icon(icon, color: color ?? context.primarySwatch),
          Space.vL1,
          Text(
            displayValue,
            style: context.headlineSmall(
              fontSize: displayValue.length > 8 ? 16 : 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          Space.vS2,
          Text(
            label,
            style: TextStyle(fontSize: 13, color: context.onSurfaceVariantColor),
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
            backgroundColor: context.surfaceVariantColor,
            child: Icon(icon, size: 34, color: context.onSurfaceVariantColor),
          ),
          Space.vM2,
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.headlineSmall(fontSize: 17),
          ),
          Space.vS3,
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.onSurfaceVariantColor),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'طلب ${order.orderNumber}',
                  style: context.headlineSmall(fontSize: 18),
                ),
              ),
              DeliveryStatusBadge(status: order.statusUi ?? order.status),
            ],
          ),
          Space.vM1,
          DeliveryRoutePoint(
            icon: Icons.storefront,
            label: 'نقطة الاستلام',
            value: order.pickupAddress,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 19),
            child: SizedBox(
              height: 18,
              child: VerticalDivider(
                width: 2,
                thickness: 1.2,
                color: context.onSurfaceVariantColor.withOpacity(.4),
              ),
            ),
          ),
          DeliveryRoutePoint(
            icon: Icons.location_on,
            label: 'نقطة التسليم',
            value: order.dropoffAddress,
          ),
          Space.vM1,
          Row(
            children: [
              _SmallInfo(
                icon: Icons.route,
                text: order.distanceKm <= 0
                    ? 'المسافة غير متوفرة'
                    : '${order.distanceKm} كم',
              ),
              Space.hM1,
              _SmallInfo(
                icon: Icons.payments,
                text: formatDeliveryMoney(order.deliveryFee, order.currency),
              ),
            ],
          ),
          if (order.hasLifecycleAction && onAction != null) ...[
            Space.vM2,
            DeliveryPrimaryButton(
              label: order.nextActionLabel,
              icon: Icons.arrow_back,
              onPressed: onAction,
              isLoading: isActionLoading,
            ),
          ],
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
          backgroundColor: context.surfaceVariantColor,
          child: Icon(icon, size: 20, color: context.primarySwatch),
        ),
        Space.hM1,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: context.onSurfaceVariantColor,
                ),
              ),
              Space.vS2,
              Text(
                value.isEmpty ? 'غير محدد' : value,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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
              child: Center(
                child: CircularProgressIndicator(color: context.primarySwatch),
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
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: context.onSurfaceVariantColor),
          Space.hS2,
          Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
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
