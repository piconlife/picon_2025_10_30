import 'package:flutter_entity/entity.dart';

import '../../models/view.dart';
import 'base.dart';

class GetViewUseCase extends BaseViewUseCase {
  GetViewUseCase._();

  static GetViewUseCase? _i;

  static GetViewUseCase get i => _i ??= GetViewUseCase._();

  Future<Response<ViewModel>> call(String parentPath, String id) {
    return repository.getById(id, params: getParams(parentPath));
  }
}
