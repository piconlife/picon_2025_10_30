import '../../repositories/feed.dart';

class BaseFeedUseCase {
  final FeedRepository repository;

  BaseFeedUseCase() : repository = FeedRepository.i;
}
