import '../../../app/helpers/user.dart';
import '../../../packages/data_management.dart' show IterableParams;
import '../../repositories/user_video.dart';

class BaseUserVideoUseCase {
  final UserVideoRepository repository;

  BaseUserVideoUseCase() : repository = UserVideoRepository.i;

  IterableParams get params => getParams();

  IterableParams getParams([String? uid]) {
    return IterableParams([uid ?? UserHelper.uid]);
  }
}
