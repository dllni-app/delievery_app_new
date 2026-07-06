import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/unified_api/dio/api_client.dart';
import '../../data/driver_models.dart';
import '../../data/driver_optional_api_service.dart';
import '../widgets/driver_widgets.dart';
import 'driver_pages.dart';

class DriverOrderHistoryPage extends StatefulWidget {
  const DriverOrderHistoryPage({super.key, this.activeOrder});

  final DeliveryOrderModel? activeOrder;

  @override
  State<DriverOrderHistoryPage> createState() => _DriverOrderHistoryPageState();
}

class _DriverOrderHistoryPageState extends State<DriverOrderHistoryPage> {
  late final DriverOptionalApiService _service;
  late Future<List<DeliveryOrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _service = DriverOptionalApiService(getIt<ApiClient>());
    _ordersFuture = _loadOrders();
  }

  Future<List<DeliveryOrderModel>> _loadOrders() async {
    final orders = await _service.getOrders(perPage: 20);
    final activeOrder = widget.activeOrder;
    if (orders.isNotEmpty || activeOrder == null) return orders;
    return [activeOrder];
  }

  Future<void> _refresh() async {
    setState(() => _ordersFuture = _loadOrders());
    await _ordersFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DeliveryOrderModel>>(
      future: _ordersFuture,
      builder: (context, snapshot) {
        final orders = snapshot.data ?? const <DeliveryOrderModel>[];
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final error = snapshot.error;

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (isLoading)
                const SizedBox(height: 180, child: Center(child: CircularProgressIndicator(color: kDriverPrimary)))
              else if (error != null)
                const SizedBox(
                  height: 180,
                  child: DriverEmptyState(
                    title: 'تعذر تحميل سجل الطلبات',
                    message: 'اسحب للأسفل لإعادة المحاولة. إذا كان endpoint السجل غير مفعّل بعد سيبقى الطلب النشط متاحاً من الرئيسية.',
                    icon: Icons.error_outline,
                  ),
                )
              else if (orders.isEmpty)
                const SizedBox(
                  height: 180,
                  child: DriverEmptyState(
                    title: 'لا توجد طلبات',
                    message: 'ستظهر الطلبات النشطة والسابقة هنا عند توفرها من الباكند.',
                    icon: Icons.list_alt,
                  ),
                )
              else
                ...orders.map(
                  (order) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: DriverOrderCard(
                      order: order,
                      isActionLoading: false,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => DriverOrderDetailsPage(order: order)),
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
