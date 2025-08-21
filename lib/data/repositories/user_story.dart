import 'package:data_management/data_management.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/user_story.dart';
import '../sources/local/user_story.dart';
import '../sources/remote/user_story.dart';

class UserStoryRepository extends RemoteDataRepository<UserStory> {
  UserStoryRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static UserStoryRepository? _i;

  static UserStoryRepository get i => _i ??= UserStoryRepository(
    source: RemoteUserStoryDataSource(),
    backup: LocalUserStoryDataSource(),
  );
}
