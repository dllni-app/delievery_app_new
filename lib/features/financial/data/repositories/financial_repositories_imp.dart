import 'package:injectable/injectable.dart';

import '../../../../common/helper/src/typedef.dart';
import '../../../../core/unified_api/error/error_handeler.dart';
import '../../domain/repositories/financial_repositories.dart';
import '../data_sources/financial_remote_data.dart';
import '../models/financial_summary_response.dart';

@LazySingleton(as: FinancialRepositories)
class FinancialRepositoriesImp
    with HandlingException
    implements FinancialRepositories {
  FinancialRepositoriesImp({required FinancialRemoteData remoteData})
      : _remoteData = remoteData;

  final FinancialRemoteData _remoteData;

  @override
  DataResponse<FinancialSummaryModel> getFinancialSummary() async =>
      wrapHandlingException(
        tryCall: () => _remoteData.getFinancialSummary(),
      );
}
