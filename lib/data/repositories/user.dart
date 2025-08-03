import 'package:data_management/core.dart';

import '../models/user.dart';
import '../sources/local/user.dart';
import '../sources/remote/user.dart';

class UserRepository extends RemoteDataRepository<User> {
  UserRepository({required super.source, super.backup});

  static UserRepository? _i;

  static UserRepository get i => _i ??= UserRepository(
    source: RemoteUserDataSource.i,
    backup: LocalUserDataSource.i,
  );
}
