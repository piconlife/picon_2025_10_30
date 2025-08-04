import 'package:flutter_entity/entity.dart';

import '../../models/user_video.dart';
import 'base.dart';

class CreateUserVideoUseCase extends BaseUserVideoUseCase {
  CreateUserVideoUseCase._();

  static CreateUserVideoUseCase? _i;

  static CreateUserVideoUseCase get i => _i ??= CreateUserVideoUseCase._();

  Future<Response<UserVideo>> call(UserVideo data) {
    return repository.create(data, params: params);
  }
}
