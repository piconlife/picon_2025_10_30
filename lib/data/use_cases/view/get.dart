import 'package:flutter_entity/entity.dart';

import '../../models/view.dart';
import 'base.dart';

class GetViewsUseCase extends BaseViewUseCase {
  GetViewsUseCase._();

  static GetViewsUseCase? _i;

  static GetViewsUseCase get i => _i ??= GetViewsUseCase._();

  Future<Response<ViewModel>> call(String parentPath) {
    return repository.get(params: getParams(parentPath));
  }
}
