import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/feed_comment.dart';

class RemoteFeedCommentDataSource extends RemoteDataSource<CommentModel> {
  RemoteFeedCommentDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.refComments);

  @override
  CommentModel build(Object? source) => CommentModel.parse(source);
}
