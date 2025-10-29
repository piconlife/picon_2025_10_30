import 'package:data_management/core.dart';

import '../../repositories/feed_star.dart';

class BaseFeedStarUseCase {
  final FeedStarRepository repository;

  BaseFeedStarUseCase() : repository = FeedStarRepository.i;

  IterableParams getParams(String parentPath) {
    return IterableParams([parentPath]);
  }
}
