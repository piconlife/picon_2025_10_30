import 'package:flutter_entity/entity.dart';

import '../../models/user_following.dart';
import 'base.dart';

class IsAvailableUserFollowingUseCase extends BaseUserFollowingUseCase {
  IsAvailableUserFollowingUseCase._();

  static IsAvailableUserFollowingUseCase? _i;

  static IsAvailableUserFollowingUseCase get i {
    return _i ??= IsAvailableUserFollowingUseCase._();
  }

  Future<Response<UserFollowing>> call(String id, Map<String, dynamic> data) {
    return repository.checkById(id, params: params);
  }
}
