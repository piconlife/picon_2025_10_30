import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_following.dart';

class LocalUserFollowingDataSource extends InAppDataSource<UserFollowing> {
  LocalUserFollowingDataSource({
    super.path = Paths.userFollowings,
    required super.database,
  });

  @override
  UserFollowing build(Object? source) => UserFollowing.parse(source);
}
