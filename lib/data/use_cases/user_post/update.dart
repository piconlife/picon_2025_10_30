import 'package:flutter_entity/entity.dart';

import '../../models/user_post.dart';
import 'base.dart';

class UpdateUserPostUseCase extends BaseUserPostUseCase {
  UpdateUserPostUseCase._();

  static UpdateUserPostUseCase? _i;

  static UpdateUserPostUseCase get i => _i ??= UpdateUserPostUseCase._();

  Future<Response<PostModel>> call(String id, Map<String, dynamic> data) {
    return repository.updateById(id, data, params: params);
  }
}
