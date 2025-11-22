import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/feed_video.dart';

class RemoteFeedVideoDataSource extends RemoteDataSource<FeedVideo> {
  RemoteFeedVideoDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.refVideos);

  @override
  FeedVideo build(Object? source) => FeedVideo.from(source);
}
