import 'package:flutter_entity/entity.dart';

import 'base.dart';

class GetViewsCountUseCase extends BaseViewUseCase {
  GetViewsCountUseCase._();

  static GetViewsCountUseCase? _i;

  static GetViewsCountUseCase get i => _i ??= GetViewsCountUseCase._();

  Future<Response<int>> call(String parentPath) {
    return repository.count(params: getParams(parentPath));
  }
}
