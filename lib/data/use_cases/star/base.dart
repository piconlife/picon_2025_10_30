import 'package:data_management/core.dart';

import '../../repositories/star.dart';

class BaseFeedStarUseCase {
  final StarRepository repository;

  BaseFeedStarUseCase() : repository = StarRepository.i;

  IterableParams getParams(String parentPath) {
    return IterableParams([parentPath]);
  }
}
