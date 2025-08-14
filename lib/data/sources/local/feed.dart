import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/feed.dart';

class LocalFeedDataSource extends InAppDataSource<Feed> {
  const LocalFeedDataSource({
    super.path = Paths.feeds,
    required super.database,
  });

  @override
  Feed build(Object? source) => Feed.parse(source);
}
