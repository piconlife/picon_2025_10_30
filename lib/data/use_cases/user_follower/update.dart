import 'package:flutter_entity/entity.dart';

import '../../models/user_follower.dart';
import 'base.dart';

class UpdateUserFollowerUseCase extends BaseUserFollowerUseCase {
  UpdateUserFollowerUseCase._();

  static UpdateUserFollowerUseCase? _i;

  static UpdateUserFollowerUseCase get i {
    return _i ??= UpdateUserFollowerUseCase._();
  }

  Future<Response<UserFollower>> call(String id, Map<String, dynamic> data) {
    return repository.updateById(id, data, params: params);
  }
}
