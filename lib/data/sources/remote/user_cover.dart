import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_cover.dart';

class RemoteUserCoverDataSource extends RemoteDataSource<UserCover> {
  RemoteUserCoverDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.userCovers);

  @override
  UserCover build(Object? source) => UserCover.parse(source);
}
