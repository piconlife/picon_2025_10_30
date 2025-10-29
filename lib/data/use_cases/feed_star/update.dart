import 'package:flutter_entity/entity.dart';

import '../../models/feed_star.dart';
import 'base.dart';

class UpdateFeedStarUseCase extends BaseFeedStarUseCase {
  UpdateFeedStarUseCase._();

  static UpdateFeedStarUseCase? _i;

  static UpdateFeedStarUseCase get i => _i ??= UpdateFeedStarUseCase._();

  Future<Response<FeedStar>> call(
    String parentPath,
    String id,
    Map<String, dynamic> data,
  ) {
    return repository.updateById(id, data, params: getParams(parentPath));
  }
}
