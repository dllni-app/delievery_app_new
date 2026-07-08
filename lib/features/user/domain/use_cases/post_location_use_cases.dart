import 'package:injectable/injectable.dart';

import '../../../../common/helper/src/typedef.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/user_repositories.dart';

@lazySingleton
class PostLocationUseCases implements UseCase<void, PostLocationParams> {
  final UserRepositories _repositories;

  PostLocationUseCases({required UserRepositories repositories})
      : _repositories = repositories;

  @override
  DataResponse<void> call(PostLocationParams params) async =>
      await _repositories.postLocation(params.getBody());
}

class PostLocationParams with Params {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? speed;
  final double? heading;

  PostLocationParams({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.speed,
    this.heading,
  });

  @override
  BodyMap getBody() {
    final params = <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'speed': speed,
      'heading': heading,
    };
    params.removeWhere((key, value) => value == null);
    return params;
  }
}
