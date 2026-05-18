import '../../packages/data_management.dart' show RemoteDataRepository;
import '../models/user_cover.dart';
import '../sources/local/user_cover.dart';
import '../sources/remote/user_cover.dart';

class UserCoverRepository extends RemoteDataRepository<CoverModel> {
  UserCoverRepository({required super.source, super.backup});

  static UserCoverRepository? _i;

  static UserCoverRepository get i =>
      _i ??= UserCoverRepository(
        source: RemoteUserCoverDataSource(),
        backup: LocalUserCoverDataSource(),
      );
}
