import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_following.dart';

class RemoteUserFollowingDataSource extends RemoteDataSource<UserFollowing> {
  RemoteUserFollowingDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.userFollowings);

  @override
  UserFollowing build(Object? source) => UserFollowing.parse(source);
}
