import 'package:flutter_entity/entity.dart';

import '../../models/user_following.dart';
import 'base.dart';

class UpdateUserFollowingUseCase extends BaseUserFollowingUseCase {
  UpdateUserFollowingUseCase._();

  static UpdateUserFollowingUseCase? _i;

  static UpdateUserFollowingUseCase get i {
    return _i ??= UpdateUserFollowingUseCase._();
  }

  Future<Response<UserFollowing>> call(String id, Map<String, dynamic> data) {
    return repository.updateById(id, data, params: params);
  }
}
