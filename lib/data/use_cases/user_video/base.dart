import 'package:data_management/core.dart';

import '../../../app/helpers/user.dart';
import '../../repositories/user_video.dart';

class BaseUserVideoUseCase {
  final UserVideoRepository repository;

  BaseUserVideoUseCase() : repository = UserVideoRepository.i;

  IterableParams get params => getParams();

  IterableParams getParams([String? uid]) {
    return IterableParams([uid ?? UserHelper.uid]);
  }
}
