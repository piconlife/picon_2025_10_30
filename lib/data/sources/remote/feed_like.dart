import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/feed_like.dart';

class RemoteFeedLikeDataSource extends RemoteDataSource<FeedLike> {
  RemoteFeedLikeDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.feedLikes);

  @override
  FeedLike build(Object? source) => FeedLike.parse(source);
}
