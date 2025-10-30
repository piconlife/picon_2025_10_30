import 'package:flutter_entity/entity.dart';

import '../../models/view.dart';
import 'base.dart';

class DeleteViewUseCase extends BaseViewUseCase {
  DeleteViewUseCase._();

  static DeleteViewUseCase? _i;

  static DeleteViewUseCase get i => _i ??= DeleteViewUseCase._();

  Future<Response<ViewModel>> call(String parentPath, String id) {
    return repository.deleteById(id, params: getParams(parentPath));
  }
}
