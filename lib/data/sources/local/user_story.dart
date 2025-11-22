import '../../base/in_app_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_story.dart';

class LocalUserStoryDataSource extends InAppDataSource<StoryModel> {
  LocalUserStoryDataSource() : super(Paths.userStories);

  @override
  StoryModel build(Object? source) => StoryModel.from(source);
}
