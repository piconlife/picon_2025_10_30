import 'package:flutter_entity/flutter_entity.dart';

import '../../models/user.dart';
import 'base.dart';

class UpdateUserUseCase extends BaseUserUseCase {
  UpdateUserUseCase._();

  static UpdateUserUseCase? _i;

  static UpdateUserUseCase get i => _i ??= UpdateUserUseCase._();

  Future<Response<User>> call({
    required String uid,
    required Map<String, dynamic> data,
  }) {
    return repository.updateById(uid, data);
  }
}
