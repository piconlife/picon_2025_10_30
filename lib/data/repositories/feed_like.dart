import 'package:data_management/data_management.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/feed_like.dart';
import '../sources/local/feed_like.dart';
import '../sources/remote/feed_like.dart';

class FeedLikeRepository extends RemoteDataRepository<FeedLike> {
  FeedLikeRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static FeedLikeRepository? _i;

  static FeedLikeRepository get i => _i ??= FeedLikeRepository(
    source: RemoteFeedLikeDataSource(),
    backup: LocalFeedLikeDataSource(),
  );
}
