import '../../app/imports/data_management.dart' show RemoteDataRepository;
import '../models/user_story.dart';
import '../sources/local/user_story.dart';
import '../sources/remote/user_story.dart';

class UserStoryRepository extends RemoteDataRepository<StoryModel> {
  UserStoryRepository({required super.source, super.backup});

  static UserStoryRepository? _i;

  static UserStoryRepository get i =>
      _i ??= UserStoryRepository(
        source: RemoteUserStoryDataSource(),
        backup: LocalUserStoryDataSource(),
      );
}
