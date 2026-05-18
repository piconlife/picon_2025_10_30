import '../../../app/helpers/user.dart';
import '../../../packages/data_management.dart' show IterableParams;
import '../../repositories/user_memory.dart';

class BaseUserMemoryUseCase {
  final UserMemoryRepository repository;

  BaseUserMemoryUseCase() : repository = UserMemoryRepository.i;

  IterableParams get params => getParams();

  IterableParams getParams([String? uid]) {
    return IterableParams([uid ?? UserHelper.uid]);
  }
}
