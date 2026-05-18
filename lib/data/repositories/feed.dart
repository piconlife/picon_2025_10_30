import '../../packages/data_management.dart' show RemoteDataRepository;
import '../models/feed.dart' show FeedModel;
import '../sources/local/feed.dart' show LocalFeedDataSource;
import '../sources/remote/feed.dart' show RemoteFeedDataSource;

class FeedRepository extends RemoteDataRepository<FeedModel> {
  FeedRepository({
    required super.source,
    super.backup,
    super.backupMode,
    super.restoreMode,
  });

  static FeedRepository? _i;

  static FeedRepository get i =>
      _i ??= FeedRepository(
        source: RemoteFeedDataSource(),
        backup: LocalFeedDataSource(),
      );
}
