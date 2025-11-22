import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/star.dart';

class LocalStarDataSource extends LocalDataSource<StarModel> {
  LocalStarDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.refStars);

  @override
  StarModel build(Object? source) => StarModel.parse(source);
}
