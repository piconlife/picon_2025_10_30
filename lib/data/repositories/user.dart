import 'package:data_management/core.dart';
import 'package:in_app_database/in_app_database.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/user.dart';
import '../sources/local/user.dart';
import '../sources/remote/user.dart';

class UserRepository extends RemoteDataRepository<User> {
  UserRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static UserRepository? _i;

  static UserRepository get i => _i ??= UserRepository(
    source: RemoteUserDataSource(),
    backup: LocalUserDataSource(database: InAppDatabase.i),
  );
}
