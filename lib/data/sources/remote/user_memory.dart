import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_memory.dart';

class RemoteUserMemoryDataSource extends FirestoreDataSource<MemoryModel> {
  RemoteUserMemoryDataSource() : super(Paths.userMemories);

  @override
  MemoryModel build(Object? source) => MemoryModel.from(source);
}
