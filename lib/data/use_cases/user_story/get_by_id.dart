import 'package:flutter_entity/entity.dart';

import '../../models/user_story.dart';
import 'base.dart';

class GetUserStoryUseCase extends BaseUserStoryUseCase {
  GetUserStoryUseCase._();

  static GetUserStoryUseCase? _i;

  static GetUserStoryUseCase get i => _i ??= GetUserStoryUseCase._();

  Future<Response<UserStory>> call({required String id, String? uid}) {
    return repository.getById(id, params: getParams(uid));
  }
}
