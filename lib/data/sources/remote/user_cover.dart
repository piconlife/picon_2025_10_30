import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_cover.dart';

class RemoteUserCoverDataSource extends FirestoreDataSource<UserCover> {
  RemoteUserCoverDataSource({super.path = Paths.userCovers});

  @override
  UserCover build(Object? source) => UserCover.parse(source);
}
