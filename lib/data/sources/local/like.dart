import '../../base/in_app_data_source.dart';
import '../../constants/paths.dart';
import '../../models/like.dart';

class LocalLikeDataSource extends InAppDataSource<LikeModel> {
  LocalLikeDataSource() : super(Paths.refLikes);

  @override
  LikeModel build(Object? source) => LikeModel.parse(source);
}
