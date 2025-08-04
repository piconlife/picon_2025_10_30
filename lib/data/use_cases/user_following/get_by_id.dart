import 'package:flutter_entity/entity.dart';

import '../../models/user_following.dart';
import 'base.dart';

class GetUserFollowingUseCase extends BaseUserFollowingUseCase {
  GetUserFollowingUseCase._();

  static GetUserFollowingUseCase? _i;

  static GetUserFollowingUseCase get i => _i ??= GetUserFollowingUseCase._();

  Future<Response<UserFollowing>> call({required String id, String? uid}) {
    return repository.getById(id, params: getParams(uid));
  }
}
