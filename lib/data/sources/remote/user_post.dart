import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_post.dart';

class RemoteUserPostDataSource extends FirestoreDataSource<UserPost> {
  RemoteUserPostDataSource({super.path = Paths.userPosts});

  @override
  UserPost build(Object? source) => UserPost.parse(source);
}
