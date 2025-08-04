import 'package:flutter_entity/entity.dart';

import 'base.dart';

class GetUserFollowerCountUseCase extends BaseUserFollowerUseCase {
  GetUserFollowerCountUseCase._();

  static GetUserFollowerCountUseCase? _i;

  static GetUserFollowerCountUseCase get i =>
      _i ??= GetUserFollowerCountUseCase._();

  Future<Response<int>> call([String? uid]) {
    return repository.count(params: getParams(uid));
  }
}
