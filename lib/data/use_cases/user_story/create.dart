import 'package:flutter_entity/entity.dart';

import '../../models/user_story.dart';
import 'base.dart';

class CreateUserStoryUseCase extends BaseUserStoryUseCase {
  CreateUserStoryUseCase._();

  static CreateUserStoryUseCase? _i;

  static CreateUserStoryUseCase get i => _i ??= CreateUserStoryUseCase._();

  Future<Response<UserStory>> call(UserStory data) {
    return repository.create(data, params: params);
  }
}
