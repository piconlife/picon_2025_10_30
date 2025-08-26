import 'package:flutter_entity/entity.dart';

import 'base.dart';

class GetUserFeedCountUseCase extends BaseUserPostUseCase {
  GetUserFeedCountUseCase._();

  static GetUserFeedCountUseCase? _i;

  static GetUserFeedCountUseCase get i => _i ??= GetUserFeedCountUseCase._();

  Future<Response<int>> call([String? uid]) {
    return repository.count(params: getParams(uid));
  }
}
