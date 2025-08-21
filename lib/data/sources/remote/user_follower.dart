import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_follower.dart';

class RemoteUserFollowerDataSource extends RemoteDataSource<UserFollower> {
  RemoteUserFollowerDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.userFollowers);

  @override
  UserFollower build(Object? source) => UserFollower.from(source);
}
