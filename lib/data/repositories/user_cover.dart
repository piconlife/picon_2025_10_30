import 'package:data_management/data_management.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/user_cover.dart';
import '../sources/local/user_cover.dart';
import '../sources/remote/user_cover.dart';

class UserCoverRepository extends RemoteDataRepository<UserCover> {
  UserCoverRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connected,
  });

  static UserCoverRepository? _i;

  static UserCoverRepository get i =>
      _i ??= UserCoverRepository(
        source: RemoteUserCoverDataSource(),
        backup: LocalUserCoverDataSource(),
      );
}
