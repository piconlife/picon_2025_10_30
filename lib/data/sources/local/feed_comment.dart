import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/feed_comment.dart';

class LocalFeedCommentDataSource extends LocalDataSource<CommentModel> {
  LocalFeedCommentDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.refComments);

  @override
  CommentModel build(Object? source) => CommentModel.parse(source);
}
