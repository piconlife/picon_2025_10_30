import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/feed.dart';

class RemoteFeedDataSource extends FirestoreDataSource<Feed> {
  RemoteFeedDataSource({super.path = Paths.feeds});

  @override
  Feed build(Object? source) => Feed.fromReference(source);
}
