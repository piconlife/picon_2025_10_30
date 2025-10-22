import 'package:data_management/data_management.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/feed_video.dart';
import '../sources/local/feed_video.dart';
import '../sources/remote/feed_video.dart';

class FeedVideoRepository extends RemoteDataRepository<FeedVideo> {
  FeedVideoRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static FeedVideoRepository? _i;

  static FeedVideoRepository get i =>
      _i ??= FeedVideoRepository(
        source: RemoteFeedVideoDataSource(),
        backup: LocalFeedVideoDataSource(),
      );
}
