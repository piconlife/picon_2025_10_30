import '../../base/in_app_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_post.dart';

class LocalUserPostDataSource extends InAppDataSource<PostModel> {
  LocalUserPostDataSource() : super(Paths.userPosts);

  @override
  PostModel build(Object? source) => PostModel.parse(source);
}
