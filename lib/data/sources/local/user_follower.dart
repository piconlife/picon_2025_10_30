import '../../base/in_app_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_follower.dart';

class LocalUserFollowerDataSource extends InAppDataSource<FollowerModel> {
  LocalUserFollowerDataSource() : super(Paths.userFollowers);

  @override
  FollowerModel build(Object? source) => FollowerModel.from(source);
}
