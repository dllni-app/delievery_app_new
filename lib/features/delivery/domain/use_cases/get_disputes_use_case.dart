import 'package:injectable/injectable.dart';

import '../../../../common/helper/src/typedef.dart';
import '../../../../core/use_case/use_case.dart';
import '../../data/models/delivery_dispute_model.dart';
import '../repositories/delivery_repositories.dart';

@lazySingleton
class GetDisputesUseCase
    implements UseCase<List<DeliveryDisputeModel>, GetDisputesParams> {
  GetDisputesUseCase({required DeliveryRepositories repositories})
      : _repositories = repositories;

  final DeliveryRepositories _repositories;

  @override
  DataResponse<List<DeliveryDisputeModel>> call(GetDisputesParams params) async =>
      _repositories.getDisputes(params.getParams());
}

class GetDisputesParams with Params {
  GetDisputesParams({this.perPage = 10});

  final int perPage;

  @override
  QueryParams getParams() => {'perPage': perPage.toString()};
}
