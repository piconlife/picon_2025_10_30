import 'package:flutter_entity/entity.dart';

import '../../models/user_report.dart';
import 'base.dart';

class GetUserReportsUseCase extends BaseUserReportUseCase {
  GetUserReportsUseCase._();

  static GetUserReportsUseCase? _i;

  static GetUserReportsUseCase get i => _i ??= GetUserReportsUseCase._();

  Future<Response<UserReport>> call([String? uid]) {
    return repository.get(params: getParams(uid));
  }
}
