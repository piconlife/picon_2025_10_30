import 'package:flutter_entity/entity.dart';

import '../../models/user_post.dart';
import 'base.dart';

class CreateUserPostUseCase extends BaseUserPostUseCase {
  CreateUserPostUseCase._();

  static CreateUserPostUseCase? _i;

  static CreateUserPostUseCase get i => _i ??= CreateUserPostUseCase._();

  Future<Response<PostModel>> call(PostModel data) {
    return repository.create(data, params: params);
  }
}
