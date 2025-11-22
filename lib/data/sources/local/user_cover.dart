import '../../base/in_app_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_cover.dart';

class LocalUserCoverDataSource extends InAppDataSource<CoverModel> {
  LocalUserCoverDataSource() : super(Paths.userCovers);

  @override
  CoverModel build(Object? source) => CoverModel.parse(source);
}
