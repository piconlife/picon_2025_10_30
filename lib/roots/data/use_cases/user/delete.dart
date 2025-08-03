import 'package:flutter_entity/entity.dart';

import '../../../../data/models/user.dart';
import 'base.dart';

class DeleteUserUseCase extends BaseUserUseCase {
  DeleteUserUseCase._();

  static DeleteUserUseCase? _i;

  static DeleteUserUseCase get i => _i ??= DeleteUserUseCase._();

  Future<Response<User>> call(String id) {
    return repository.deleteById(id);
  }
}
