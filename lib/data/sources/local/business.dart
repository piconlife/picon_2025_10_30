import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/business.dart';

class LocalBusinessDataSource extends LocalDataSource<Business> {
  LocalBusinessDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.businesses);

  @override
  Business build(Object? source) => Business.from(source);
}
