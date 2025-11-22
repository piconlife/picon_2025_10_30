import '../../base/in_app_data_source.dart';
import '../../constants/paths.dart';
import '../../models/star.dart';

class LocalStarDataSource extends InAppDataSource<StarModel> {
  LocalStarDataSource() : super(Paths.refStars);

  @override
  StarModel build(Object? source) => StarModel.parse(source);
}
