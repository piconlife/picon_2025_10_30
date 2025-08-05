import 'package:flutter_entity/entity.dart';

import '../../models/user_report.dart';
import 'base.dart';

class DeleteUserReportUseCase extends BaseUserReportUseCase {
  DeleteUserReportUseCase._();

  static DeleteUserReportUseCase? _i;

  static DeleteUserReportUseCase get i => _i ??= DeleteUserReportUseCase._();

  Future<Response<UserReport>> call(String id) {
    return repository.deleteById(id, params: params);
  }
}
