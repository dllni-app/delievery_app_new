import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart' as loc;

import '../../../../router/route_names.dart';
import '../../data/driver_models.dart';
import '../cubit/driver_app_cubit.dart';
import '../widgets/driver_widgets.dart';

class DriverSplashScreen extends StatelessWidget {
  const DriverSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DriverAppCubit()..bootstrap(),
      child: BlocListener<DriverAppCubit, DriverAppState>(
        listenWhen: (previous, current) => previous.isBootstrapping != current.isBootstrapping && !current.isBootstrapping,
        listener: (context, state) {
          Navigator.of(context).pushNamedAndRemoveUntil(state.isAuthenticated ? RouteName.homeNav : RouteName.login, (_) => false);
        },
        child: const Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: kDriverBackground,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(radius: 42, backgroundColor: kDriverPrimaryContainer, child: Icon(Icons.delivery_dining, color: Colors.white, size: 44)),
                  SizedBox(height: 20),
                  Text('تطبيق المندوب', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: kDriverPrimary)),
                  SizedBox(height: 20),
                  CircularProgressIndicator(color: kDriverPrimary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});

  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DriverAppCubit(),
      child: BlocConsumer<DriverAppCubit, DriverAppState>(
        listenWhen: (previous, current) => previous.isAuthenticated != current.isAuthenticated || previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.errorMessage != null) _showSnack(context, state.errorMessage!);
          if (state.isAuthenticated) Navigator.of(context).pushNamedAndRemoveUntil(RouteName.homeNav, (_) => false);
        },
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: kDriverBackground,
              body: SafeArea(
                child: DriverLoadingOverlay(
                  isLoading: state.isLoading,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 40),
                          const CircleAvatar(radius: 46, backgroundColor: kDriverPrimaryContainer, child: Icon(Icons.delivery_dining, color: Colors.white, size: 46)),
                          const SizedBox(height: 18),
                          const Text('تسجيل الدخول', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: kDriverPrimary)),
                          const SizedBox(height: 8),
                          const Text('أدخل بيانات حساب المندوب للمتابعة', textAlign: TextAlign.center, style: TextStyle(color: kDriverMuted)),
                          const SizedBox(height: 28),
                          DriverCard(
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  textDirection: TextDirection.ltr,
                                  decoration: _inputDecoration('رقم الهاتف', Icons.phone),
                                  validator: (value) => value == null || value.trim().isEmpty ? 'رقم الهاتف مطلوب' : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscure,
                                  decoration: _inputDecoration('كلمة المرور', Icons.lock).copyWith(
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(() => _obscure = !_obscure),
                                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                                    ),
                                  ),
                                  validator: (value) => value == null || value.length < 6 ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل' : null,
                                ),
                                const SizedBox(height: 22),
                                DriverPrimaryButton(
                                  label: 'دخول',
                                  icon: Icons.login,
                                  isLoading: state.isLoading,
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() != true) return;
                                    context.read<DriverAppCubit>().login(phone: _phoneController.text.trim(), password: _passwordController.text);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DriverShellScreen extends StatelessWidget {
  const DriverShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DriverAppCubit()..loadDashboard(),
      child: BlocConsumer<DriverAppCubit, DriverAppState>(
        listenWhen: (previous, current) => previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.errorMessage != null) _showSnack(context, state.errorMessage!);
        },
        builder: (context, state) {
          final pages = const [
            DriverDashboardPage(),
            DriverOrdersPage(),
            DriverNotificationsPage(),
            DriverDisputesPage(),
            DriverMorePage(),
          ];
          return Directionality(
            textDirection: TextDirection.rtl,
            child: DriverLoadingOverlay(
              isLoading: state.isActionLoading,
              child: Scaffold(
                backgroundColor: kDriverBackground,
                appBar: AppBar(
                  backgroundColor: kDriverBackground,
                  elevation: 0,
                  title: Text(_titleForTab(state.currentTab), style: const TextStyle(color: kDriverPrimary, fontWeight: FontWeight.w800)),
                  actions: [IconButton(onPressed: () => context.read<DriverAppCubit>().changeTab(2), icon: const Icon(Icons.notifications_none, color: kDriverPrimary))],
                ),
                body: SafeArea(child: pages[state.currentTab]),
                bottomNavigationBar: NavigationBar(
                  selectedIndex: state.currentTab,
                  onDestinationSelected: context.read<DriverAppCubit>().changeTab,
                  backgroundColor: Colors.white,
                  indicatorColor: const Color(0xFFE3DFFF),
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
                    NavigationDestination(icon: Icon(Icons.list_alt_outlined), selectedIcon: Icon(Icons.list_alt), label: 'طلباتي'),
                    NavigationDestination(icon: Icon(Icons.notifications_none), selectedIcon: Icon(Icons.notifications), label: 'الإشعارات'),
                    NavigationDestination(icon: Icon(Icons.report_gmailerrorred_outlined), selectedIcon: Icon(Icons.report), label: 'البلاغات'),
                    NavigationDestination(icon: Icon(Icons.more_horiz), selectedIcon: Icon(Icons.more), label: 'المزيد'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DriverDashboardPage extends StatelessWidget {
  const DriverDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverAppCubit, DriverAppState>(
      builder: (context, state) {
        final driver = state.driver;
        final order = state.currentOrder;
        final offer = state.currentOffer;
        return RefreshIndicator(
          onRefresh: context.read<DriverAppCubit>().loadDashboard,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              DriverCard(
                child: Row(
                  children: [
                    const CircleAvatar(radius: 24, backgroundColor: kDriverPrimaryContainer, child: Icon(Icons.person, color: Colors.white)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(driver?.firstName.isNotEmpty == true ? driver!.firstName : 'مندوب التوصيل', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(driver?.phone ?? '', style: const TextStyle(color: kDriverMuted)),
                      ]),
                    ),
                    DriverStatusBadge(status: driver?.availabilityStatus ?? 'offline'),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _AvailabilityCard(currentStatus: driver?.availabilityStatus ?? 'offline'),
              const SizedBox(height: 14),
              _GpsCard(),
              const SizedBox(height: 18),
              Row(children: [
                Expanded(child: DriverMetricCard(icon: Icons.pending_actions, value: order == null ? '0' : '1', label: 'طلبات نشطة', color: kDriverAccent)),
                const SizedBox(width: 12),
                Expanded(child: DriverMetricCard(icon: Icons.account_balance_wallet, value: formatMoney(state.financialSummary?.currentBalance ?? 0, state.financialSummary?.currency ?? 'SYP'), label: 'الرصيد', color: kDriverPrimary)),
              ]),
              const SizedBox(height: 20),
              const Text('طلبات قريبة منك', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              if (offer != null) _OfferCard(offer: offer) else const DriverEmptyState(title: 'لا توجد عروض حالياً', message: 'عندما يصل طلب توصيل جديد سيظهر هنا مباشرة.', icon: Icons.radar),
              if (order != null) ...[
                const SizedBox(height: 18),
                const Text('الطلب النشط', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                DriverOrderCard(
                  order: order,
                  isActionLoading: state.isActionLoading,
                  onAction: () => context.read<DriverAppCubit>().performOrderAction(order),
                  onTap: () => _openOrderDetails(context, order),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class DriverOrdersPage extends StatelessWidget {
  const DriverOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverAppCubit, DriverAppState>(
      builder: (context, state) {
        final order = state.currentOrder;
        return RefreshIndicator(
          onRefresh: context.read<DriverAppCubit>().loadDashboard,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (order == null)
                const SizedBox(height: 160, child: DriverEmptyState(title: 'لا يوجد طلب نشط', message: 'سجل الطلبات الكامل يحتاج Endpoint منفصل من الباكند. حالياً يتم عرض الطلب النشط فقط.', icon: Icons.list_alt))
              else
                DriverOrderCard(
                  order: order,
                  isActionLoading: state.isActionLoading,
                  onAction: () => context.read<DriverAppCubit>().performOrderAction(order),
                  onTap: () => _openOrderDetails(context, order),
                ),
            ],
          ),
        );
      },
    );
  }
}

class DriverNotificationsPage extends StatelessWidget {
  const DriverNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverAppCubit, DriverAppState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () => context.read<DriverAppCubit>().loadNotifications(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SwitchListTile(
                value: state.unreadOnly,
                title: const Text('غير المقروءة فقط'),
                onChanged: (value) => context.read<DriverAppCubit>().loadNotifications(unreadOnly: value),
              ),
              if (state.notifications.isEmpty)
                const SizedBox(height: 160, child: DriverEmptyState(title: 'لا توجد إشعارات', message: 'ستظهر إشعارات الطلبات والتحديثات هنا.', icon: Icons.notifications_none))
              else
                ...state.notifications.map((notification) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DriverCard(
                        onTap: () => context.read<DriverAppCubit>().markNotificationRead(notification),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(notification.isRead ? Icons.notifications_none : Icons.notifications_active, color: kDriverPrimary),
                          title: Text(notification.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                          subtitle: Text(notification.body),
                          trailing: notification.createdAt == null ? null : Text(formatDate(notification.createdAt), style: const TextStyle(fontSize: 11, color: kDriverMuted)),
                        ),
                      ),
                    )),
            ],
          ),
        );
      },
    );
  }
}

class DriverDisputesPage extends StatelessWidget {
  const DriverDisputesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverAppCubit, DriverAppState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: context.read<DriverAppCubit>().loadDisputes,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (state.disputes.isEmpty)
                const SizedBox(height: 160, child: DriverEmptyState(title: 'لا توجد بلاغات', message: 'أي بلاغات مرتبطة بالطلبات ستظهر هنا.', icon: Icons.report_gmailerrorred_outlined))
              else
                ...state.disputes.map((dispute) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DriverCard(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [Expanded(child: Text(dispute.ticketNumber, style: const TextStyle(fontWeight: FontWeight.w900))), DriverStatusBadge(status: dispute.status)]),
                          const SizedBox(height: 8),
                          Text(dispute.category, style: const TextStyle(color: kDriverMuted)),
                          const SizedBox(height: 8),
                          Text(dispute.description),
                        ]),
                      ),
                    )),
            ],
          ),
        );
      },
    );
  }
}

class DriverMorePage extends StatelessWidget {
  const DriverMorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverAppCubit, DriverAppState>(
      builder: (context, state) {
        final driver = state.driver;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DriverCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('حساب المندوب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                _ProfileLine(label: 'الاسم', value: driver?.firstName ?? '-'),
                _ProfileLine(label: 'الهاتف', value: driver?.phone ?? '-'),
                _ProfileLine(label: 'المركبة', value: driver?.vehicleType ?? '-'),
                _ProfileLine(label: 'اللوحة', value: driver?.plateNumber ?? '-'),
              ]),
            ),
            const SizedBox(height: 16),
            DriverPrimaryButton(label: 'تسجيل الخروج', icon: Icons.logout, isDanger: true, onPressed: context.read<DriverAppCubit>().logout),
          ],
        );
      },
    );
  }
}

class DriverOrderDetailsPage extends StatelessWidget {
  const DriverOrderDetailsPage({super.key, required this.order});
  final DeliveryOrderModel order;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kDriverBackground,
        appBar: AppBar(title: Text('طلب ${order.orderNumber}'), backgroundColor: kDriverBackground),
        body: BlocBuilder<DriverAppCubit, DriverAppState>(
          builder: (context, state) {
            final current = state.currentOrder?.id == order.id ? state.currentOrder! : order;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DriverCard(child: Row(children: [Expanded(child: Text(current.orderNumber, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900))), DriverStatusBadge(status: current.status)])),
                const SizedBox(height: 14),
                DriverCard(child: Column(children: [
                  DriverRoutePoint(icon: Icons.storefront, label: 'نقطة الاستلام', value: current.pickupAddress, trailing: IconButton(icon: const Icon(Icons.near_me, color: kDriverPrimary), onPressed: () => launchMap(current.pickupLatitude, current.pickupLongitude))),
                  const SizedBox(height: 12),
                  DriverRoutePoint(icon: Icons.location_on, label: 'نقطة التسليم', value: current.dropoffAddress, trailing: IconButton(icon: const Icon(Icons.near_me, color: kDriverPrimary), onPressed: () => launchMap(current.dropoffLatitude, current.dropoffLongitude))),
                ])),
                const SizedBox(height: 14),
                DriverCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('بيانات العميل', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  _ProfileLine(label: 'الاسم', value: current.customerName),
                  _ProfileLine(label: 'الهاتف', value: current.customerPhone),
                  const SizedBox(height: 10),
                  DriverPrimaryButton(label: 'اتصال بالعميل', icon: Icons.call, onPressed: current.customerPhone.isEmpty ? null : () => launchPhoneCall(current.customerPhone)),
                ])),
                const SizedBox(height: 14),
                DriverCard(child: Row(children: [Expanded(child: _ProfileLine(label: 'المسافة', value: '${current.distanceKm} كم')), Expanded(child: _ProfileLine(label: 'الأجرة', value: formatMoney(current.deliveryFee, current.currency)))])),
                if (current.hasLifecycleAction) ...[
                  const SizedBox(height: 20),
                  DriverPrimaryButton(label: current.nextActionLabel, icon: Icons.arrow_back, isLoading: state.isActionLoading, onPressed: () => context.read<DriverAppCubit>().performOrderAction(current)),
                ],
              ],
            );
          },
        ),
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
    return DriverCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Expanded(child: Text('طلب توصيل جديد', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900))), DriverStatusBadge(status: offer.isExpired ? 'expired' : offer.status)]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: DriverMetricCard(icon: Icons.route, value: '${offer.distanceToPickupKm}', label: 'كم للاستلام', color: kDriverSecondary)),
          const SizedBox(width: 10),
          Expanded(child: DriverMetricCard(icon: Icons.payments, value: formatMoney(order?.deliveryFee ?? 0, order?.currency ?? 'SYP'), label: 'الأجرة', color: kDriverPrimary)),
        ]),
        const SizedBox(height: 14),
        DriverRoutePoint(icon: Icons.storefront, label: 'نقطة الاستلام', value: order?.pickupAddress ?? 'غير محدد'),
        const SizedBox(height: 10),
        DriverRoutePoint(icon: Icons.location_on, label: 'نقطة التسليم', value: order?.dropoffAddress ?? 'غير محدد'),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: DriverPrimaryButton(label: 'رفض', icon: Icons.close, isDanger: true, isOutlined: true, onPressed: () => _showRejectSheet(context, offer))),
          const SizedBox(width: 12),
          Expanded(child: DriverPrimaryButton(label: 'قبول', icon: Icons.check, onPressed: offer.isExpired ? null : () => _showAcceptSheet(context, offer))),
        ]),
      ]),
    );
  }
}

class _AvailabilityCard extends StatelessWidget {
  const _AvailabilityCard({required this.currentStatus});
  final String currentStatus;

  @override
  Widget build(BuildContext context) {
    return DriverCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('حالة التوفر', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: [
          _StatusChoice(label: 'متاح', value: 'available', current: currentStatus),
          _StatusChoice(label: 'مشغول', value: 'busy', current: currentStatus),
          _StatusChoice(label: 'غير متصل', value: 'offline', current: currentStatus),
        ]),
      ]),
    );
  }
}

class _StatusChoice extends StatelessWidget {
  const _StatusChoice({required this.label, required this.value, required this.current});
  final String label;
  final String value;
  final String current;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(label: Text(label), selected: value == current, onSelected: (_) => context.read<DriverAppCubit>().updateAvailability(value));
  }
}

class _GpsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DriverCard(
      child: Row(children: [
        const Icon(Icons.my_location, color: kDriverSuccess),
        const SizedBox(width: 12),
        const Expanded(child: Text('تحديث موقعك الحالي', style: TextStyle(fontWeight: FontWeight.w700))),
        TextButton(onPressed: () => _postCurrentLocation(context), child: const Text('تحديث')),
      ]),
    );
  }
}

class _ProfileLine extends StatelessWidget {
  const _ProfileLine({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [Text(label, style: const TextStyle(color: kDriverMuted)), const Spacer(), Flexible(child: Text(value.isEmpty ? '-' : value, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w700)))]),
    );
  }
}

InputDecoration _inputDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    filled: true,
    fillColor: const Color(0xFFF8F9FA),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
  );
}

String _titleForTab(int index) {
  switch (index) {
    case 0:
      return 'الرئيسية';
    case 1:
      return 'طلباتي';
    case 2:
      return 'الإشعارات';
    case 3:
      return 'البلاغات';
    default:
      return 'المزيد';
  }
}

void _openOrderDetails(BuildContext context, DeliveryOrderModel order) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => BlocProvider.value(value: context.read<DriverAppCubit>(), child: DriverOrderDetailsPage(order: order))));
}

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
}

Future<void> _postCurrentLocation(BuildContext context) async {
  final location = loc.Location();
  var enabled = await location.serviceEnabled();
  if (!enabled) enabled = await location.requestService();
  if (!enabled) {
    if (context.mounted) _showSnack(context, 'فعّل خدمة الموقع أولاً');
    return;
  }

  var permission = await location.hasPermission();
  if (permission == loc.PermissionStatus.denied) permission = await location.requestPermission();
  if (permission != loc.PermissionStatus.granted) {
    if (context.mounted) _showSnack(context, 'إذن الموقع مطلوب لتحديث موقعك');
    return;
  }

  final data = await location.getLocation();
  if (!context.mounted || data.latitude == null || data.longitude == null) return;
  await context.read<DriverAppCubit>().postLocation(latitude: data.latitude!, longitude: data.longitude!, accuracy: data.accuracy, speed: data.speed, heading: data.heading);
  if (context.mounted) _showSnack(context, 'تم تحديث الموقع');
}

void _showAcceptSheet(BuildContext context, DeliveryAssignmentAttemptModel offer) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('قبول طلب التوصيل؟', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('سيتم تعيين الطلب لك وتبدأ رحلة التوصيل.'),
          const SizedBox(height: 20),
          DriverPrimaryButton(label: 'تأكيد القبول', icon: Icons.check, onPressed: () {
            Navigator.pop(context);
            context.read<DriverAppCubit>().acceptOffer(offer);
          }),
        ]),
      ),
    ),
  );
}

void _showRejectSheet(BuildContext context, DeliveryAssignmentAttemptModel offer) {
  final controller = TextEditingController();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20 + MediaQuery.of(context).viewInsets.bottom),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('سبب رفض الطلب', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          TextField(controller: controller, maxLines: 3, decoration: _inputDecoration('اكتب السبب', Icons.edit_note)),
          const SizedBox(height: 20),
          DriverPrimaryButton(label: 'إرسال الرفض', icon: Icons.close, isDanger: true, onPressed: () {
            Navigator.pop(context);
            context.read<DriverAppCubit>().rejectOffer(offer, controller.text);
          }),
        ]),
      ),
    ),
  ).whenComplete(controller.dispose);
}
