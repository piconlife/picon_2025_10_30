import 'package:flutter_entity/entity.dart';

import '../../models/user_follower.dart';
import 'base.dart';

class DeleteUserFollowerUseCase extends BaseUserFollowerUseCase {
  DeleteUserFollowerUseCase._();

  static DeleteUserFollowerUseCase? _i;

  static DeleteUserFollowerUseCase get i =>
      _i ??= DeleteUserFollowerUseCase._();

  Future<Response<UserFollower>> call(String id) {
    return repository.deleteById(id, params: params);
  }
}
