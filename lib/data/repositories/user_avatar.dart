import '../../app/imports/data_management.dart' show RemoteDataRepository;
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
