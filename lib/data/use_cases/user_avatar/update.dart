import 'package:flutter_entity/entity.dart';

import '../../models/user_avatar.dart';
import 'base.dart';

class UpdateUserAvatarUseCase extends BaseUserAvatarUseCase {
  UpdateUserAvatarUseCase._();

  static UpdateUserAvatarUseCase? _i;

  static UpdateUserAvatarUseCase get i => _i ??= UpdateUserAvatarUseCase._();

  Future<Response<UserAvatar>> call(String id, Map<String, dynamic> data) {
    return repository.updateById(id, data, params: params);
  }
}
