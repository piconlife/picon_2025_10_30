import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_memory.dart';

class RemoteUserMemoryDataSource extends FirestoreDataSource<UserMemory> {
  RemoteUserMemoryDataSource({super.path = Paths.userMemories});

  @override
  UserMemory build(Object? source) => UserMemory.from(source);
}
