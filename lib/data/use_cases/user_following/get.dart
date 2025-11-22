import 'package:flutter_entity/entity.dart';

import '../../models/user_following.dart';
import 'base.dart';

class GetUserFollowingsUseCase extends BaseUserFollowingUseCase {
  GetUserFollowingsUseCase._();

  static GetUserFollowingsUseCase? _i;

  static GetUserFollowingsUseCase get i => _i ??= GetUserFollowingsUseCase._();

  Future<Response<FollowingModel>> call([String? uid]) {
    return repository.get(params: getParams(uid));
  }
}
