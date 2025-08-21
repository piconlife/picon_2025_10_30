import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user.dart';

class LocalUserDataSource extends LocalDataSource<User> {
  LocalUserDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.users);

  @override
  User build(Object? source) => User.parse(source);
}
