import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_post.dart';

class LocalUserPostDataSource extends InAppDataSource<UserPost> {
  const LocalUserPostDataSource({
    super.path = Paths.userPosts,
    required super.database,
  });

  @override
  UserPost build(Object? source) => UserPost.parse(source);
}
