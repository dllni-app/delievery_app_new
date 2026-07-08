part of 'financial_cubit.dart';

class FinancialState extends Equatable {
  const FinancialState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.summary,
    this.transactions = const [],
  });

  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;
  final FinancialSummaryModel? summary;
  final List<FinancialTransactionModel> transactions;

  FinancialState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
    bool clearError = false,
    FinancialSummaryModel? summary,
    bool clearSummary = false,
    List<FinancialTransactionModel>? transactions,
  }) {
    return FinancialState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      summary: clearSummary ? null : summary ?? this.summary,
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isRefreshing,
        errorMessage,
        summary,
        transactions,
      ];
}
