import '../../dm/src/repositories/local.dart' show LocalDataRepository;
import 'note.dart' show Note;
import 'note_local_source.dart' show NoteLocalSource;
import 'note_remote_source.dart' show NoteRemoteSource;

class NoteRepository extends LocalDataRepository<Note> {
  NoteRepository()
    : super(source: NoteLocalSource(), backup: NoteRemoteSource());
}
