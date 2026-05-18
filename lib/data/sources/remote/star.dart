import '../../../packages/data_management.dart' show DataLimitations;
import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/star.dart';

class RemoteStarDataSource extends FirestoreDataSource<StarModel> {
  RemoteStarDataSource()
    : super(
        Paths.refStars,
        limitations: DataLimitations(maximumDeleteLimit: 1000),
      );

  @override
  StarModel build(Object? source) => StarModel.parse(source);
}
