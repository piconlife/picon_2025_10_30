import '../../../packages/data_management.dart' show IterableParams;
import '../../repositories/star.dart';

class BaseFeedStarUseCase {
  final StarRepository repository;

  BaseFeedStarUseCase() : repository = StarRepository.i;

  IterableParams getParams(String parentPath) {
    return IterableParams([parentPath]);
  }
}
