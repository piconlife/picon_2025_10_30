import 'package:flutter_entity/entity.dart';

import '../../models/feed_star.dart';
import 'base.dart';

class UpdateFeedStarUseCase extends BaseFeedStarUseCase {
  UpdateFeedStarUseCase._();

  static UpdateFeedStarUseCase? _i;

  static UpdateFeedStarUseCase get i => _i ??= UpdateFeedStarUseCase._();

  Future<Response<FeedStar>> call({
    required String referencePath,
    required String id,
    required Map<String, dynamic> data,
  }) {
    return repository.updateById(id, data, params: getParams(referencePath));
  }
}
