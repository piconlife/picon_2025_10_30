import 'package:data_management/core.dart';

import '../../../app/helpers/user.dart';
import '../../repositories/user_following.dart';

class BaseUserFollowingUseCase {
  final UserFollowingRepository repository;

  BaseUserFollowingUseCase() : repository = UserFollowingRepository.i;

  IterableParams get params => getParams();

  IterableParams getParams([String? uid]) {
    return IterableParams([uid ?? UserHelper.uid]);
  }
}
