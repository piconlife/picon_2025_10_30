import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_follower.dart';

class RemoteUserFollowerDataSource extends FirestoreDataSource<UserFollower> {
  RemoteUserFollowerDataSource({super.path = Paths.userFollowers});

  @override
  UserFollower build(Object? source) => UserFollower.from(source);
}
