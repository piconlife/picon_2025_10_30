import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_story.dart';

class RemoteUserStoryDataSource extends FirestoreDataSource<StoryModel> {
  RemoteUserStoryDataSource() : super(Paths.userStories);

  @override
  StoryModel build(Object? source) => StoryModel.from(source);
}
