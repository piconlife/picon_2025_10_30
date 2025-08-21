import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/feed.dart';

class LocalFeedDataSource extends LocalDataSource<Feed> {
  LocalFeedDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.feeds);

  @override
  Feed build(Object? source) => Feed.parse(source);
}
