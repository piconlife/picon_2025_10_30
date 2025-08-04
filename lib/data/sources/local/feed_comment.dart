import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/feed_comment.dart';

class LocalFeedCommentDataSource extends InAppDataSource<FeedComment> {
  const LocalFeedCommentDataSource({
    super.path = Paths.feedComments,
    required super.database,
  });

  @override
  FeedComment build(Object? source) => FeedComment.from(source);
}
