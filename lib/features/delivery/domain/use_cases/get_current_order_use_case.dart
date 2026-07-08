import 'package:injectable/injectable.dart';

import '../../../../common/helper/src/typedef.dart';
import '../../../../core/use_case/use_case.dart';
import '../../data/models/delivery_order_model.dart';
import '../repositories/delivery_repositories.dart';

@lazySingleton
class GetCurrentOrderUseCase
    implements UseCase<DeliveryOrderModel?, NoParams> {
  GetCurrentOrderUseCase({required DeliveryRepositories repositories})
      : _repositories = repositories;

  final DeliveryRepositories _repositories;

  @override
  DataResponse<DeliveryOrderModel?> call(NoParams params) async =>
      _repositories.getCurrentOrder();
}
