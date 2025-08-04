import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/user_note.dart';

class LocalUserNoteDataSource extends InAppDataSource<UserNote> {
  const LocalUserNoteDataSource({
    super.path = Paths.userNotes,
    required super.database,
  });

  @override
  UserNote build(Object? source) => UserNote.from(source);
}
