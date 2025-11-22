import 'package:data_management/data_management.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/user.dart';
import '../sources/local/user.dart';
import '../sources/remote/user.dart';

class UserRepository extends RemoteDataRepository<UserModel> {
  UserRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connected,
  });

  static UserRepository? _i;

  static UserRepository get i =>
      _i ??= UserRepository(
        source: RemoteUserDataSource(),
        backup: LocalUserDataSource(),
      );
}
