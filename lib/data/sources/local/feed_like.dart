import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/feed_like.dart';

class LocalFeedLikeDataSource extends LocalDataSource<FeedLike> {
  LocalFeedLikeDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.feedLikes);

  @override
  FeedLike build(Object? source) => FeedLike.parse(source);
}
