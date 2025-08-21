import 'package:flutter_entity/entity.dart';

import 'base.dart';

class ListenFeedLikesCountUseCase extends BaseFeedLikeUseCase {
  ListenFeedLikesCountUseCase._();

  static ListenFeedLikesCountUseCase? _i;

  static ListenFeedLikesCountUseCase get i {
    return _i ??= ListenFeedLikesCountUseCase._();
  }

  Stream<Response<int>> call(String referencePath) {
    return repository.listenCount(params: getParams(referencePath));
  }
}
