import 'package:data_management/core.dart';

import '../../repositories/feed_video.dart';

class BaseFeedVideoUseCase {
  final FeedVideoRepository repository;

  BaseFeedVideoUseCase() : repository = FeedVideoRepository.i;

  IterableParams getParams(String referencePath) {
    return IterableParams([referencePath]);
  }
}
