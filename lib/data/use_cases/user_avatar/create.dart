import 'package:flutter_entity/entity.dart';

import '../../models/user_avatar.dart';
import 'base.dart';

class CreateUserAvatarUseCase extends BaseUserAvatarUseCase {
  CreateUserAvatarUseCase._();

  static CreateUserAvatarUseCase? _i;

  static CreateUserAvatarUseCase get i => _i ??= CreateUserAvatarUseCase._();

  Future<Response<UserAvatar>> call(UserAvatar data) {
    return repository.create(data, params: params);
  }
}
