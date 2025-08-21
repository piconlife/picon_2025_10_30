import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_post.dart';

class RemoteUserPostDataSource extends RemoteDataSource<UserPost> {
  RemoteUserPostDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.userPosts);

  @override
  UserPost build(Object? source) => UserPost.parse(source);
}
