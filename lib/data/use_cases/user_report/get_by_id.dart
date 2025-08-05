import 'package:flutter_entity/entity.dart';

import '../../models/user_report.dart';
import 'base.dart';

class GetUserReportUseCase extends BaseUserReportUseCase {
  GetUserReportUseCase._();

  static GetUserReportUseCase? _i;

  static GetUserReportUseCase get i => _i ??= GetUserReportUseCase._();

  Future<Response<UserReport>> call({required String id, String? uid}) {
    return repository.getById(id, params: getParams(uid));
  }
}
