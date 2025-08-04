import 'package:flutter_entity/entity.dart';

import 'base.dart';

class GetUserPostCountUseCase extends BaseUserPostUseCase {
  GetUserPostCountUseCase._();

  static GetUserPostCountUseCase? _i;

  static GetUserPostCountUseCase get i => _i ??= GetUserPostCountUseCase._();

  Future<Response<int>> call([String? uid]) {
    return repository.count(params: getParams(uid));
  }
}
