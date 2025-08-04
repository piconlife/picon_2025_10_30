import 'package:flutter_entity/entity.dart';

import '../../models/user_cover.dart';
import 'base.dart';

class UpdateUserCoverUseCase extends BaseUserCoverUseCase {
  UpdateUserCoverUseCase._();

  static UpdateUserCoverUseCase? _i;

  static UpdateUserCoverUseCase get i => _i ??= UpdateUserCoverUseCase._();

  Future<Response<UserCover>> call(String id, Map<String, dynamic> data) {
    return repository.updateById(id, data, params: params);
  }
}
