import 'package:flutter_entity/entity.dart';

import '../../models/user_memory.dart';
import 'base.dart';

class CreateUserMemoryUseCase extends BaseUserMemoryUseCase {
  CreateUserMemoryUseCase._();

  static CreateUserMemoryUseCase? _i;

  static CreateUserMemoryUseCase get i => _i ??= CreateUserMemoryUseCase._();

  Future<Response<UserMemory>> call(UserMemory data) {
    return repository.create(data, params: params);
  }
}
