import '../../app/imports/data_management.dart' show RemoteDataRepository;
import '../models/user_post.dart';
import '../sources/local/user_post.dart';
import '../sources/remote/user_post.dart';

class UserPostRepository extends RemoteDataRepository<PostModel> {
  UserPostRepository({required super.source, super.backup});

  static UserPostRepository? _i;

  static UserPostRepository get i =>
      _i ??= UserPostRepository(
        source: RemoteUserPostDataSource(),
        backup: LocalUserPostDataSource(),
      );
}
