import '../../base/in_app_data_source.dart';
import '../../constants/paths.dart';
import '../../models/user_note.dart';

class LocalUserNoteDataSource extends InAppDataSource<NoteModel> {
  LocalUserNoteDataSource() : super(Paths.userNotes);

  @override
  NoteModel build(Object? source) => NoteModel.from(source);
}
