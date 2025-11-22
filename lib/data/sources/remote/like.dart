import 'package:data_management/core.dart';

import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/like.dart';

class RemoteLikeDataSource extends FirestoreDataSource<LikeModel> {
  RemoteLikeDataSource()
    : super(
        Paths.refLikes,
        limitations: DataLimitations(maximumDeleteLimit: 1000),
      );

  @override
  LikeModel build(Object? source) => LikeModel.parse(source);
}
