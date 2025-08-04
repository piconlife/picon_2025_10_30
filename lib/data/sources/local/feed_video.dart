import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/feed_video.dart';

class LocalFeedVideoDataSource extends InAppDataSource<FeedVideo> {
  const LocalFeedVideoDataSource({
    super.path = Paths.feedVideos,
    required super.database,
  });

  @override
  FeedVideo build(Object? source) => FeedVideo.from(source);
}
