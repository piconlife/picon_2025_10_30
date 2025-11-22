import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_follower.dart';

class RemoteUserFollowerDataSource extends FirestoreDataSource<FollowerModel> {
  RemoteUserFollowerDataSource() : super(Paths.userFollowers);

  @override
  FollowerModel build(Object? source) => FollowerModel.from(source);
}
