import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart' as loc;

import '../../../../router/app_router.dart';
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
                          const SizedBox(height: 28),
                          const CircleAvatar(radius: 44, backgroundColor: kDriverPrimaryContainer, child: Icon(Icons.delivery_dining, color: Colors.white, size: 44)),
                          const SizedBox(height: 18),
                          const Text('تسجيل الدخول', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: kDriverPrimary)),
                          const SizedBox(height: 8),
                          const Text('أدخل بيانات حساب المندوب للمتابعة', textAlign: TextAlign.center, style: TextStyle(color: kDriverMuted)),
                          const SizedBox(height: 32),
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
        listenWhen: (previous, current) => previous.errorMessage != current.errorMessage || previous.isAuthenticated != current.isAuthenticated,
        listener: (context, state) {
          if (state.errorMessage != null) _showSnack(context, state.errorMessage!);
          if (!state.isAuthenticated && state.driver == null) Navigator.of(context).pushNamedAndRemoveUntil(RouteName.login, (_) => false);
        },
        builder: (context, state) {
          final pages = <Widget>[
            const DriverDashboardPage(),
            const DriverOrdersPage(),
            const DriverNotificationsPage(),
            const DriverDisputesPage(),
            const DriverMorePage(),
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
                  actions: [
                    IconButton(onPressed: () => context.read<DriverAppCubit>().changeTab(2), icon: const Icon(Icons.notifications_none, color: kDriverPrimary)),
                  ],
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(driver?.firstName.isNotEmpty == true ? driver!.firstName : 'مندوب التوصيل', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text(driver?.phone ?? '', style: const TextStyle(color: kDriverMuted)),
                        ],
                      ),
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
              const Text('ملخص اليوم', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  DriverMetricCard(icon: Icons.task_alt, value: order?.status == 'completed' ? '1' : '0', label: 'طلبات مكتملة', color: kDriverSuccess),
                  DriverMetricCard(icon: Icons.pending_actions, value: order == null ? '0' : '1', label: 'طلبات نشطة', color: kDriverAccent),
                ],
              ),
              const SizedBox(height: 12),
              DriverCard(
                color: kDriverPrimaryContainer,
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formatMoney(state.financialSummary?.currentBalance ?? 0, state.financialSummary?.currency ?? 'SYP'), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 4),
                          const Text('الرصيد المستحق', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(child: Text('طلبات قريبة منك', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
                  TextButton(onPressed: context.read<DriverAppCubit>().loadDashboard, child: const Text('تحديث')),
                ],
              ),
              if (offer != null)
                _OfferCard(offer: offer)
              else
                const DriverEmptyState(title: 'لا توجد عروض حالياً', message: 'عندما يصل طلب توصيل جديد سيظهر هنا مباشرة.', icon: Icons.radar),
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
                const SizedBox(height: 120, child: DriverEmptyState(title: 'لا يوجد طلب نشط', message: 'سجل الطلبات الكامل يحتاج Endpoint منفصل من الباكند. حالياً يتم عرض الطلب النشط فقط.', icon: Icons.list_alt))
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
              Row(
                children: [
                  FilterChip(label: const Text('الكل'), selected: !state.unreadOnly, onSelected: (_) => context.read<DriverAppCubit>().loadNotifications(unreadOnly: false)),
                  const SizedBox(width: 8),
                  FilterChip(label: const Text('غير المقروء'), selected: state.unreadOnly, onSelected: (_) => context.read<DriverAppCubit>().loadNotifications(unreadOnly: true)),
                ],
              ),
              const SizedBox(height: 12),
              if (state.notifications.isEmpty)
                const SizedBox(height: 180, child: DriverEmptyState(title: 'لا توجد إشعارات', message: 'سيتم عرض إشعارات الطلبات والتنبيهات هنا.', icon: Icons.notifications_none))
              else
                ...state.notifications.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DriverCard(
                        onTap: item.isRead ? null : () => context.read<DriverAppCubit>().markNotificationRead(item),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(backgroundColor: item.isRead ? const Color(0xFFE1E3E4) : const Color(0xFFE3DFFF), child: Icon(item.isRead ? Icons.notifications_none : Icons.notifications_active, color: kDriverPrimary)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 4),
                                  Text(item.body, style: const TextStyle(color: kDriverMuted)),
                                  if (item.createdAt != null) ...[
                                    const SizedBox(height: 6),
                                    Text(formatDate(item.createdAt), style: const TextStyle(fontSize: 12, color: kDriverMuted)),
                                  ],
                                ],
                              ),
                            ),
                          ],
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
                const SizedBox(height: 180, child: DriverEmptyState(title: 'لا توجد بلاغات', message: 'أي بلاغ مرتبط بطلباتك سيظهر هنا.', icon: Icons.report_gmailerrorred))
              else
                ...state.disputes.map((dispute) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DriverCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [Expanded(child: Text(dispute.ticketNumber.isEmpty ? 'بلاغ #${dispute.id}' : dispute.ticketNumber, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17))), DriverStatusBadge(status: dispute.status)]),
                            const SizedBox(height: 10),
                            Text(dispute.category, style: const TextStyle(color: kDriverPrimary, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 6),
                            Text(dispute.description, style: const TextStyle(color: kDriverMuted)),
                            if (dispute.resolution != null) ...[
                              const Divider(height: 22),
                              Text('الحل: ${dispute.resolution}', style: const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ],
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

class DriverMorePage extends StatelessWidget {
  const DriverMorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverAppCubit, DriverAppState>(
      builder: (context, state) {
        final driver = state.driver;
        final financial = state.financialSummary;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DriverCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(radius: 28, backgroundColor: kDriverPrimaryContainer, child: Icon(Icons.person, color: Colors.white, size: 32)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(driver?.firstName ?? 'مندوب التوصيل', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), Text(driver?.phone ?? '', style: const TextStyle(color: kDriverMuted))]),
                      ),
                    ],
                  ),
                  const Divider(height: 28),
                  _ProfileLine(label: 'نوع المركبة', value: driver?.vehicleType ?? '-'),
                  _ProfileLine(label: 'رقم اللوحة', value: driver?.plateNumber ?? '-'),
                  _ProfileLine(label: 'نقاط الثقة', value: '${driver?.trustScore ?? 0}'),
                  _ProfileLine(label: 'البلاغات المفتوحة', value: '${driver?.openDisputesCount ?? 0}'),
                  if (financial?.isSuspended == true) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: kDriverError.withOpacity(.1), borderRadius: BorderRadius.circular(16)),
                      child: Row(children: [const Icon(Icons.warning_amber, color: kDriverError), const SizedBox(width: 8), Expanded(child: Text(financial?.suspensionReason ?? 'الحساب موقوف مالياً', style: const TextStyle(color: kDriverError, fontWeight: FontWeight.w700)))]),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            DriverCard(
              child: Column(
                children: [
                  _MenuTile(icon: Icons.account_balance_wallet, title: 'المستحقات', onTap: () => context.read<DriverAppCubit>().changeTab(0)),
                  _MenuTile(icon: Icons.notifications, title: 'الإشعارات', onTap: () => context.read<DriverAppCubit>().changeTab(2)),
                  _MenuTile(icon: Icons.report, title: 'البلاغات', onTap: () => context.read<DriverAppCubit>().changeTab(3)),
                  const Divider(height: 8),
                  _MenuTile(icon: Icons.logout, title: 'تسجيل الخروج', color: kDriverError, onTap: () => _confirmLogout(context)),
                ],
              ),
            ),
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
        appBar: AppBar(backgroundColor: kDriverBackground, elevation: 0, title: const Text('تفاصيل الطلب', style: TextStyle(color: kDriverPrimary, fontWeight: FontWeight.w800))),
        body: BlocBuilder<DriverAppCubit, DriverAppState>(
          builder: (context, state) {
            final current = state.currentOrder?.id == order.id ? state.currentOrder! : order;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DriverCard(
                  child: Row(children: [Expanded(child: Text('طلب ${current.orderNumber}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900))), DriverStatusBadge(status: current.status)]),
                ),
                const SizedBox(height: 14),
                DriverCard(
                  child: Column(children: [
                    _StepLine(label: 'قبول الطلب', isDone: current.acceptedAt != null, isActive: current.status == 'accepted' || current.status == 'offered'),
                    _StepLine(label: 'الذهاب للاستلام', isDone: current.startedAt != null, isActive: current.status == 'in_progress'),
                    _StepLine(label: 'تأكيد الاستلام', isDone: current.pickedUpAt != null, isActive: current.status == 'picked_up'),
                    _StepLine(label: 'تأكيد التسليم', isDone: current.deliveredAt != null || current.completedAt != null, isActive: current.status == 'delivered'),
                  ]),
                ),
                const SizedBox(height: 14),
                DriverCard(
                  child: Column(children: [
                    DriverRoutePoint(icon: Icons.storefront, label: 'نقطة الاستلام', value: current.pickupAddress, trailing: IconButton(icon: const Icon(Icons.near_me, color: kDriverPrimary), onPressed: () => launchMap(current.pickupLatitude, current.pickupLongitude))),
                    const SizedBox(height: 12),
                    DriverRoutePoint(icon: Icons.location_on, label: 'نقطة التسليم', value: current.dropoffAddress, trailing: IconButton(icon: const Icon(Icons.near_me, color: kDriverPrimary), onPressed: () => launchMap(current.dropoffLatitude, current.dropoffLongitude))),
                  ]),
                ),
                const SizedBox(height: 14),
                DriverCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('بيانات العميل', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    _ProfileLine(label: 'الاسم', value: current.customerName),
                    _ProfileLine(label: 'الهاتف', value: current.customerPhone),
                    const SizedBox(height: 10),
                    DriverPrimaryButton(label: 'اتصال بالعميل', icon: Icons.call, onPressed: current.customerPhone.isEmpty ? null : () => launchPhoneCall(current.customerPhone)),
                  ]),
                ),
                const SizedBox(height: 14),
                DriverCard(
                  child: Row(children: [Expanded(child: _ProfileLine(label: 'المسافة', value: '${current.distanceKm} كم')), Expanded(child: _ProfileLine(label: 'الأجرة', value: formatMoney(current.deliveryFee, current.currency)))]),
                ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [const Expanded(child: Text('طلب توصيل جديد', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900))), DriverStatusBadge(status: offer.isExpired ? 'expired' : offer.status)]),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: DriverMetricCard(icon: Icons.route, value: '${offer.distanceToPickupKm}', label: 'كم للاستلام', color: kDriverSecondary)),
              const SizedBox(width: 10),
              Expanded(child: DriverMetricCard(icon: Icons.payments, value: formatMoney(order?.deliveryFee ?? 0, order?.currency ?? 'SYP'), label: 'الأجرة', color: kDriverPrimary)),
            ],
          ),
          const SizedBox(height: 14),
          DriverRoutePoint(icon: Icons.storefront, label: 'نقطة الاستلام', value: order?.pickupAddress ?? 'غير محدد'),
          const SizedBox(height: 10),
          DriverRoutePoint(icon: Icons.location_on, label: 'نقطة التسليم', value: order?.dropoffAddress ?? 'غير محدد'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: DriverPrimaryButton(label: 'رفض', icon: Icons.close, isDanger: true, isOutlined: true, onPressed: () => _showRejectSheet(context, offer))),
              const SizedBox(width: 12),
              Expanded(child: DriverPrimaryButton(label: 'قبول', icon: Icons.check, onPressed: offer.isExpired ? null : () => _showAcceptSheet(context, offer))),
            ],
          ),
        ],
      ),
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _StatusChoice(label: 'متاح', value: 'available', current: currentStatus),
            _StatusChoice(label: 'مشغول', value: 'busy', current: currentStatus),
            _StatusChoice(label: 'غير متصل', value: 'offline', current: currentStatus),
          ],
        ),
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
      child: Row(
        children: [
          const Icon(Icons.my_location, color: kDriverSuccess),
          const SizedBox(width: 12),
          const Expanded(child: Text('تحديث موقعك الحالي', style: TextStyle(fontWeight: FontWeight.w700))),
          TextButton(onPressed: () => _postCurrentLocation(context), child: const Text('تحديث')),
        ],
      ),
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

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.title, required this.onTap, this.color = kDriverPrimary});
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(icon, color: color), title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w700)), trailing: const Icon(Icons.arrow_back_ios_new, size: 16), onTap: onTap);
  }
}

class _StepLine extends StatelessWidget {
  const _StepLine({required this.label, required this.isDone, required this.isActive});
  final String label;
  final bool isDone;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isDone ? kDriverSuccess : isActive ? kDriverAccent : kDriverMuted;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [CircleAvatar(radius: 13, backgroundColor: color.withOpacity(.16), child: Icon(isDone ? Icons.check : Icons.circle, size: 13, color: color)), const SizedBox(width: 12), Text(label, style: TextStyle(color: color, fontWeight: isActive || isDone ? FontWeight.w800 : FontWeight.w500))]),
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
  if (permission != loc.PermissionStatus.granted && permission != loc.PermissionStatus.grantedLimited) {
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
          const Text('بعد القبول سيصبح الطلب نشطاً لديك ولا يمكنك قبول طلب آخر حتى إنهائه.', style: TextStyle(color: kDriverMuted)),
          const SizedBox(height: 20),
          DriverPrimaryButton(label: 'تأكيد القبول', icon: Icons.check, onPressed: () { Navigator.of(context).pop(); context.read<DriverAppCubit>().acceptOffer(offer); }),
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
        padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('رفض الطلب', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('اكتب سبب الرفض حتى تتمكن العمليات من تحسين توزيع الطلبات.', style: TextStyle(color: kDriverMuted)),
          const SizedBox(height: 14),
          TextField(controller: controller, minLines: 2, maxLines: 4, decoration: _inputDecoration('سبب الرفض', Icons.edit_note)),
          const SizedBox(height: 18),
          DriverPrimaryButton(label: 'تأكيد الرفض', isDanger: true, icon: Icons.close, onPressed: () { Navigator.of(context).pop(); context.read<DriverAppCubit>().rejectOffer(offer, controller.text); }),
        ]),
      ),
    ),
  );
}

void _confirmLogout(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (_) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل تريد تسجيل الخروج من حساب المندوب؟'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('إلغاء')),
          FilledButton(onPressed: () { Navigator.of(context).pop(); context.read<DriverAppCubit>().logout(); }, child: const Text('خروج')),
        ],
      ),
    ),
  );
}
