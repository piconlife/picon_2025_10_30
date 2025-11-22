import 'package:data_management/data_management.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/user_avatar.dart';
import '../sources/local/user_avatar.dart';
import '../sources/remote/user_avatar.dart';

class UserAvatarRepository extends RemoteDataRepository<AvatarModel> {
  UserAvatarRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connected,
  });

  static UserAvatarRepository? _i;

  static UserAvatarRepository get i =>
      _i ??= UserAvatarRepository(
        source: RemoteUserAvatarDataSource(),
        backup: LocalUserAvatarDataSource(),
      );
}
