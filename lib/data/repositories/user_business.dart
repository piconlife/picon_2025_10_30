import 'package:data_management/data_management.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/user_business.dart';
import '../sources/local/user_business.dart';
import '../sources/remote/user_business.dart';

class UserBusinessRepository extends RemoteDataRepository<UserBusiness> {
  UserBusinessRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static UserBusinessRepository? _i;

  static UserBusinessRepository get i =>
      _i ??= UserBusinessRepository(
        source: RemoteUserBusinessDataSource(),
        backup: LocalUserBusinessDataSource(),
      );
}
