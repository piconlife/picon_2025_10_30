import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/feed.dart';

class RemoteFeedDataSource extends FirestoreDataSource<FeedModel> {
  RemoteFeedDataSource() : super(Paths.feeds);

  @override
  FeedModel build(Object? source) => FeedModel.parse(source);
}
