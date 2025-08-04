import 'package:flutter_entity/entity.dart';

import '../../models/user_note.dart';
import 'base.dart';

class GetUserNotesUseCase extends BaseUserNoteUseCase {
  GetUserNotesUseCase._();

  static GetUserNotesUseCase? _i;

  static GetUserNotesUseCase get i => _i ??= GetUserNotesUseCase._();

  Future<Response<UserNote>> call([String? uid]) {
    return repository.get(params: getParams(uid));
  }
}
