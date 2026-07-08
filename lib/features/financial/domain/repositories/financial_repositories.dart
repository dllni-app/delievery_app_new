import '../../../../common/helper/src/typedef.dart';
import '../../data/models/financial_summary_response.dart';

abstract class FinancialRepositories {
  DataResponse<FinancialSummaryModel> getFinancialSummary();
}
