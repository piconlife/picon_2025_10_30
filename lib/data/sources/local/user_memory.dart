import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_memory.dart';

class LocalUserMemoryDataSource extends LocalDataSource<UserMemory> {
  LocalUserMemoryDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.userMemories);

  @override
  UserMemory build(Object? source) => UserMemory.from(source);
}
