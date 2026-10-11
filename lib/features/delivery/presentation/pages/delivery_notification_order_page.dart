import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../data/data_sources/delivery_remote_data.dart';
import '../../data/models/delivery_order_model.dart';
import 'delivery_order_details_page.dart';

/// Opens the exact order referenced by a driver notification, even when
/// the order is no longer the driver's current active order.
class DeliveryNotificationOrderPage extends StatefulWidget {
  const DeliveryNotificationOrderPage({super.key, required this.orderId});

  final int orderId;

  @override
  State<DeliveryNotificationOrderPage> createState() =>
      _DeliveryNotificationOrderPageState();
}

class _DeliveryNotificationOrderPageState
    extends State<DeliveryNotificationOrderPage> {
  late Future<DeliveryOrderModel> _order;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _order = getIt<DeliveryRemoteData>().getOrderById(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DeliveryOrderModel>(
      future: _order,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DeliveryOrderDetailsPage(initialOrder: snapshot.data!);
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF3F4F6),
          appBar: AppBar(
            title: const Text('تفاصيل الطلب'),
            centerTitle: true,
            foregroundColor: AppColors.primary,
            backgroundColor: Colors.white,
          ),
          body: SafeArea(
            child: Center(
              child: snapshot.hasError
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.info_outline,
                            size: 44, color: AppColors.primary),
                          const SizedBox(height: 12),
                          const Text(
                            'تعذر تحميل بيانات هذا الطلب. تأكد أن الطلب مرتبط بحسابك وحاول مجدداً.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () => setState(_load),
                            icon: const Icon(Icons.refresh),
                            label: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    )
                  : const CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
            ),
          ),
        );
      },
    );
  }
}
