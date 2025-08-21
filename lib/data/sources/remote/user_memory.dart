import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_memory.dart';

class RemoteUserMemoryDataSource extends RemoteDataSource<UserMemory> {
  RemoteUserMemoryDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.userMemories);

  @override
  UserMemory build(Object? source) => UserMemory.from(source);
}
