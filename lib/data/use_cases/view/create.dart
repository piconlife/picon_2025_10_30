import 'package:flutter_entity/entity.dart';

import '../../models/view.dart';
import 'base.dart';

class CreateViewUseCase extends BaseViewUseCase {
  CreateViewUseCase._();

  static CreateViewUseCase? _i;

  static CreateViewUseCase get i => _i ??= CreateViewUseCase._();

  Future<Response<ViewModel>> call(ViewModel data) async {
    if (data.parentPath == null) {
      return Response.failure("Parent path required!");
    }
    return repository.create(data, params: getParams(data.parentPath!));
  }
}
