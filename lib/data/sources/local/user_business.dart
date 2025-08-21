import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_business.dart';

class LocalUserBusinessDataSource extends LocalDataSource<UserBusiness> {
  LocalUserBusinessDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.userBusiness);

  @override
  UserBusiness build(Object? source) => UserBusiness.from(source);
}
