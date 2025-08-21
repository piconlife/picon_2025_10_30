import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_note.dart';

class RemoteUserNoteDataSource extends RemoteDataSource<UserNote> {
  RemoteUserNoteDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.userNotes);

  @override
  UserNote build(Object? source) => UserNote.from(source);
}
