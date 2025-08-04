import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/user_note.dart';

class RemoteUserNoteDataSource extends FirestoreDataSource<UserNote> {
  RemoteUserNoteDataSource({super.path = Paths.userNotes});

  @override
  UserNote build(Object? source) => UserNote.from(source);
}
