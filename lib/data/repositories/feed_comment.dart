import '../../packages/data_management.dart' show RemoteDataRepository;
import '../models/comment.dart' show CommentModel;
import '../sources/local/comment.dart' show LocalCommentDataSource;
import '../sources/remote/feed_comment.dart' show RemoteFeedCommentDataSource;

class CommentRepository extends RemoteDataRepository<CommentModel> {
  CommentRepository({required super.source, super.backup});

  static CommentRepository? _i;

  static CommentRepository get i =>
      _i ??= CommentRepository(
        source: RemoteFeedCommentDataSource(),
        backup: LocalCommentDataSource(),
      );
}
