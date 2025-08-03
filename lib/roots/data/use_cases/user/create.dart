import 'package:flutter_entity/entity.dart';

import '../../../../data/models/user.dart';
import 'base.dart';

class CreateUserUseCase extends BaseUserUseCase {
  CreateUserUseCase._();

  static CreateUserUseCase? _i;

  static CreateUserUseCase get i => _i ??= CreateUserUseCase._();

  Future<Response<User>> call(User user) {
    return repository.create(user);
  }
}
