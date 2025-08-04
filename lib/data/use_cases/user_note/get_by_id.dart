import 'package:flutter_entity/entity.dart';

import '../../models/user_note.dart';
import 'base.dart';

class GetUserNoteUseCase extends BaseUserNoteUseCase {
  GetUserNoteUseCase._();

  static GetUserNoteUseCase? _i;

  static GetUserNoteUseCase get i => _i ??= GetUserNoteUseCase._();

  Future<Response<UserNote>> call({required String id, String? uid}) {
    return repository.getById(id, params: getParams(uid));
  }
}
