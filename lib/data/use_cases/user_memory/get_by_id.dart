import 'package:flutter_entity/entity.dart';

import '../../models/user_memory.dart';
import 'base.dart';

class GetUserMemoryUseCase extends BaseUserMemoryUseCase {
  GetUserMemoryUseCase._();

  static GetUserMemoryUseCase? _i;

  static GetUserMemoryUseCase get i => _i ??= GetUserMemoryUseCase._();

  Future<Response<UserMemory>> call({required String id, String? uid}) {
    return repository.getById(id, params: getParams(uid));
  }
}
