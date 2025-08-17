import 'package:flutter_entity/entity.dart';

import 'base.dart';

class GetFeedCommentsCountUseCase extends BaseFeedCommentUseCase {
  GetFeedCommentsCountUseCase._();

  static GetFeedCommentsCountUseCase? _i;

  static GetFeedCommentsCountUseCase get i =>
      _i ??= GetFeedCommentsCountUseCase._();

  Future<Response<int>> call(String referencePath) {
    return repository.count(params: getParams(referencePath));
  }
}
