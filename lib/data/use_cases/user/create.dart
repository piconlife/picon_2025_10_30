import 'package:flutter_entity/entity.dart';

import '../../models/user.dart';
import 'base.dart';

class CreateUserUseCase extends BaseUserUseCase {
  CreateUserUseCase._();

  static CreateUserUseCase? _i;

  static CreateUserUseCase get i => _i ??= CreateUserUseCase._();

  Future<Response<UserModel>> call({required UserModel user}) {
    return repository.create(user);
  }
}
