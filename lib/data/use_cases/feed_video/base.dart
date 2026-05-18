import '../../../packages/data_management.dart' show IterableParams;
import '../../repositories/feed_video.dart';

class BaseFeedVideoUseCase {
  final FeedVideoRepository repository;

  BaseFeedVideoUseCase() : repository = FeedVideoRepository.i;

  IterableParams getParams(String referencePath) {
    return IterableParams([referencePath]);
  }
}
