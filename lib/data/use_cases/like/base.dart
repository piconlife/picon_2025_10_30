import 'package:data_management/core.dart';

import '../../repositories/like.dart';

class BaseFeedLikeUseCase {
  final LikeRepository repository;

  BaseFeedLikeUseCase() : repository = LikeRepository.i;

  IterableParams getParams(String parentPath) {
    return IterableParams([parentPath]);
  }
}
