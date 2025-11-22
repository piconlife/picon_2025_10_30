import '../../base/in_app_data_source.dart';
import '../../constants/paths.dart';
import '../../models/feed_comment.dart';

class LocalCommentDataSource extends InAppDataSource<CommentModel> {
  LocalCommentDataSource() : super(Paths.refComments);

  @override
  CommentModel build(Object? source) => CommentModel.parse(source);
}
