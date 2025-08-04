import 'package:flutter_entity/entity.dart';

import '../../models/user_memory.dart';
import 'base.dart';

class DeleteUserMemoryUseCase extends BaseUserMemoryUseCase {
  DeleteUserMemoryUseCase._();

  static DeleteUserMemoryUseCase? _i;

  static DeleteUserMemoryUseCase get i => _i ??= DeleteUserMemoryUseCase._();

  Future<Response<UserMemory>> call(String id) {
    return repository.deleteById(id, params: params);
  }
}
