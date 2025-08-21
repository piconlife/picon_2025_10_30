import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/feed.dart';

class RemoteFeedDataSource extends RemoteDataSource<Feed> {
  RemoteFeedDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.feeds);

  @override
  Feed build(Object? source) => Feed.parse(source);
}
