import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_cover.dart';

class LocalUserCoverDataSource extends InAppDataSource<UserCover> {
  const LocalUserCoverDataSource({
    super.path = Paths.userCovers,
    required super.database,
  });

  @override
  UserCover build(Object? source) => UserCover.from(source);
}
