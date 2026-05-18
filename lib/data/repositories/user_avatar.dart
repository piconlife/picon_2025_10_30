import '../../packages/data_management.dart' show RemoteDataRepository;
import '../models/user_avatar.dart';
import '../sources/local/user_avatar.dart';
import '../sources/remote/user_avatar.dart';

class UserAvatarRepository extends RemoteDataRepository<AvatarModel> {
  UserAvatarRepository({required super.source, super.backup});

  static UserAvatarRepository? _i;

  static UserAvatarRepository get i =>
      _i ??= UserAvatarRepository(
        source: RemoteUserAvatarDataSource(),
        backup: LocalUserAvatarDataSource(),
      );
}
