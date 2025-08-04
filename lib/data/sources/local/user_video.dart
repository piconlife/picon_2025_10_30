import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_video.dart';

class LocalUserVideoDataSource extends InAppDataSource<UserVideo> {
  const LocalUserVideoDataSource({
    super.path = Paths.userVideos,
    required super.database,
  });

  @override
  UserVideo build(Object? source) => UserVideo.from(source);
}
