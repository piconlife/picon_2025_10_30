import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_avatar.dart';

class RemoteUserAvatarDataSource extends RemoteDataSource<UserAvatar> {
  RemoteUserAvatarDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.userAvatars);

  @override
  UserAvatar build(Object? source) => UserAvatar.parse(source);
}
