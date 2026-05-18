import '../../../app/helpers/user.dart';
import '../../../packages/data_management.dart' show IterableParams;
import '../../repositories/user_cover.dart';

class BaseUserCoverUseCase {
  final UserCoverRepository repository;

  BaseUserCoverUseCase() : repository = UserCoverRepository.i;

  IterableParams get params => getParams();

  IterableParams getParams([String? uid]) {
    return IterableParams([uid ?? UserHelper.uid]);
  }
}
