import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_video.dart';

class RemoteUserVideoDataSource extends RemoteDataSource<UserVideo> {
  RemoteUserVideoDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.userVideos);

  @override
  UserVideo build(Object? source) => UserVideo.from(source);
}
