import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/feed_star.dart';

class LocalFeedStarDataSource extends InAppDataSource<FeedStar> {
  const LocalFeedStarDataSource({
    super.path = Paths.feedStars,
    required super.database,
  });

  @override
  FeedStar build(Object? source) => FeedStar.from(source);
}
