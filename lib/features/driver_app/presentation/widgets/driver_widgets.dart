import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/driver_models.dart';

const Color kDriverPrimary = Color(0xFF021064);
const Color kDriverPrimaryContainer = Color(0xFF1E2A78);
const Color kDriverSecondary = Color(0xFF4D41DF);
const Color kDriverAccent = Color(0xFFF77600);
const Color kDriverSuccess = Color(0xFF009688);
const Color kDriverError = Color(0xFFBA1A1A);
const Color kDriverBackground = Color(0xFFF8F9FA);
const Color kDriverSurface = Colors.white;
const Color kDriverText = Color(0xFF191C1D);
const Color kDriverMuted = Color(0xFF767682);

class DriverCard extends StatelessWidget {
  const DriverCard({super.key, required this.child, this.padding = const EdgeInsets.all(20), this.color = kDriverSurface, this.onTap});

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(24),
      shadowColor: Colors.black.withOpacity(.08),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class DriverPrimaryButton extends StatelessWidget {
  const DriverPrimaryButton({super.key, required this.label, required this.onPressed, this.icon, this.isLoading = false, this.isDanger = false, this.isOutlined = false});

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isDanger;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? kDriverError : kDriverPrimaryContainer;
    final child = isLoading
        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

class DriverStatusBadge extends StatelessWidget {
  const DriverStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'available' || 'completed' || 'delivered' => kDriverSuccess,
      'busy' || 'offered' || 'accepted' || 'in_progress' || 'picked_up' => kDriverAccent,
      'offline' || 'cancelled' || 'rejected' => kDriverError,
      _ => kDriverSecondary,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(.12), borderRadius: BorderRadius.circular(999)),
      child: Text(statusLabel(status), style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }
}

class DriverMetricCard extends StatelessWidget {
  const DriverMetricCard({super.key, required this.icon, required this.value, required this.label, this.color = kDriverPrimary});

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DriverCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: kDriverText)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 13, color: kDriverMuted)),
        ],
      ),
    );
  }
}

class DriverEmptyState extends StatelessWidget {
  const DriverEmptyState({super.key, required this.title, required this.message, this.icon = Icons.inbox_outlined, this.onRetry});

  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return DriverCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 34, backgroundColor: const Color(0xFFF3F4F5), child: Icon(icon, size: 34, color: kDriverMuted)),
          const SizedBox(height: 16),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: kDriverMuted)),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            TextButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('تحديث')),
          ],
        ],
      ),
    );
  }
}

class DriverOrderCard extends StatelessWidget {
  const DriverOrderCard({super.key, required this.order, this.onTap, this.onAction, this.isActionLoading = false});

  final DeliveryOrderModel order;
  final VoidCallback? onTap;
  final VoidCallback? onAction;
  final bool isActionLoading;

  @override
  Widget build(BuildContext context) {
    return DriverCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('طلب ${order.orderNumber}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
              DriverStatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: 14),
          DriverRoutePoint(icon: Icons.storefront, label: 'نقطة الاستلام', value: order.pickupAddress),
          const Padding(
            padding: EdgeInsetsDirectional.only(start: 19),
            child: SizedBox(height: 18, child: VerticalDivider(width: 2, thickness: 1.2, color: Color(0xFFC6C5D3))),
          ),
          DriverRoutePoint(icon: Icons.location_on, label: 'نقطة التسليم', value: order.dropoffAddress),
          const SizedBox(height: 14),
          Row(
            children: [
              _SmallInfo(icon: Icons.route, text: '${order.distanceKm} كم'),
              const SizedBox(width: 12),
              _SmallInfo(icon: Icons.payments, text: formatMoney(order.deliveryFee, order.currency)),
            ],
          ),
          if (order.hasLifecycleAction && onAction != null) ...[
            const SizedBox(height: 16),
            DriverPrimaryButton(label: order.nextActionLabel, icon: Icons.arrow_back, onPressed: onAction, isLoading: isActionLoading),
          ],
        ],
      ),
    );
  }
}

class DriverRoutePoint extends StatelessWidget {
  const DriverRoutePoint({super.key, required this.icon, required this.label, required this.value, this.trailing});

  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(radius: 20, backgroundColor: const Color(0xFFE1E3E4), child: Icon(icon, size: 20, color: kDriverPrimary)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: kDriverMuted)),
              const SizedBox(height: 3),
              Text(value.isEmpty ? 'غير محدد' : value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class DriverLoadingOverlay extends StatelessWidget {
  const DriverLoadingOverlay({super.key, required this.isLoading, required this.child});

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
              child: const Center(child: CircularProgressIndicator(color: kDriverPrimary)),
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
      decoration: BoxDecoration(color: const Color(0xFFF3F4F5), borderRadius: BorderRadius.circular(999)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 16, color: kDriverMuted), const SizedBox(width: 6), Text(text, style: const TextStyle(fontWeight: FontWeight.w600))]),
    );
  }
}

String statusLabel(String status) {
  switch (status) {
    case 'available':
      return 'متاح';
    case 'busy':
      return 'مشغول';
    case 'offline':
      return 'غير متصل';
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
    case 'open':
      return 'مفتوح';
    case 'resolved':
      return 'محلول';
    default:
      return status.isEmpty ? 'غير محدد' : status;
  }
}

String formatMoney(num value, String currency) {
  final formatter = NumberFormat.decimalPattern('ar');
  return '${formatter.format(value)} $currency';
}

String formatDate(DateTime? date) {
  if (date == null) return '';
  return DateFormat('yyyy/MM/dd - HH:mm', 'ar').format(date.toLocal());
}

Future<void> launchPhoneCall(String phone) async {
  final uri = Uri(scheme: 'tel', path: phone);
  if (await canLaunchUrl(uri)) await launchUrl(uri);
}

Future<void> launchMap(num latitude, num longitude) async {
  if (latitude == 0 && longitude == 0) return;
  final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
  if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
}
