import 'package:data_management/data_management.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/feed.dart';
import '../sources/local/feed.dart';
import '../sources/remote/feed.dart';

class FeedRepository extends RemoteDataRepository<Feed> {
  FeedRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connected,
  });

  static FeedRepository? _i;

  static FeedRepository get i =>
      _i ??= FeedRepository(
        source: RemoteFeedDataSource(),
        backup: LocalFeedDataSource(),
      );
}
