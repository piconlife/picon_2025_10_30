import '../../app/imports/data_management.dart' show RemoteDataRepository;
import '../models/feed_video.dart' show VideoModel;
import '../sources/local/video.dart' show LocalVideoDataSource;
import '../sources/remote/feed_video.dart' show RemoteFeedVideoDataSource;

class FeedVideoRepository extends RemoteDataRepository<VideoModel> {
  FeedVideoRepository({required super.source, super.backup});

  static FeedVideoRepository? _i;

  static FeedVideoRepository get i =>
      _i ??= FeedVideoRepository(
        source: RemoteFeedVideoDataSource(),
        backup: LocalVideoDataSource(),
      );
}
