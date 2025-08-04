import 'package:flutter_entity/entity.dart';

import '../../models/user_follower.dart';
import 'base.dart';

class GetUserFollowersUseCase extends BaseUserFollowerUseCase {
  GetUserFollowersUseCase._();

  static GetUserFollowersUseCase? _i;

  static GetUserFollowersUseCase get i => _i ??= GetUserFollowersUseCase._();

  Future<Response<UserFollower>> call([String? uid]) {
    return repository.get(params: getParams(uid));
  }
}
