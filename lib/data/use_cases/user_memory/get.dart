import 'package:flutter_entity/entity.dart';

import '../../models/user_memory.dart';
import 'base.dart';

class GetUserMemoriesUseCase extends BaseUserMemoryUseCase {
  GetUserMemoriesUseCase._();

  static GetUserMemoriesUseCase? _i;

  static GetUserMemoriesUseCase get i => _i ??= GetUserMemoriesUseCase._();

  Future<Response<UserMemory>> call([String? uid]) {
    return repository.get(params: getParams(uid));
  }
}
