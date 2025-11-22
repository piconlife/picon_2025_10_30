import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_note.dart';

class RemoteUserNoteDataSource extends FirestoreDataSource<NoteModel> {
  RemoteUserNoteDataSource() : super(Paths.userNotes);

  @override
  NoteModel build(Object? source) => NoteModel.from(source);
}
