import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_cover.dart';

class LocalUserCoverDataSource extends LocalDataSource<UserCover> {
  LocalUserCoverDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.userCovers);

  @override
  UserCover build(Object? source) => UserCover.parse(source);
}
