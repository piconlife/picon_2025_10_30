import 'package:flutter_entity/entity.dart';

import '../../models/user_video.dart';
import 'base.dart';

class DeleteUserVideoUseCase extends BaseUserVideoUseCase {
  DeleteUserVideoUseCase._();

  static DeleteUserVideoUseCase? _i;

  static DeleteUserVideoUseCase get i => _i ??= DeleteUserVideoUseCase._();

  Future<Response<UserVideo>> call(String id) {
    return repository.deleteById(id, params: params);
  }
}
