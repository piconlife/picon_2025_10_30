import 'package:flutter_entity/entity.dart';

import '../../models/user_follower.dart';
import 'base.dart';

class IsAvailableUserFollowerUseCase extends BaseUserFollowerUseCase {
  IsAvailableUserFollowerUseCase._();

  static IsAvailableUserFollowerUseCase? _i;

  static IsAvailableUserFollowerUseCase get i {
    return _i ??= IsAvailableUserFollowerUseCase._();
  }

  Future<Response<UserFollower>> call(String id, Map<String, dynamic> data) {
    return repository.checkById(id, params: params);
  }
}
