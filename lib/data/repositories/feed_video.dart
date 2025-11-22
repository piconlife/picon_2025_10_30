import 'package:data_management/data_management.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/feed_video.dart';
import '../sources/local/video.dart';
import '../sources/remote/feed_video.dart';

class FeedVideoRepository extends RemoteDataRepository<VideoModel> {
  FeedVideoRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connected,
  });

  static FeedVideoRepository? _i;

  static FeedVideoRepository get i =>
      _i ??= FeedVideoRepository(
        source: RemoteFeedVideoDataSource(),
        backup: LocalVideoDataSource(),
      );
}
