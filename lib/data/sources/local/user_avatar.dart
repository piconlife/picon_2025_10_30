import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_avatar.dart';

class LocalUserAvatarDataSource extends InAppDataSource<UserAvatar> {
  const LocalUserAvatarDataSource({
    super.path = Paths.userAvatars,
    required super.database,
  });

  @override
  UserAvatar build(Object? source) => UserAvatar.from(source);
}
