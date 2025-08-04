import 'package:flutter_entity/entity.dart';

import '../../models/user_story.dart';
import 'base.dart';

class UpdateUserStoryUseCase extends BaseUserStoryUseCase {
  UpdateUserStoryUseCase._();

  static UpdateUserStoryUseCase? _i;

  static UpdateUserStoryUseCase get i => _i ??= UpdateUserStoryUseCase._();

  Future<Response<UserStory>> call(String id, Map<String, dynamic> data) {
    return repository.updateById(id, data, params: params);
  }
}
