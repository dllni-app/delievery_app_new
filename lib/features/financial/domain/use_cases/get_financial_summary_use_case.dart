import 'package:injectable/injectable.dart';

import '../../../../common/helper/src/typedef.dart';
import '../../../../core/use_case/use_case.dart';
import '../../data/models/financial_summary_response.dart';
import '../repositories/financial_repositories.dart';

@lazySingleton
class GetFinancialSummaryUseCase
    implements UseCase<FinancialSummaryModel, NoParams> {
  GetFinancialSummaryUseCase({required FinancialRepositories repositories})
      : _repositories = repositories;

  final FinancialRepositories _repositories;

  @override
  DataResponse<FinancialSummaryModel> call(NoParams params) async =>
      _repositories.getFinancialSummary();
}
