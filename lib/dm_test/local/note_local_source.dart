import '../../data/delegates/local.dart' show LocalDataDelegate;
import '../../dm/src/sources/local.dart' show LocalDataSource;
import 'note.dart' show Note;

class NoteLocalSource extends LocalDataSource<Note> {
  NoteLocalSource()
    : super(
        path: 'notes',
        documentId: 'id',
        delegate: LocalDataDelegate.instance,
      );

  @override
  Note build(dynamic source) => Note.from(source);
}
