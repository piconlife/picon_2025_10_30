import 'package:flutter_entity/entity.dart';

import 'base.dart';

class GetUserFollowingCountUseCase extends BaseUserFollowingUseCase {
  GetUserFollowingCountUseCase._();

  static GetUserFollowingCountUseCase? _i;

  static GetUserFollowingCountUseCase get i =>
      _i ??= GetUserFollowingCountUseCase._();

  Future<Response<int>> call([String? uid]) {
    return repository.count(params: getParams(uid));
  }
}
