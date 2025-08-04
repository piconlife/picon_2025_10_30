import 'package:flutter_entity/entity.dart';

import '../../models/user_note.dart';
import 'base.dart';

class CreateUserNoteUseCase extends BaseUserNoteUseCase {
  CreateUserNoteUseCase._();

  static CreateUserNoteUseCase? _i;

  static CreateUserNoteUseCase get i => _i ??= CreateUserNoteUseCase._();

  Future<Response<UserNote>> call(UserNote data) {
    return repository.create(data, params: params);
  }
}
