import 'package:data_management/core.dart';

import '../../repositories/feed_like.dart';

class BaseFeedLikeUseCase {
  final FeedLikeRepository repository;

  BaseFeedLikeUseCase() : repository = FeedLikeRepository.i;

  IterableParams getParams(String parentPath) {
    return IterableParams([parentPath]);
  }
}
