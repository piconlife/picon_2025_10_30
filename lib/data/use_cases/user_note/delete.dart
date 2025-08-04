import 'package:flutter_entity/entity.dart';

import '../../models/user_note.dart';
import 'base.dart';

class DeleteUserNoteUseCase extends BaseUserNoteUseCase {
  DeleteUserNoteUseCase._();

  static DeleteUserNoteUseCase? _i;

  static DeleteUserNoteUseCase get i => _i ??= DeleteUserNoteUseCase._();

  Future<Response<UserNote>> call(String id) {
    return repository.deleteById(id, params: params);
  }
}
