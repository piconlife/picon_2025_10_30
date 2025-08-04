import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_story.dart';

class RemoteUserStoryDataSource extends FirestoreDataSource<UserStory> {
  RemoteUserStoryDataSource({super.path = Paths.userStories});

  @override
  UserStory build(Object? source) => UserStory.from(source);
}
