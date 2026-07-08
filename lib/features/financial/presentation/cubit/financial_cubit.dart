import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/financial_summary_response.dart';
import '../../data/models/financial_transaction_model.dart';
import '../../domain/repositories/financial_repositories.dart';

part 'financial_state.dart';

@lazySingleton
class FinancialCubit extends Cubit<FinancialState> {
  FinancialCubit(this._repositories) : super(const FinancialState());

  final FinancialRepositories _repositories;

  Future<void> loadSummary() async {
    final result = await _repositories.getFinancialSummary();

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
