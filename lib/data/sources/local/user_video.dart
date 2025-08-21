import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_video.dart';

class LocalUserVideoDataSource extends LocalDataSource<UserVideo> {
  LocalUserVideoDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.userVideos);

  @override
  UserVideo build(Object? source) => UserVideo.from(source);
}
