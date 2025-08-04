import 'package:flutter_entity/entity.dart';

import '../../models/user_avatar.dart';
import 'base.dart';

class GetUserAvatarsUseCase extends BaseUserAvatarUseCase {
  GetUserAvatarsUseCase._();

  static GetUserAvatarsUseCase? _i;

  static GetUserAvatarsUseCase get i => _i ??= GetUserAvatarsUseCase._();

  Future<Response<UserAvatar>> call([String? uid]) {
    return repository.get(params: getParams(uid));
  }
}
