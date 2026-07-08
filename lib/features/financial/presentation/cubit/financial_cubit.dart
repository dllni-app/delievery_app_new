import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/use_case/use_case.dart';
import '../../data/models/financial_summary_response.dart';
import '../../domain/use_cases/get_financial_summary_use_case.dart';

part 'financial_state.dart';

@lazySingleton
class FinancialCubit extends Cubit<FinancialState> {
  FinancialCubit(this._getFinancialSummaryUseCase)
      : super(const FinancialState());

  final GetFinancialSummaryUseCase _getFinancialSummaryUseCase;

  Future<void> loadSummary() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _getFinancialSummaryUseCase(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: failure.message),
      ),
      (summary) => emit(
        state.copyWith(isLoading: false, summary: summary),
      ),
    );
  }
}
