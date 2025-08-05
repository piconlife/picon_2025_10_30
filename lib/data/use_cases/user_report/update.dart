import 'package:flutter_entity/entity.dart';

import '../../models/user_report.dart';
import 'base.dart';

class UpdateUserReportUseCase extends BaseUserReportUseCase {
  UpdateUserReportUseCase._();

  static UpdateUserReportUseCase? _i;

  static UpdateUserReportUseCase get i => _i ??= UpdateUserReportUseCase._();

  Future<Response<UserReport>> call(String id, Map<String, dynamic> data) {
    return repository.updateById(id, data, params: params);
  }
}
