import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_following.dart';

class LocalUserFollowingDataSource extends LocalDataSource<UserFollowing> {
  LocalUserFollowingDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.userFollowings);

  @override
  UserFollowing build(Object? source) => UserFollowing.parse(source);
}
