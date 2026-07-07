import '../../../../common/helper/src/typedef.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/notification_repositories.dart';

@lazySingleton
class GetMarkUseCase implements UseCase<void, NoParams> {
  final NotificationRepositories _repositories;

  GetMarkUseCase({required NotificationRepositories repositories})
    : _repositories = repositories;

  @override
  DataResponse<void> call(NoParams params) async =>
      await _repositories.postMarkAll();
}
