import 'package:flutter_entity/entity.dart';

import '../../models/user_story.dart';
import 'base.dart';

class DeleteUserStoryUseCase extends BaseUserStoryUseCase {
  DeleteUserStoryUseCase._();

  static DeleteUserStoryUseCase? _i;

  static DeleteUserStoryUseCase get i => _i ??= DeleteUserStoryUseCase._();

  Future<Response<UserStory>> call(String id) {
    return repository.deleteById(id, params: params);
  }
}
