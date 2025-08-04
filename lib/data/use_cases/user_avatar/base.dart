import 'package:data_management/core.dart';

import '../../../app/helpers/user.dart';
import '../../repositories/user_avatar.dart';

class BaseUserAvatarUseCase {
  final UserAvatarRepository repository;

  BaseUserAvatarUseCase() : repository = UserAvatarRepository.i;

  IterableParams get params => getParams();

  IterableParams getParams([String? uid]) {
    return IterableParams([uid ?? UserHelper.uid]);
  }
}
