import 'package:flutter_entity/entity.dart';

import '../../models/user_post.dart';
import 'base.dart';

class DeleteUserPostUseCase extends BaseUserPostUseCase {
  DeleteUserPostUseCase._();

  static DeleteUserPostUseCase? _i;

  static DeleteUserPostUseCase get i => _i ??= DeleteUserPostUseCase._();

  Future<Response<UserPost>> call(String id) {
    return repository.deleteById(id, deleteRefs: true, counter: true);
  }
}
