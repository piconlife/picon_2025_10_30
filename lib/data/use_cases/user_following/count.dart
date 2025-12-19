import 'package:flutter_entity/entity.dart';

import 'base.dart';

class UserFollowingCountUseCase extends BaseUserFollowingUseCase {
  UserFollowingCountUseCase._();

  static UserFollowingCountUseCase? _i;

  static UserFollowingCountUseCase get i =>
      _i ??= UserFollowingCountUseCase._();

  Future<Response<int>> call([String? uid]) {
    return repository.count(params: getParams(uid));
  }
}
