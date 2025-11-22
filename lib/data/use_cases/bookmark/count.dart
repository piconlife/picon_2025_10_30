import 'package:flutter_entity/entity.dart';

import 'base.dart';

class GetLikesCountUseCase extends BaseFeedLikeUseCase {
  GetLikesCountUseCase._();

  static GetLikesCountUseCase? _i;

  static GetLikesCountUseCase get i => _i ??= GetLikesCountUseCase._();

  Future<Response<int>> call(String parentPath) {
    return repository.count(params: getParams(parentPath));
  }
}
