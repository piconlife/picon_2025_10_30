import 'package:flutter_entity/entity.dart';

import '../../models/user_video.dart';
import 'base.dart';

class UpdateUserVideoUseCase extends BaseUserVideoUseCase {
  UpdateUserVideoUseCase._();

  static UpdateUserVideoUseCase? _i;

  static UpdateUserVideoUseCase get i => _i ??= UpdateUserVideoUseCase._();

  Future<Response<UserVideo>> call(String id, Map<String, dynamic> data) {
    return repository.updateById(id, data, params: params);
  }
}
