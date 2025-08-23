import 'package:data_management/data_management.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/user_post.dart';
import '../sources/local/user_post.dart';
import '../sources/remote/user_post.dart';

class UserPostRepository extends RemoteDataRepository<UserPost> {
  UserPostRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static UserPostRepository? _i;

  static UserPostRepository get i => _i ??= UserPostRepository(
    source: RemoteUserPostDataSource(),
    backup: LocalUserPostDataSource(),
  );
}
