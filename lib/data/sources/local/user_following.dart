import '../../base/in_app_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_following.dart';

class LocalUserFollowingDataSource extends InAppDataSource<FollowingModel> {
  LocalUserFollowingDataSource() : super(Paths.userFollowings);

  @override
  FollowingModel build(Object? source) => FollowingModel.parse(source);
}
