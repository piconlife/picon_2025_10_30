import 'package:flutter_entity/entity.dart';

import '../../models/user_report.dart';
import 'base.dart';

class CreateUserReportUseCase extends BaseUserReportUseCase {
  CreateUserReportUseCase._();

  static CreateUserReportUseCase? _i;

  static CreateUserReportUseCase get i => _i ??= CreateUserReportUseCase._();

  Future<Response<UserReport>> call(UserReport data) {
    return repository.create(data, params: params);
  }
}
