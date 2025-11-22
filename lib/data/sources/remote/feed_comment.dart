import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/feed_comment.dart';

class RemoteFeedCommentDataSource extends FirestoreDataSource<CommentModel> {
  RemoteFeedCommentDataSource() : super(Paths.refComments);

  @override
  CommentModel build(Object? source) => CommentModel.parse(source);
}
