import 'package:flutter_entity/entity.dart';

import '../../models/user.dart';
import 'base.dart';

class UpdateUserUseCase extends BaseUserUseCase {
  UpdateUserUseCase._();

  static UpdateUserUseCase? _i;

  static UpdateUserUseCase get i => _i ??= UpdateUserUseCase._();

  Future<Response<UserModel>> call(String uid, Map<String, dynamic> data) {
    return repository.updateById(uid, data);
  }
}
