import 'package:flutter_entity/entity.dart';

import '../../models/user_following.dart';
import 'base.dart';

class UserFollowingGetUseCase extends BaseUserFollowingUseCase {
  UserFollowingGetUseCase._();

  static UserFollowingGetUseCase? _i;

  static UserFollowingGetUseCase get i => _i ??= UserFollowingGetUseCase._();

  Future<Response<FollowingModel>> call(String id, [String? uid]) {
    return repository.getById(id, params: getParams(uid));
  }
}
