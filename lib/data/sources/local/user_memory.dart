import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_memory.dart';

class LocalUserMemoryDataSource extends InAppDataSource<UserMemory> {
  const LocalUserMemoryDataSource({
    super.path = Paths.userMemories,
    required super.database,
  });

  @override
  UserMemory build(Object? source) => UserMemory.from(source);
}
