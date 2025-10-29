import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/feed_star.dart';

class LocalFeedStarDataSource extends LocalDataSource<FeedStar> {
  LocalFeedStarDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.feedStars);

  @override
  FeedStar build(Object? source) => FeedStar.parse(source);
}
