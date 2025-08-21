import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_follower.dart';

class LocalUserFollowerDataSource extends LocalDataSource<UserFollower> {
  LocalUserFollowerDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.userFollowers);

  @override
  UserFollower build(Object? source) => UserFollower.from(source);
}
