import 'package:flutter_entity/entity.dart';

import 'base.dart';

class GetFeedLikesCountUseCase extends BaseFeedLikeUseCase {
  GetFeedLikesCountUseCase._();

  static GetFeedLikesCountUseCase? _i;

  static GetFeedLikesCountUseCase get i => _i ??= GetFeedLikesCountUseCase._();

  Future<Response<int>> call(String parentPath) {
    return repository.count(params: getParams(parentPath));
  }
}
