import '../../base/in_app_data_source.dart';
import '../../constants/paths.dart';
import '../../models/feed.dart';

class LocalFeedDataSource extends InAppDataSource<FeedModel> {
  LocalFeedDataSource() : super(Paths.feeds);

  @override
  FeedModel build(Object? source) => FeedModel.parse(source);
}
