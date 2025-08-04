import 'package:flutter_entity/entity.dart';

import '../../models/user_note.dart';
import 'base.dart';

class UpdateUserNoteUseCase extends BaseUserNoteUseCase {
  UpdateUserNoteUseCase._();

  static UpdateUserNoteUseCase? _i;

  static UpdateUserNoteUseCase get i => _i ??= UpdateUserNoteUseCase._();

  Future<Response<UserNote>> call(String id, Map<String, dynamic> data) {
    return repository.updateById(id, data, params: params);
  }
}
