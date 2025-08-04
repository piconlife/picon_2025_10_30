import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_following.dart';

class RemoteUserFollowingDataSource extends FirestoreDataSource<UserFollowing> {
  RemoteUserFollowingDataSource({super.path = Paths.userFollowings});

  @override
  UserFollowing build(Object? source) => UserFollowing.from(source);
}
