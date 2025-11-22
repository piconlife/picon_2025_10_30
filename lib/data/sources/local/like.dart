import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/like.dart';

class LocalLikeDataSource extends LocalDataSource<LikeModel> {
  LocalLikeDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.refLikes);

  @override
  LikeModel build(Object? source) => LikeModel.parse(source);
}
