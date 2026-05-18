import '../../../app/helpers/user.dart';
import '../../../packages/data_management.dart' show IterableParams;
import '../../repositories/user_note.dart';

class BaseUserNoteUseCase {
  final UserNoteRepository repository;

  BaseUserNoteUseCase() : repository = UserNoteRepository.i;

  IterableParams get params => getParams();

  IterableParams getParams([String? uid]) {
    return IterableParams([uid ?? UserHelper.uid]);
  }
}
