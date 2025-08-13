import 'package:data_management/data_management.dart';
import 'package:in_app_database/in_app_database.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/feed_star.dart';
import '../sources/local/feed_star.dart';
import '../sources/remote/feed_star.dart';

class FeedStarRepository extends RemoteDataRepository<FeedStar> {
  FeedStarRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static FeedStarRepository? _i;

  static FeedStarRepository get i => _i ??= FeedStarRepository(
    source: RemoteFeedStarDataSource(),
    backup: LocalFeedStarDataSource(database: InAppDatabase.i),
  );
}
