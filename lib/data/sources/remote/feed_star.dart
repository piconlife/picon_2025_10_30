import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/feed_star.dart';

class RemoteFeedStarDataSource extends FirestoreDataSource<FeedStar> {
  RemoteFeedStarDataSource({super.path = Paths.feedStars});

  @override
  FeedStar build(Object? source) => FeedStar.from(source);
}
