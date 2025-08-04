import 'package:data_management/core.dart';

import '../../../app/helpers/user.dart';
import '../../repositories/user_story.dart';

class BaseUserStoryUseCase {
  final UserStoryRepository repository;

  BaseUserStoryUseCase() : repository = UserStoryRepository.i;

  IterableParams get params => getParams();

  IterableParams getParams([String? uid]) {
    return IterableParams([uid ?? UserHelper.uid]);
  }
}
