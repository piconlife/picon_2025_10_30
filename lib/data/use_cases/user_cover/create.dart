import 'package:flutter_entity/entity.dart';

import '../../models/user_cover.dart';
import 'base.dart';

class CreateUserCoverUseCase extends BaseUserCoverUseCase {
  CreateUserCoverUseCase._();

  static CreateUserCoverUseCase? _i;

  static CreateUserCoverUseCase get i => _i ??= CreateUserCoverUseCase._();

  Future<Response<UserCover>> call(UserCover data) {
    return repository.create(data, params: params);
  }
}
