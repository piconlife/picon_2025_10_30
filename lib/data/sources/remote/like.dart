import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/like.dart';

class RemoteLikeDataSource extends RemoteDataSource<LikeModel> {
  RemoteLikeDataSource()
    : super(
        delegate: FirestoreDataDelegate.i,
        path: Paths.refLikes,
        limitations: DataLimitations(maximumDeleteLimit: 1000),
      );

  @override
  LikeModel build(Object? source) => LikeModel.parse(source);
}
