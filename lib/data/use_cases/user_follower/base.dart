import 'package:data_management/core.dart';

import '../../../app/helpers/user.dart';
import '../../repositories/user_follower.dart';

class BaseUserFollowerUseCase {
  final UserFollowerRepository repository;

  BaseUserFollowerUseCase() : repository = UserFollowerRepository.i;

  IterableParams get params => getParams();

  IterableParams getParams([String? uid]) {
    return IterableParams([uid ?? UserHelper.uid]);
  }
}
