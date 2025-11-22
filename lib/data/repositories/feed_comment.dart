import 'package:data_management/data_management.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/feed_comment.dart';
import '../sources/local/comment.dart';
import '../sources/remote/feed_comment.dart';

class FeedCommentRepository extends RemoteDataRepository<CommentModel> {
  FeedCommentRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connected,
  });

  static FeedCommentRepository? _i;

  static FeedCommentRepository get i =>
      _i ??= FeedCommentRepository(
        source: RemoteFeedCommentDataSource(),
        backup: LocalCommentDataSource(),
      );
}
