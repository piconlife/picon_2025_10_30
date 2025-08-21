import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_avatar.dart';

class LocalUserAvatarDataSource extends LocalDataSource<UserAvatar> {
  LocalUserAvatarDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.userAvatars);

  @override
  UserAvatar build(Object? source) => UserAvatar.parse(source);
}
