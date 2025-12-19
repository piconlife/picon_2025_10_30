import 'package:flutter_entity/entity.dart';

import '../../models/user_following.dart';
import 'base.dart';

class UserFollowingCreateUseCase extends BaseUserFollowingUseCase {
  UserFollowingCreateUseCase._();

  static UserFollowingCreateUseCase? _i;

  static UserFollowingCreateUseCase get i {
    return _i ??= UserFollowingCreateUseCase._();
  }

  Future<Response<FollowingModel>> call(FollowingModel data) {
    return repository.create(data, params: params);
  }
}
