import 'package:flutter_entity/entity.dart';

import '../../models/user_story.dart';
import 'base.dart';

class GetUserStoriesUseCase extends BaseUserStoryUseCase {
  GetUserStoriesUseCase._();

  static GetUserStoriesUseCase? _i;

  static GetUserStoriesUseCase get i => _i ??= GetUserStoriesUseCase._();

  Future<Response<UserStory>> call([String? uid]) {
    return repository.get(params: getParams(uid));
  }
}
