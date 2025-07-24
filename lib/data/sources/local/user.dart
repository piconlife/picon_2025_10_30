import 'package:data_management_local_delegate/data_management_local_delegate.dart';
import 'package:in_app_database/in_app_database.dart';

import '../../../../roots/data/constants/paths.dart';
import '../../../../roots/data/models/user.dart';

class LocalUserDataSource extends InAppDataSource<User> {
  const LocalUserDataSource._({
    super.path = RootPaths.users,
    required super.database,
    super.reloadDuration,
  });

  static LocalUserDataSource? _i;

  static LocalUserDataSource get i {
    return _i ??= LocalUserDataSource._(
      database: InAppDatabase.i,
      reloadDuration: const Duration(seconds: 2),
    );
  }

  @override
  User build(Object? source) => User.from(source);
}
