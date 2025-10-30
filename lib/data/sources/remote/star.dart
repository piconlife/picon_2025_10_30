import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/star.dart';

class RemoteStarDataSource extends RemoteDataSource<StarModel> {
  RemoteStarDataSource()
    : super(
        delegate: FirestoreDataDelegate.i,
        path: Paths.feedStars,
        limitations: DataLimitations(maximumDeleteLimit: 1000),
      );

  @override
  StarModel build(Object? source) => StarModel.parse(source);
}
