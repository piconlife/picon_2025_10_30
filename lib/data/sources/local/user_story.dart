import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_story.dart';

class LocalUserStoryDataSource extends InAppDataSource<UserStory> {
  const LocalUserStoryDataSource({
    super.path = Paths.userStories,
    required super.database,
  });

  @override
  UserStory build(Object? source) => UserStory.from(source);
}
