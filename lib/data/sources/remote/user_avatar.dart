import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_avatar.dart';

class RemoteUserAvatarDataSource extends FirestoreDataSource<UserAvatar> {
  RemoteUserAvatarDataSource({super.path = Paths.userAvatars});

  @override
  UserAvatar build(Object? source) => UserAvatar.parse(source);
}
