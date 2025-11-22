import '../../repositories/feed.dart';

class FeedBaseUseCase {
  final FeedRepository repository;

  FeedBaseUseCase() : repository = FeedRepository.i;
}
