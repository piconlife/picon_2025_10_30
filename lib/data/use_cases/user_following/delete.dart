import 'package:flutter_entity/entity.dart';

import '../../models/user_following.dart';
import 'base.dart';

class DeleteUserFollowingUseCase extends BaseUserFollowingUseCase {
  DeleteUserFollowingUseCase._();

  static DeleteUserFollowingUseCase? _i;

  static DeleteUserFollowingUseCase get i =>
      _i ??= DeleteUserFollowingUseCase._();

  Future<Response<FollowingModel>> call(String id) {
    return repository.deleteById(id, params: params);
  }
}
