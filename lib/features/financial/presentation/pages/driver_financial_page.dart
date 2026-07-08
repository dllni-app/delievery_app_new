import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../delivery/presentation/widgets/delivery_widgets.dart';
import '../../data/models/financial_summary_response.dart';
import '../../data/models/financial_transaction_model.dart';
import '../cubit/financial_cubit.dart';

class DriverFinancialPage extends StatefulWidget {
  const DriverFinancialPage({super.key});

  @override
  State<DriverFinancialPage> createState() => _DriverFinancialPageState();
}

class _DriverFinancialPageState extends State<DriverFinancialPage> {
  late final FinancialCubit financialCubit;

  @override
  void initState() {
    super.initState();
    financialCubit = getIt<FinancialCubit>();
    financialCubit.loadWalletPage();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<FinancialCubit, FinancialState>(
        bloc: financialCubit,
        builder: (context, state) {
          if (state.isLoading && state.summary == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: financialCubit.refreshWallet,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                if (state.errorMessage != null) ...[
                  _FinancialErrorBanner(
                    message: state.errorMessage!,
                    onRetry: () => financialCubit.loadWalletPage(),
                  ),
                  const SizedBox(height: 12),
                ],
                _FinancialSummaryCard(summary: state.summary),
                const SizedBox(height: 16),
                const _PayoutInfoCard(),
                const SizedBox(height: 24),
                _TransactionsSection(transactions: state.transactions),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FinancialSummaryCard extends StatelessWidget {
  const _FinancialSummaryCard({required this.summary});

  final FinancialSummaryModel? summary;

  @override
  Widget build(BuildContext context) {
    final data = summary ??
        const FinancialSummaryModel(
          currentBalance: 0,
          financialLimit: 0,
          thresholdRatio: 0,
          warningLevel: 'NORMAL',
          isSuspended: false,
          currency: 'SYP',
        );
    final percent = data.thresholdPercent;
    final progress = data.thresholdRatio.clamp(0, 1).toDouble();
    final isDanger = data.warningLevel == 'STOP' || data.isSuspended;
    final showWarning = data.shouldShowWarning;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الرصيد المستحق (لك)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF454651),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDeliveryMoney(data.currentBalance, data.currency),
                      style: const TextStyle(
                        fontSize: 32,
                        height: 1.25,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                '$percent%',
                style: TextStyle(
                  color: showWarning ? Colors.red.shade700 : AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Text(
                'الحد المالي للإيقاف: ${formatDeliveryMoney(data.financialLimit, data.currency)}',
                style: const TextStyle(
                  color: Color(0xFF454651),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: progress,
              backgroundColor: const Color(0xFFE1E3E4),
              color: showWarning ? Colors.red.shade700 : AppColors.primary,
            ),
          ),
          if (showWarning) ...[
            const SizedBox(height: 24),
            _FinancialWarningBox(isDanger: isDanger),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: null,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              disabledBackgroundColor: AppColors.primary.withValues(alpha: .96),
              disabledForegroundColor: const Color(0xFFBCC3FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.payments_outlined),
            label: const Text(
              'تسديد الرصيد',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'التسديد يتم حالياً عن طريق الإدارة فقط.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFF767682)),
          ),
        ],
      ),
    );
  }
}

class _FinancialWarningBox extends StatelessWidget {
  const _FinancialWarningBox({required this.isDanger});

  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDAD6).withValues(alpha: .35),
        border: Border.all(color: const Color(0xFFFFDAD6)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.red.shade700,
            size: 28,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDanger ? 'تم الوصول إلى حد الإيقاف المالي' : 'اقتربت من حد الإيقاف المالي',
                  style: TextStyle(
                    color: Colors.red.shade800,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isDanger
                      ? 'يرجى مراجعة الإدارة لتسديد المبالغ المستحقة وإعادة تفعيل الحساب.'
                      : 'يرجى تسديد المبالغ المستحقة لتجنب إيقاف الحساب مؤقتاً.',
                  style: TextStyle(
                    color: Colors.red.shade800,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PayoutInfoCard extends StatelessWidget {
  const _PayoutInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        border: Border.all(color: const Color(0xFFC6C5D3).withValues(alpha: .55)),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFEDEEEF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info_outline, color: Color(0xFF454651)),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'استلام الأرباح',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF191C1D),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'لا يوجد محفظة إلكترونية مرتبطة بحسابك حالياً. يرجى مراجعة الإدارة لإضافة طرق سحب الأرباح الخاصة بك.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    color: Color(0xFF454651),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionsSection extends StatelessWidget {
  const _TransactionsSection({required this.transactions});

  final List<FinancialTransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    final visibleTransactions = transactions.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'آخر الحركات',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF191C1D),
                ),
              ),
            ),
            TextButton.icon(
              onPressed: transactions.length <= 4
                  ? null
                  : () => _showAllTransactions(context, transactions),
              icon: const Icon(Icons.chevron_left, size: 18),
              label: const Text('عرض الكل'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (visibleTransactions.isEmpty)
          const _EmptyTransactionsCard()
        else
          ...visibleTransactions.map(
            (transaction) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _TransactionTile(transaction: transaction),
            ),
          ),
      ],
    );
  }

  void _showAllTransactions(
    BuildContext context,
    List<FinancialTransactionModel> transactions,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          top: false,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: .72,
            minChildSize: .45,
            maxChildSize: .92,
            builder: (context, controller) => ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                const Text(
                  'كل الحركات',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                ...transactions.map(
                  (transaction) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _TransactionTile(transaction: transaction),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

  final FinancialTransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final color = transaction.isCredit ? AppColors.primary : Colors.red.shade700;
    final icon = switch (transaction.transactionType) {
      'order_fee_debit' => Icons.payments_outlined,
      'collection_credit' => Icons.account_balance_wallet_outlined,
      'manual_adjustment_debit' || 'manual_adjustment_credit' => Icons.tune,
      'dispute_penalty_debit' || 'dispute_reversal_credit' => Icons.report_problem_outlined,
      _ => transaction.isCredit ? Icons.add_card_outlined : Icons.money_off,
    };
    final prefix = transaction.isCredit ? '+' : '-';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .08),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: .12)),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF191C1D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTransactionDate(transaction.createdAt),
                  style: const TextStyle(fontSize: 12, color: Color(0xFF767682)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$prefix${formatDeliveryMoney(transaction.amount, 'ل.س')}',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTransactionsCard extends StatelessWidget {
  const _EmptyTransactionsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(Icons.receipt_long_outlined, size: 36, color: Color(0xFFC6C5D3)),
          SizedBox(height: 8),
          Text(
            'لا توجد حركات مالية بعد',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinancialErrorBanner extends StatelessWidget {
  const _FinancialErrorBanner({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDAD6).withValues(alpha: .35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFDAD6)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.red.shade800),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}

String _formatTransactionDate(DateTime? date) {
  if (date == null) return '';
  final now = DateTime.now();
  final local = date.toLocal();
  final time = TimeOfDay.fromDateTime(local);
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'ص' : 'م';
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final timeLabel = '$hour:$minute $period';

  if (now.year == local.year && now.month == local.month && now.day == local.day) {
    return 'اليوم، $timeLabel';
  }

  final yesterday = now.subtract(const Duration(days: 1));
  if (yesterday.year == local.year &&
      yesterday.month == local.month &&
      yesterday.day == local.day) {
    return 'أمس، $timeLabel';
  }

  return '${local.year}/${local.month.toString().padLeft(2, '0')}/${local.day.toString().padLeft(2, '0')}، $timeLabel';
}
