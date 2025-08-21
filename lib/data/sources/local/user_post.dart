import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_post.dart';

class LocalUserPostDataSource extends LocalDataSource<UserPost> {
  LocalUserPostDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.userPosts);

  @override
  UserPost build(Object? source) => UserPost.parse(source);
}
