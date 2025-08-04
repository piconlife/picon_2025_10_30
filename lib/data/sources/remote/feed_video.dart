import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/feed_video.dart';

class RemoteFeedVideoDataSource extends FirestoreDataSource<FeedVideo> {
  RemoteFeedVideoDataSource({super.path = Paths.feedVideos});

  @override
  FeedVideo build(Object? source) => FeedVideo.from(source);
}
