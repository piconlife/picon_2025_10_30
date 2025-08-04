import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_video.dart';

class RemoteUserVideoDataSource extends FirestoreDataSource<UserVideo> {
  RemoteUserVideoDataSource({super.path = Paths.userVideos});

  @override
  UserVideo build(Object? source) => UserVideo.from(source);
}
