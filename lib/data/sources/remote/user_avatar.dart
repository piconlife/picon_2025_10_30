import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_avatar.dart';

class RemoteUserAvatarDataSource extends FirestoreDataSource<AvatarModel> {
  RemoteUserAvatarDataSource() : super(Paths.userAvatars);

  @override
  AvatarModel build(Object? source) => AvatarModel.parse(source);
}
