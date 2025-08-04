import 'package:flutter_entity/entity.dart';

import '../../models/user_avatar.dart';
import 'base.dart';

class DeleteUserAvatarUseCase extends BaseUserAvatarUseCase {
  DeleteUserAvatarUseCase._();

  static DeleteUserAvatarUseCase? _i;

  static DeleteUserAvatarUseCase get i => _i ??= DeleteUserAvatarUseCase._();

  Future<Response<UserAvatar>> call(String id) {
    return repository.deleteById(id, params: params);
  }
}
