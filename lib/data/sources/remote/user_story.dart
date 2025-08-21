import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_story.dart';

class RemoteUserStoryDataSource extends RemoteDataSource<UserStory> {
  RemoteUserStoryDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.userStories);

  @override
  UserStory build(Object? source) => UserStory.from(source);
}
