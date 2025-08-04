import 'package:flutter_entity/entity.dart';

import '../../models/user_follower.dart';
import 'base.dart';

class GetUserFollowerUseCase extends BaseUserFollowerUseCase {
  GetUserFollowerUseCase._();

  static GetUserFollowerUseCase? _i;

  static GetUserFollowerUseCase get i => _i ??= GetUserFollowerUseCase._();

  Future<Response<UserFollower>> call({required String id, String? uid}) {
    return repository.getById(id, params: getParams(uid));
  }
}
