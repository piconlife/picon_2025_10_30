import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/feed_comment.dart';

class LocalFeedCommentDataSource extends LocalDataSource<FeedComment> {
  LocalFeedCommentDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.feedComments);

  @override
  FeedComment build(Object? source) => FeedComment.parse(source);
}
