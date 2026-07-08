import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/use_case/use_case.dart';
import '../../data/models/financial_summary_response.dart';
import '../../data/models/financial_transaction_model.dart';
import '../../domain/repositories/financial_repositories.dart';
import '../../domain/use_cases/get_financial_summary_use_case.dart';

part 'financial_state.dart';

@lazySingleton
class FinancialCubit extends Cubit<FinancialState> {
  FinancialCubit(this._getFinancialSummaryUseCase)
      : _repositories = getIt<FinancialRepositories>(),
        super(const FinancialState());

  final GetFinancialSummaryUseCase _getFinancialSummaryUseCase;
  final FinancialRepositories _repositories;

  Future<void> loadSummary() async {
    final result = await _getFinancialSummaryUseCase(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(errorMessage: failure.message),
      ),
      (summary) => emit(
        state.copyWith(summary: summary, clearError: true),
      ),
    );
  }

  Future<void> loadWalletPage({bool refreshing = false}) async {
    emit(
      state.copyWith(
        isLoading: !refreshing,
        isRefreshing: refreshing,
        clearError: true,
      ),
    );

    final limitsResult = await _repositories.getWalletLimits();

    await limitsResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            errorMessage: failure.message,
          ),
        );
      },
      (summary) async {
        final transactionsResult = await _repositories.getWalletTransactions(
          const {'perPage': '20', 'page': '1'},
        );

        transactionsResult.fold(
          (failure) => emit(
            state.copyWith(
              isLoading: false,
              isRefreshing: false,
              summary: summary,
              errorMessage: failure.message,
            ),
          ),
          (transactions) => emit(
            state.copyWith(
              isLoading: false,
              isRefreshing: false,
              summary: summary,
              transactions: transactions,
              clearError: true,
            ),
          ),
        );
      },
    );
  }

  Future<void> refreshWallet() => loadWalletPage(refreshing: true);
}
