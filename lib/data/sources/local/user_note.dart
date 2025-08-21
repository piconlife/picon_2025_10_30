import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_note.dart';

class LocalUserNoteDataSource extends LocalDataSource<UserNote> {
  LocalUserNoteDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.userNotes);

  @override
  UserNote build(Object? source) => UserNote.from(source);
}
