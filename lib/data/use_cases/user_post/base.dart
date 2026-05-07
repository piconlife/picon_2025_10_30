import '../../../app/helpers/user.dart';
import '../../../app/imports/data_management.dart' show IterableParams;
import '../../repositories/user_post.dart';

class BaseUserPostUseCase {
  final UserPostRepository repository;

  BaseUserPostUseCase() : repository = UserPostRepository.i;

  IterableParams get params => getParams();

  IterableParams getParams([String? uid]) {
    return IterableParams([uid ?? UserHelper.uid]);
  }
}
