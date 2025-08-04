import 'package:flutter_entity/entity.dart';

import 'base.dart';

class GetUserReportCountUseCase extends BaseUserReportUseCase {
  GetUserReportCountUseCase._();

  static GetUserReportCountUseCase? _i;

  static GetUserReportCountUseCase get i =>
      _i ??= GetUserReportCountUseCase._();

  Future<Response<int>> call([String? uid]) {
    return repository.count(params: getParams(uid));
  }
}
