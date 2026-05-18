import '../../packages/data_management.dart' show RemoteDataRepository;
import '../models/user.dart';
import '../sources/local/user.dart';
import '../sources/remote/user.dart';

class UserRepository extends RemoteDataRepository<UserModel> {
  UserRepository({required super.source, super.backup});

  static UserRepository? _i;

  static UserRepository get i =>
      _i ??= UserRepository(
        source: RemoteUserDataSource(),
        backup: LocalUserDataSource(),
      );
}
