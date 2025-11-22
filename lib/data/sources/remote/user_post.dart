import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_post.dart';

class RemoteUserPostDataSource extends FirestoreDataSource<PostModel> {
  RemoteUserPostDataSource() : super(Paths.userPosts);

  @override
  PostModel build(Object? source) => PostModel.parse(source);
}
