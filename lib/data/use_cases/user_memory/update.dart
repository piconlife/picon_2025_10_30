import 'package:flutter_entity/entity.dart';

import '../../models/user_memory.dart';
import 'base.dart';

class UpdateUserMemoryUseCase extends BaseUserMemoryUseCase {
  UpdateUserMemoryUseCase._();

  static UpdateUserMemoryUseCase? _i;

  static UpdateUserMemoryUseCase get i => _i ??= UpdateUserMemoryUseCase._();

  Future<Response<UserMemory>> call(String id, Map<String, dynamic> data) {
    return repository.updateById(id, data, params: params);
  }
}
