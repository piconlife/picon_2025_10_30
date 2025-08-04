import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_follower.dart';

class LocalUserFollowerDataSource extends InAppDataSource<UserFollower> {
  LocalUserFollowerDataSource({
    super.path = Paths.userFollowers,
    required super.database,
  });

  @override
  UserFollower build(Object? source) => UserFollower.from(source);
}
