import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/feed_comment.dart';

class RemoteFeedCommentDataSource extends FirestoreDataSource<FeedComment> {
  RemoteFeedCommentDataSource({super.path = Paths.feedComments});

  @override
  FeedComment build(Object? source) => FeedComment.parse(source);
}
