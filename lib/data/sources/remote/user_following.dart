import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_following.dart';

class RemoteUserFollowingDataSource
    extends FirestoreDataSource<FollowingModel> {
  RemoteUserFollowingDataSource() : super(Paths.userFollowings);

  @override
  FollowingModel build(Object? source) => FollowingModel.parse(source);
}
