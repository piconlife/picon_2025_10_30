import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/feed_comment.dart';

class RemoteFeedCommentDataSource extends RemoteDataSource<FeedComment> {
  RemoteFeedCommentDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.feedComments);

  @override
  FeedComment build(Object? source) => FeedComment.parse(source);
}
