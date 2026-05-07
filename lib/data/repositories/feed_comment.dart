import '../../app/imports/data_management.dart' show RemoteDataRepository;
import '../../roots/helpers/connectivity.dart';
import '../models/comment.dart';
import '../sources/local/comment.dart';
import '../sources/remote/feed_comment.dart';

class CommentRepository extends RemoteDataRepository<CommentModel> {
  CommentRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connected,
  });

  static CommentRepository? _i;

  static CommentRepository get i =>
      _i ??= CommentRepository(
        source: RemoteFeedCommentDataSource(),
        backup: LocalCommentDataSource(),
      );
}
