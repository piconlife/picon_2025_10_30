import 'package:flutter_entity/entity.dart';

import '../../models/user_avatar.dart';
import 'base.dart';

class GetUserAvatarUseCase extends BaseUserAvatarUseCase {
  GetUserAvatarUseCase._();

  static GetUserAvatarUseCase? _i;

  static GetUserAvatarUseCase get i => _i ??= GetUserAvatarUseCase._();

  Future<Response<UserAvatar>> call({required String id, String? uid}) {
    return repository.getById(id, params: getParams(uid));
  }
}
