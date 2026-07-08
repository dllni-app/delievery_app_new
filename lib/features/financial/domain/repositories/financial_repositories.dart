import '../../../../common/helper/src/typedef.dart';
import '../../data/models/financial_summary_response.dart';
import '../../data/models/financial_transaction_model.dart';

abstract class FinancialRepositories {
  DataResponse<FinancialSummaryModel> getFinancialSummary();

  DataResponse<FinancialSummaryModel> getWalletLimits();

  DataResponse<List<FinancialTransactionModel>> getWalletTransactions(
    QueryParams params,
  );
}
