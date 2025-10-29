import 'package:flutter_entity/entity.dart';

import 'base.dart';

class GetFeedStarsCountUseCase extends BaseFeedStarUseCase {
  GetFeedStarsCountUseCase._();

  static GetFeedStarsCountUseCase? _i;

  static GetFeedStarsCountUseCase get i => _i ??= GetFeedStarsCountUseCase._();

  Future<Response<int>> call(String parentPath) {
    return repository.count(params: getParams(parentPath));
  }
}
