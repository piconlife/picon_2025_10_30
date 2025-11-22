import '../../base/in_app_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_memory.dart';

class LocalUserMemoryDataSource extends InAppDataSource<MemoryModel> {
  LocalUserMemoryDataSource() : super(Paths.userMemories);

  @override
  MemoryModel build(Object? source) => MemoryModel.from(source);
}
