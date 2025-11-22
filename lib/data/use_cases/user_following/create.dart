import 'package:flutter_entity/entity.dart';

import '../../models/user_following.dart';
import 'base.dart';

class CreateUserFollowingUseCase extends BaseUserFollowingUseCase {
  CreateUserFollowingUseCase._();

  static CreateUserFollowingUseCase? _i;

  static CreateUserFollowingUseCase get i {
    return _i ??= CreateUserFollowingUseCase._();
  }

  Future<Response<FollowingModel>> call(FollowingModel data) {
    return repository.create(data, params: params);
  }
}
