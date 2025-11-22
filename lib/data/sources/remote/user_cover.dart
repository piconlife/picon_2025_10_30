import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_cover.dart';

class RemoteUserCoverDataSource extends FirestoreDataSource<CoverModel> {
  RemoteUserCoverDataSource() : super(Paths.userCovers);

  @override
  CoverModel build(Object? source) => CoverModel.parse(source);
}
