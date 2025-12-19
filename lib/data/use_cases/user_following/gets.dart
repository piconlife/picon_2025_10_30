import 'package:flutter_entity/entity.dart';

import '../../models/user_following.dart';
import 'base.dart';

class UserFollowingGetsUseCase extends BaseUserFollowingUseCase {
  UserFollowingGetsUseCase._();

  static UserFollowingGetsUseCase? _i;

  static UserFollowingGetsUseCase get i => _i ??= UserFollowingGetsUseCase._();

  Future<Response<FollowingModel>> call([String? uid]) {
    return repository.get(params: getParams(uid));
  }
}
