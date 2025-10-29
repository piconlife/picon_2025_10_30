import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/feed_star.dart';

class RemoteFeedStarDataSource extends RemoteDataSource<FeedStar> {
  RemoteFeedStarDataSource()
    : super(
        delegate: FirestoreDataDelegate.i,
        path: Paths.feedStars,
        limitations: DataLimitations(maximumDeleteLimit: 1000),
      );

  @override
  FeedStar build(Object? source) => FeedStar.parse(source);
}
