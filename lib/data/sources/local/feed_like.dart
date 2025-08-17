import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/feed_like.dart';

class LocalFeedLikeDataSource extends InAppDataSource<FeedLike> {
  const LocalFeedLikeDataSource({
    super.path = Paths.feedLikes,
    required super.database,
  });

  @override
  FeedLike build(Object? source) => FeedLike.parse(source);
}
