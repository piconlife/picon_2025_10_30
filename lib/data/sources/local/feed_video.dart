import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/feed_video.dart';

class LocalFeedVideoDataSource extends LocalDataSource<FeedVideo> {
  LocalFeedVideoDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.feedVideos);

  @override
  FeedVideo build(Object? source) => FeedVideo.from(source);
}
