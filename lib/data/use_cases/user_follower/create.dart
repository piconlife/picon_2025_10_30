import 'package:flutter_entity/entity.dart';

import '../../models/user_follower.dart';
import 'base.dart';

class CreateUserFollowerUseCase extends BaseUserFollowerUseCase {
  CreateUserFollowerUseCase._();

  static CreateUserFollowerUseCase? _i;

  static CreateUserFollowerUseCase get i {
    return _i ??= CreateUserFollowerUseCase._();
  }

  Future<Response<UserFollower>> call(UserFollower data) {
    return repository.create(data, params: params);
  }
}
