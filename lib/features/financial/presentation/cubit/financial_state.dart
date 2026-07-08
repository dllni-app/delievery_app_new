part of 'financial_cubit.dart';

class FinancialState extends Equatable {
  const FinancialState({
    this.isLoading = false,
    this.errorMessage,
    this.summary,
  });

  final bool isLoading;
  final String? errorMessage;
  final FinancialSummaryModel? summary;

  FinancialState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    FinancialSummaryModel? summary,
    bool clearSummary = false,
  }) {
    return FinancialState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      summary: clearSummary ? null : summary ?? this.summary,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, summary];
}
