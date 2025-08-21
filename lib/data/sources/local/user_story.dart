import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_story.dart';

class LocalUserStoryDataSource extends LocalDataSource<UserStory> {
  LocalUserStoryDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.userStories);

  @override
  UserStory build(Object? source) => UserStory.from(source);
}
