import '../../base/in_app_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_avatar.dart';

class LocalUserAvatarDataSource extends InAppDataSource<AvatarModel> {
  LocalUserAvatarDataSource() : super(Paths.userAvatars);

  @override
  AvatarModel build(Object? source) => AvatarModel.parse(source);
}
