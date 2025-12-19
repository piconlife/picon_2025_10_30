import 'package:flutter_entity/entity.dart';

import '../../models/user_following.dart';
import 'base.dart';

class UserFollowingDeleteUseCase extends BaseUserFollowingUseCase {
  UserFollowingDeleteUseCase._();

  static UserFollowingDeleteUseCase? _i;

  static UserFollowingDeleteUseCase get i =>
      _i ??= UserFollowingDeleteUseCase._();

  Future<Response<FollowingModel>> call(String id) {
    return repository.deleteById(id, params: params);
  }
}
