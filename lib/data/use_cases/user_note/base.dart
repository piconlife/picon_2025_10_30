import 'package:data_management/core.dart';

import '../../../app/helpers/user.dart';
import '../../repositories/user_note.dart';

class BaseUserNoteUseCase {
  final UserNoteRepository repository;

  BaseUserNoteUseCase() : repository = UserNoteRepository.i;

  IterableParams get params => getParams();

  IterableParams getParams([String? uid]) {
    return IterableParams([uid ?? UserHelper.uid]);
  }
}
