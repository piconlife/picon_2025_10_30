import '../../data/delegates/firestore.dart' show FirestoreDataDelegate;
import '../../dm/src/sources/remote.dart' show RemoteDataSource;
import 'note.dart' show Note;

class NoteRemoteSource extends RemoteDataSource<Note> {
  NoteRemoteSource()
    : super(
        path: 'notes',
        documentId: 'id',
        delegate: FirestoreDataDelegate.instance,
      );

  @override
  Note build(dynamic source) => Note.from(source);
}
