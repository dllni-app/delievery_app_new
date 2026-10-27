import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../data/models/delivery_dispute_model.dart';
import '../cubit/delivery_cubit.dart';
import '../widgets/delivery_widgets.dart';

class DeliveryDisputesPage extends StatefulWidget {
  const DeliveryDisputesPage({super.key, this.initialFilter = 'all'});

  final String initialFilter;

  @override
  State<DeliveryDisputesPage> createState() => _DeliveryDisputesPageState();
}

class _DeliveryDisputesPageState extends State<DeliveryDisputesPage> {
  late final DeliveryCubit deliveryCubit;
  late final UserBloc userBloc;
  late String _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
    deliveryCubit = getIt<DeliveryCubit>();
    userBloc = getIt<UserBloc>();
    _loadData();
  }

  Future<void> _loadData() async {
    userBloc.add(DriverGetMeEvent());
    await deliveryCubit.loadDisputes(perPage: 100);
  }

  void _setFilter(String value) => setState(() => _filter = value);

  void _showReport(DeliveryDisputeModel report) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(report.categoryLabel,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                    )),
                const SizedBox(height: 12),
                Text('رقم الطلب: ${report.orderNumber}'),
                if (report.ticketNumber.isNotEmpty)
                  Text('رقم البلاغ: ${report.ticketNumber}'),
                const SizedBox(height: 10),
                Text('الحالة: ${report.statusLabel}'),
                const SizedBox(height: 16),
                Text(report.description.isEmpty
                    ? 'لا توجد تفاصيل إضافية لهذا البلاغ.'
                    : report.description),
                if (report.resolutionLabel != null &&
                    report.resolutionLabel!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text('النتيجة: ${report.resolutionLabel!}'),
                ],
                const SizedBox(height: 12),
                Text('تأثير الثقة: ${report.trustImpactPoints} نقطة'),
                if (report.createdAt != null)
                  Text(_formatDisputeDate(report.createdAt)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Directionality(
        textDirection: TextDirection.rtl,
        child: MultiBlocListener(
          listeners: [
            BlocListener<DeliveryCubit, DeliveryState>(
              bloc: deliveryCubit,
              listenWhen: (previous, current) =>
                  previous.errorMessage != current.errorMessage &&
                  current.errorMessage != null &&
                  current.disputes.isNotEmpty,
              listener: (context, state) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
              },
            ),
          ],
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _loadData,
            child: BlocBuilder<UserBloc, UserState>(
              bloc: userBloc,
              builder: (context, userState) {
                final profile = userState.driverGetMeData.data?.data;

                return BlocBuilder<DeliveryCubit, DeliveryState>(
                  bloc: deliveryCubit,
                  builder: (context, state) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      children: [
                        _ReportsTitleRow(
                          onBackPressed: () => Navigator.of(context).maybePop(),
                        ),
                        const SizedBox(height: 24),
                        _ReportsSummarySection(
                          trustScore: profile?.trustScore ?? 0,
                          openCount: state.disputesSummary.openCount,
                          resolvedCount: state.disputesSummary.resolvedCount,
                          onOpenPressed: () => _setFilter('open'),
                          onResolvedPressed: () => _setFilter('resolved'),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'سجل البلاغات',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF191C1D),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => _setFilter('all'),
                              child: Text(
                                _filter == 'all' ? 'جميع البلاغات' : 'عرض الكل',
                              ),
                            ),
                          ],
                        ),
                        if (state.errorMessage != null) ...[
                          const SizedBox(height: 12),
                          _ReportsErrorBanner(
                            message: state.errorMessage!,
                            onRetry: _loadData,
                          ),
                        ],
                        const SizedBox(height: 12),
                        if (state.isLoading && state.disputes.isEmpty)
                          const _ReportsLoadingState()
                        else if (state.disputes.isEmpty)
                          DeliveryEmptyState(
                            title: 'لا توجد بلاغات',
                            message: 'أي بلاغات مرتبطة بالطلبات ستظهر هنا.',
                            icon: Icons.report_gmailerrorred_outlined,
                            onRetry: _loadData,
                          )
                        else if (state.disputes.where((report) =>
                            _filter == 'all' ||
                            (_filter == 'resolved'
                                ? report.isResolved : !report.isResolved)).isEmpty)
                          const DeliveryEmptyState(
                            title: 'لا توجد بلاغات ضمن هذا القسم',
                            message: 'يمكنك اختيار عرض الكل لرؤية البلاغات الأخرى.',
                          )
                        else
                          ...state.disputes.where((report) =>
                              _filter == 'all' ||
                              (_filter == 'resolved' ? report.isResolved : !report.isResolved)).map(
                            (dispute) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _DisputeHistoryCard(
                                dispute: dispute,
                                onTap: () => _showReport(dispute),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
      ),
    );
  }
}

class _ReportsTitleRow extends StatelessWidget {
  const _ReportsTitleRow({required this.onBackPressed});

  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBackPressed,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: const Size(44, 44),
          ),
<<<<<<< HEAD
          icon: const Icon(Icons.arrow_back, color: Color(0xFF191C1D)),
=======
          icon: const Icon(
            Icons.arrow_back,
            textDirection: TextDirection.ltr,
            color: Color(0xFF191C1D),
          ),
>>>>>>> bc61447a5e36324b934662cab3e9256f43648b13
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'البلاغات',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF191C1D),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReportsSummarySection extends StatelessWidget {
  const _ReportsSummarySection({
    required this.trustScore,
    required this.openCount,
    required this.resolvedCount,
    required this.onOpenPressed,
    required this.onResolvedPressed,
  });

  final num trustScore;
  final int openCount;
  final int resolvedCount;
  final VoidCallback onOpenPressed;
  final VoidCallback onResolvedPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TrustScoreCard(trustScore: trustScore),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _SummaryMetricCard(
                icon: Icons.check_circle,
                iconColor: const Color(0xFF5B4CF0),
                iconBackground: const Color(0xFFE5E0FF),
                value: resolvedCount.toString(),
                label: 'بلاغات محلولة',
                onTap: onResolvedPressed,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SummaryMetricCard(
                icon: Icons.warning_rounded,
                iconColor: const Color(0xFFB42318),
                iconBackground: const Color(0xFFFFE0DB),
                value: openCount.toString(),
                label: 'بلاغات مفتوحة',
                onTap: onOpenPressed,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TrustScoreCard extends StatelessWidget {
  const _TrustScoreCard({required this.trustScore});

  final num trustScore;

  @override
  Widget build(BuildContext context) {
    final roundedScore = trustScore.round();
    final trustLabel = _trustLabel(roundedScore);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: _surfaceDecoration(borderRadius: 20),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFE5E0FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Color(0xFF4D41DF),
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'نقاط الثقة',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF454651),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            roundedScore.toString(),
            style: const TextStyle(
              fontSize: 42,
              height: 1.1,
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFCCFBF1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              trustLabel,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF0F766E),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetricCard extends StatelessWidget {
  const _SummaryMetricCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.value,
    required this.label,
    required this.onTap,
  });

  final VoidCallback onTap;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
      padding: const EdgeInsets.all(18),
      decoration: _surfaceDecoration(borderRadius: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 28),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              color: Color(0xFF191C1D),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF454651),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _DisputeHistoryCard extends StatelessWidget {
  const _DisputeHistoryCard({required this.dispute, required this.onTap});

  final DeliveryDisputeModel dispute;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusStyle = _statusStyle(dispute);
    final trustImpactColor = _trustImpactColor(dispute.trustImpactPoints);
    final trustImpactBackground = _trustImpactBackground(
      dispute.trustImpactPoints,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
      decoration: _surfaceDecoration(
        borderRadius: 18,
      ).copyWith(border: Border.all(color: const Color(0xFFE1E3E4))),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F5),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            _categoryIcon(dispute),
                            color: const Color(0xFF454651),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dispute.categoryLabel,
                                style: const TextStyle(
                                  fontSize: 20,
                                  height: 1.25,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF191C1D),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _orderNumberLabel(dispute.orderNumber),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: statusStyle.background,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            dispute.statusLabel,
                            style: TextStyle(
                              color: statusStyle.foreground,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      dispute.description.isEmpty
                          ? 'لا توجد تفاصيل إضافية لهذا البلاغ.'
                          : dispute.description,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Color(0xFF454651),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1, color: Color(0xFFE5E7EB)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete_outline_rounded,
                                color: Color(0xFF454651),
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  _formatDisputeDate(dispute.createdAt),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF454651),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            const Text(
                              'تأثير الثقة:',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF454651),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: trustImpactBackground,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                _trustImpactLabel(dispute.trustImpactPoints),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: trustImpactColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: statusStyle.strip,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(18),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _ReportsErrorBanner extends StatelessWidget {
  const _ReportsErrorBanner({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDAD6).withValues(alpha: .45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFDAD6)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message, style: TextStyle(color: Colors.red.shade800)),
          ),
          TextButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
        ],
      ),
    );
  }
}

class _ReportsLoadingState extends StatelessWidget {
  const _ReportsLoadingState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        2,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            height: 170,
            decoration: _surfaceDecoration(borderRadius: 18),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusStyle {
  const _StatusStyle({
    required this.background,
    required this.foreground,
    required this.strip,
  });

  final Color background;
  final Color foreground;
  final Color strip;
}

BoxDecoration _surfaceDecoration({double borderRadius = 24}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: .06),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

String _trustLabel(int trustScore) {
  if (trustScore >= 90) return 'ممتاز';
  if (trustScore >= 75) return 'جيد جداً';
  if (trustScore >= 60) return 'جيد';
  return 'بحاجة لتحسين';
}

String _orderNumberLabel(String orderNumber) {
  final trimmed = orderNumber.trim();
  if (trimmed.isEmpty) return '#-';
  return trimmed.startsWith('#') ? trimmed : '#$trimmed';
}

String _formatDisputeDate(DateTime? date) {
  if (date == null) return 'غير محدد';
  return intl.DateFormat('d MMMM y', 'ar').format(date.toLocal());
}

Color _trustImpactColor(int points) {
  if (points < 0) return const Color(0xFFDC2626);
  if (points > 0) return const Color(0xFF15803D);
  return const Color(0xFF0F766E);
}

Color _trustImpactBackground(int points) {
  if (points < 0) return const Color(0xFFFEE2E2);
  if (points > 0) return const Color(0xFFDCFCE7);
  return const Color(0xFFCCFBF1);
}

String _trustImpactLabel(int points) {
  if (points == 0) return '0 نقطة';
  return '${points > 0 ? '+' : ''}$points نقطة';
}

IconData _categoryIcon(DeliveryDisputeModel dispute) {
  switch (dispute.category.trim().toLowerCase()) {
    case 'poor_quality':
      return Icons.thumb_down_alt_outlined;
    case 'property_damage':
      return Icons.broken_image_outlined;
    case 'unprofessional':
      return Icons.person_off_outlined;
    case 'billing_issue':
    case 'financial_or_verbal_dispute':
      return Icons.payments_outlined;
    case 'customer_terms_violation':
      return Icons.report_problem_outlined;
    case 'force_majeure':
      return Icons.thunderstorm_outlined;
    default:
      return Icons.report_outlined;
  }
}

_StatusStyle _statusStyle(DeliveryDisputeModel dispute) {
  switch (dispute.status.trim().toLowerCase()) {
    case 'resolved':
    case 'closed':
      return const _StatusStyle(
        background: Color(0xFFCCFBF1),
        foreground: Color(0xFF0F766E),
        strip: Color(0xFF14B8A6),
      );
    case 'rejected':
      return const _StatusStyle(
        background: Color(0xFFFEE2E2),
        foreground: Color(0xFFB42318),
        strip: Color(0xFFEF4444),
      );
    case 'under_review':
      return const _StatusStyle(
        background: Color(0xFFFFEDD5),
        foreground: Color(0xFFC2410C),
        strip: Color(0xFFF97316),
      );
    case 'open':
      return const _StatusStyle(
        background: Color(0xFFFFE0DB),
        foreground: Color(0xFFB42318),
        strip: Color(0xFFEF4444),
      );
    default:
      return const _StatusStyle(
        background: Color(0xFFE0E7FF),
        foreground: AppColors.primary,
        strip: AppColors.primary,
      );
  }
}
