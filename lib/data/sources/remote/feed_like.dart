import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/feed_like.dart';

class RemoteFeedLikeDataSource extends FirestoreDataSource<FeedLike> {
  RemoteFeedLikeDataSource({super.path = Paths.feedLikes});

  @override
  FeedLike build(Object? source) => FeedLike.parse(source);
}
