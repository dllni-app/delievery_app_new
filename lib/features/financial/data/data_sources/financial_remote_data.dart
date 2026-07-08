import 'package:injectable/injectable.dart';

import '../../../../common/helper/src/typedef.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../../../../core/unified_api/dio/api_client.dart';
import '../../../../core/unified_api/error/api_handeler_manager.dart';
import '../models/financial_summary_response.dart';
import '../models/financial_transaction_model.dart';

@lazySingleton
class FinancialRemoteData with HandlingApiManager {
  FinancialRemoteData({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<FinancialSummaryModel> getFinancialSummary() async => wrapHandlingApi(
        tryCall: () => _apiClient.get(ApiVariables.getFinancialSummary()),
        jsonConvert: financialSummaryModelFromJson,
      );

  Future<FinancialSummaryModel> getWalletLimits() async => wrapHandlingApi(
        tryCall: () => _apiClient.get(ApiVariables.getWalletLimits()),
        jsonConvert: financialSummaryModelFromJson,
      );

  Future<List<FinancialTransactionModel>> getWalletTransactions(
    QueryParams params,
  ) async =>
      wrapHandlingApi(
        tryCall: () => _apiClient.get(ApiVariables.getWalletTransactions(params)),
        jsonConvert: financialTransactionsFromJson,
      );
}
